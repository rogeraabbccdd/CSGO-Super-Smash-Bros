// Handle fall damage, trigger_hurt and other stuff.
public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3]){
  if(DEBUG) PrintToChatAll("OnTakeDamage: %N,%f, %d", victim, damage, inflictor);
  // Killed by trigger_hurt in map
  if(IsMapTriggerHurt(inflictor)) {
    return Plugin_Continue;
  }
  // Ignore fall damage
  else if(!(damagetype & DMG_FALL)) {
    char name[64];
    GetEdictClassname(inflictor, name, sizeof(name));

    // Handle molotov
    if (StrContains(name, "inferno") != -1 || StrContains(name, "grenade") != -1)
    {
      int owner = GetEntPropEnt(inflictor, Prop_Data, "m_hOwnerEntity");
      PrintToChatAll("owner: %N", owner);

      if(IsValidClient(owner)) {
        if(bCvarff || (!bCvarff && GetClientTeam(victim) != GetClientTeam(attacker))) {
          fPlayerDMG[victim] += damage * fClientGiveDMGMultiplier[owner] * fClientTakeDMGMultiplier[victim];
          lastAttackBy[victim].attacker = owner;
          if(StrContains(name, "inferno") != -1)  Format(lastAttackBy[victim].weapon, 64, "inferno");
          if(StrContains(name, "hegrenade") != -1)  Format(lastAttackBy[victim].weapon, 64, "hegrenade");
          lastAttack[owner] = victim;
        }
      }
      else fPlayerDMG[victim] += damage * fClientTakeDMGMultiplier[victim];
    }
    // other damage
    else {
      fPlayerDMG[victim] += damage * fClientTakeDMGMultiplier[victim];
    }
    KnockBack(victim);
  }
  damage = 0.0;
  return Plugin_Changed;
}

// Handle weapon damage
public Action TraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup){
  if(!IsValidClient(victim)) return Plugin_Continue;
  
  if(bCvarff || (!bCvarff && GetClientTeam(victim) != GetClientTeam(attacker)))
  {
    float dmgadd = damage * fClientGiveDMGMultiplier[attacker] * fClientTakeDMGMultiplier[victim];
    fPlayerDMG[victim] += dmgadd;
    
    if(DEBUG) PrintToChat(attacker, "TraceAttack: %N,%f", victim, damage);
    
    KnockBack(victim);
  
    lastAttackBy[victim].attacker = attacker;

    int weapon = GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon");
    char weaponName[64];
    GetEdictClassname(weapon, weaponName, sizeof(weaponName));

    if(weapon > 0 && IsValidEdict(weapon))
    {
      Format(lastAttackBy[victim].weapon, 64, "%s", weaponName);
    }

    lastAttack[attacker] = victim;
  }

  damage = 0.0;

  return Plugin_Changed;
}

public void FakeDeath(int victim, int attacker)
{
  Event event = CreateEvent("player_death");
  SetEventBool(event, "sourcemod", true);
  event.SetInt("attacker", GetClientUserId(attacker));
  event.SetInt("userid", GetClientUserId(victim));
  event.Fire()
}

void KnockBack(int victim) {
  // Code taken from TF2 Smash Bros
  // https://forums.alliedmods.net/showthread.php?p=2309303
  float totaldamage = fPlayerDMG[victim] * fClientPushBackMultiplier[victim];
  float vAngles[3], vReturn[3];

  vAngles[0] = fClientAngles[victim];
  vReturn[0] = Cosine(DegToRad(vAngles[1])) * totaldamage;
  vReturn[1] = Sine(DegToRad(vAngles[1])) * totaldamage;
  vReturn[2] = Sine(DegToRad(vAngles[0])) * totaldamage * fClientUpwardForce[victim];

  TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vReturn);
}

bool IsMapTriggerHurt(int entity) {
  bool result = false;
  for(int i=0;i<TriggerCount;i++) {
    if(entity == TriggerHurts[i]) {
      result = true;
      break;
    }
  }
  return result;
}

void ResetClientStatus(int client) {
  fClientUpwardForce[client] = fCvarUpwardForce;
  fClientAngles[client] = fCvarAngles;
  fClientGiveDMGMultiplier[client] = fCvarGiveDMGMultiplier;
  fClientTakeDMGMultiplier[client] = fCvarTakeDMGMultiplier;
  fClientPushBackMultiplier[client] = fCvarPushBackMultiplier;
  
  lastAttackBy[client].attacker = -1;
  Format(lastAttackBy[client].weapon, 64, "");
  lastAttack[client] = -1;
}
