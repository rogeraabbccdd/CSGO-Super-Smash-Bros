// Handle fall damage, trigger_hurt and other stuff.
public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3]){
  if(DEBUG) PrintToChatAll("OnTakeDamage: %N,%f, %d", victim, damage, inflictor);
  if(IsMapTriggerHurt(inflictor)) {
    return Plugin_Continue;
  }
  else if(!(damagetype & DMG_FALL)) KnockBack(victim, damage);
  damage = 0.0;
  return Plugin_Changed;
}

// Handle weapon damage
public Action TraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup){
  if(!IsValidClient(victim)) return Plugin_Continue;
  
  if(DEBUG) PrintToChat(attacker, "TraceAttack: %N,%f", victim, damage);
  KnockBack(victim, damage);
  
  lastAttackBy[victim].attacker = attacker;

  int weapon = GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon");
  char weaponName[64];
  GetEdictClassname(weapon, weaponName, sizeof(weaponName));

  if(weapon > 0 && IsValidEdict(weapon))
  {
    Format(lastAttackBy[victim].weapon, 64, "%s", weaponName);
  }

  lastAttack[attacker] = victim;

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

void KnockBack(int victim, float damage) {
   // Code taken from TF2 Smash Bros
  // https://forums.alliedmods.net/showthread.php?p=2309303
  fPlayerDMG[victim] += (damage * fCvarDMGMultiplier);
  float totaldamage = fPlayerDMG[victim] * fCvarPushBackMultiplier;
  float vAngles[3], vReturn[3];

  vAngles[0] = fCvarAngles;
  vReturn[0] = Cosine(DegToRad(vAngles[1])) * totaldamage;
  vReturn[1] = Sine(DegToRad(vAngles[1])) * totaldamage;
  vReturn[2] = Sine(DegToRad(vAngles[0])) * totaldamage * fCvarUpwardForce;

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