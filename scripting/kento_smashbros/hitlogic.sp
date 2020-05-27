// Handle fall damage
public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3]){
  if(RoundToCeil(damage) > MAXHEALTHCHECK) {
    return Plugin_Continue;
  }
  damage = 0.0;
  return Plugin_Changed;
}

// Handle weapon damage
public Action TraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup){

  if(!IsValidClient(victim)) return Plugin_Continue;

  // Code taken from TF2 Smash Bros
  // https://forums.alliedmods.net/showthread.php?p=2309303
  fPlayerDMG[victim] += (damage * fCvarDMGMultiplier);
  float totaldamage = fPlayerDMG[victim] * 3.0;
  float vAngles[3], vReturn[3];

  vAngles[0] = fCvarAngles;
  vReturn[0] = Cosine(DegToRad(vAngles[1])) * totaldamage;
  vReturn[1] = Sine(DegToRad(vAngles[1])) * totaldamage;
  vReturn[2] = Sine(DegToRad(vAngles[0])) * totaldamage * fCvarUpwardForce;

  TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vReturn);

  lastAttack[victim].attacker = attacker;

  int weapon = GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon");
  
  char weaponName[64];
  GetEdictClassname(weapon, weaponName, sizeof(weaponName));

  if(weapon > 0 && IsValidEdict(weapon))
  {
    Format(lastAttack[victim].weapon, 64, "%s", weaponName);
  }

  damage = 0.0;

  return Plugin_Changed;
}

public bool KnockbackTRFilter(int entity, int contentsMask)
{
  if (entity > 0 && entity < MAXPLAYERS)  return false;
  return true;
}

public void FakeDeath(int victim, int attacker)
{
  Event event = CreateEvent("player_death");
  SetEventBool(event, "sourcemod", true);
  event.SetInt("attacker", GetClientUserId(attacker));
  event.SetInt("userid", GetClientUserId(victim));
  event.Fire()
}
