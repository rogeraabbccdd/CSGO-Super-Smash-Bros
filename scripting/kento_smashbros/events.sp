public Action Event_PlayerSpawn (Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  
  if(IsValidClient(client)) {
    fPlayerDMG[client] = 0.0;
    if(!IsFakeClient(client)) {
      PrintDmgTimer[client] = CreateTimer(0.1, PrintDmg, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
    }
  }
}

public Action PrintDmg (Handle timer, int client) {
  if(IsValidClient(client) && !IsFakeClient(client)) PrintHintText(client, "%f %", fPlayerDMG[client]);
}

public Action Event_PlayerDeath (Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  if(PrintDmgTimer[client] != INVALID_HANDLE)
  {
    KillTimer(PrintDmgTimer[client]);
    PrintDmgTimer[client] = INVALID_HANDLE;
  }

  if(IsValidClient(lastAttack[client].attacker)) {
    event.SetInt("attacker", GetClientUserId(lastAttack[client].attacker));
    event.SetString("weapon", lastAttack[client].weapon);
  }

  lastAttack[client].attacker = 0;

  return Plugin_Continue;
}

public Action Event_RoundStart (Event event, const char[] name, bool dontBroadcast)
{
  if(spawnroundstart) SpawnItems();
  if(spawninterval > 0.0) {
    if(itemTimer != INVALID_HANDLE)
    {
      KillTimer(itemTimer);
      itemTimer = INVALID_HANDLE;
    }
    itemTimer = CreateTimer(spawninterval, SpawnItemTimer, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
  }
}