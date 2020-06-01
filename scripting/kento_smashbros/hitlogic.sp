// Handle fall damage, trigger_hurt and other stuff.
public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3]){
  if(DEBUG) PrintToChatAll("OnTakeDamage: %N,%f, %d", victim, damage, inflictor);

  // Killed by trigger_hurt in map
  if(IsMapTriggerHurt(inflictor)) {
    if(DEBUG) PrintToChatAll("Is map trigger");
    return Plugin_Continue;
  }

  // Not hitting player
  if(!IsValidClient(victim)) {
    return Plugin_Continue;
  }

  // Ignore fall damage
  else if(!(damagetype & DMG_FALL) && damage > 0.0) {
    char name[64];
    GetEdictClassname(inflictor, name, sizeof(name));

    float dmgadd;

    // Handle molotov
    if (StrContains(name, "inferno") != -1 || StrContains(name, "grenade") != -1)
    {
      int owner = GetEntPropEnt(inflictor, Prop_Data, "m_hOwnerEntity");
      if(DEBUG) PrintToChatAll("owner: %N", owner);

      if(IsValidClient(owner)) {
        if(bCvarff || (!bCvarff && GetClientTeam(victim) != GetClientTeam(attacker))) {
          dmgadd = damage * fClientGiveDMGMultiplier[owner] * fClientTakeDMGMultiplier[victim];
          fPlayerDMG[victim] += dmgadd;
          lastAttackBy[victim].attacker = owner;
          if(StrContains(name, "inferno") != -1)  Format(lastAttackBy[victim].weapon, 64, "inferno");
          if(StrContains(name, "hegrenade") != -1)  Format(lastAttackBy[victim].weapon, 64, "hegrenade");
          lastAttack[owner] = victim;
          KnockBack(victim);
        }
      }
      else {
        dmgadd = damage * fClientTakeDMGMultiplier[victim];
        fPlayerDMG[victim] += dmgadd;
        KnockBack(victim);
      }
    }
    // other damage
    else {
      dmgadd = damage * fClientTakeDMGMultiplier[victim];
      fPlayerDMG[victim] += dmgadd;
      KnockBack(victim);
    }

    Call_StartForward(OnSBTakeDamage);
    Call_PushCell(victim);
    Call_PushCell(attacker);
    Call_PushCell(inflictor);
    Call_PushFloat(dmgadd);
    Call_Finish();
  }
  damage = 0.0;
  return Plugin_Changed;
}

// Handle weapon damage
public Action TraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup){
  if(!IsValidClient(victim) || !IsValidClient(attacker)) return Plugin_Continue;

  if(bCvarff || (!bCvarff && GetClientTeam(victim) != GetClientTeam(attacker)))
  {
    float hitmultiplier = 1.0;
    switch(hitgroup){
      case 1:
      {
        hitmultiplier = fCvarhead_multiplier;
      }
      case 2:
      {
        hitmultiplier = fCvarchest_multiplier;
      }
      case 3:
      {
        hitmultiplier = fCvarstomach_multiplier;
      }
      case 4:
      {
        hitmultiplier = fCvarleftarm_multiplier;
      }
      case 5:
      {
        hitmultiplier = fCvarrightarm_multiplier;
      }
      case 6:
      {
        hitmultiplier = fCvarleftleg_multiplier;
      }
      case 7:
      {
        hitmultiplier = fCvarrightleg_multiplier;
      }
    }

    float dmgadd = damage * hitmultiplier * fClientGiveDMGMultiplier[attacker] * fClientTakeDMGMultiplier[victim];
    fPlayerDMG[victim] += dmgadd;
    
    if(DEBUG) PrintToChat(attacker, "TraceAttack: %N,%f, %d", victim, damage, hitgroup);
    
    KnockBack(victim, attacker);
  
    lastAttackBy[victim].attacker = attacker;

    int weapon = GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon");
    char weaponName[64];
    GetWeaponClassName(weapon, weaponName, sizeof(weaponName));
    if(DEBUG) PrintToChat(attacker, "weaponname %s", weaponName);
    
    if(weapon > 0 && IsValidEdict(weapon))
    {
      Format(lastAttackBy[victim].weapon, 64, "%s", weaponName);
    }

    lastAttack[attacker] = victim;

    Call_StartForward(OnSBTakeDamage);
    Call_PushCell(victim);
    Call_PushCell(attacker);
    Call_PushCell(inflictor);
    Call_PushFloat(dmgadd);
    Call_Finish();
  }

  damage = 0.0;

  return Plugin_Changed;
}

void KnockBack(int victim, int attacker = -1) {
  // Code taken from TF2 Smash Bros
  // https://forums.alliedmods.net/showthread.php?p=2309303
  float totaldamage = fPlayerDMG[victim] * fClientPushBackMultiplier[victim];
  float vAngles[3], vReturn[3];

  vAngles[0] = fClientAngles[victim];

  if(attacker != -1)
  {
    float atkpos[3], victimpos[3];

    GetClientAbsOrigin(attacker, atkpos);
    GetEntPropVector(victim, Prop_Data, "m_vecAbsOrigin", victimpos);
    MakeVectorFromPoints(atkpos, victimpos, vReturn);
    NormalizeVector(vReturn, vReturn);
    ScaleVector(vReturn, totaldamage);

    // vReturn[0] = Cosine(DegToRad(vAngles[1])) * totaldamage * -1.0;
    // vReturn[1] = Sine(DegToRad(vAngles[1])) * totaldamage * -1.0;
    vReturn[2] = Sine(DegToRad(vAngles[0])) * totaldamage * fClientUpwardForce[victim];
  }
  else {
    vReturn[0] = Cosine(DegToRad(vAngles[1])) * totaldamage * -1.0;
    vReturn[1] = Sine(DegToRad(vAngles[1])) * totaldamage * -1.0;
    vReturn[2] = Sine(DegToRad(vAngles[0])) * totaldamage * fClientUpwardForce[victim];
  }

  if (GetEntityFlags(victim) & FL_ONGROUND)
  {
    char path[300];

    if(fPlayerDMG[victim] >= 300.0) Format(path, sizeof(path), "*/kento_smashbros/sfx/blowaway_l.mp3");
    else if(fPlayerDMG[victim] >= 200.0)  Format(path, sizeof(path), "*/kento_smashbros/sfx/blowaway_m.mp3");
    else if(fPlayerDMG[victim] >= 100.0)  Format(path, sizeof(path), "*/kento_smashbros/sfx/blowaway_s.mp3");

    for (int i = 1; i <= MaxClients; i++)
    {
      if(IsValidClient(i) && !IsFakeClient(i))
      {
        EmitSoundToClient(i, path, victim, SNDCHAN_STATIC, SNDLEVEL_NONE, _, fvol[i]);
      }
    }
  }

  TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vReturn);

  Call_StartForward(OnClientKnockBack);
  Call_PushCell(victim);
  Call_PushCell(attacker);
  Call_PushArray(vReturn, sizeof(vReturn));
  Call_Finish();
}
