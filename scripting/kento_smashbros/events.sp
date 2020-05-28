public Action Event_PlayerSpawn (Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  
  if(IsValidClient(client)) {
    fPlayerDMG[client] = 0.0;
  }
}

public Action PrintDmg (Handle timer, int client) {
  if(IsValidClient(client) && !IsFakeClient(client)) PrintHintText(client, "%f %", fPlayerDMG[client]);
}

public Action Event_PlayerDeath (Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));

  if(IsValidClient(lastAttackBy[client].attacker)) {
    event.SetInt("attacker", GetClientUserId(lastAttackBy[client].attacker));
    event.SetString("weapon", lastAttackBy[client].weapon);
  }

  lastAttackBy[client].attacker = 0;
  Format(lastAttackBy[client].weapon, 64, "");

  for (int i = 1; i <= MaxClients; i++)
  {
    if(lastAttack[i] == client) lastAttack[i] = 0;
  }

  return Plugin_Continue;
}

public Action Event_RoundStart (Event event, const char[] name, bool dontBroadcast)
{
  if(spawnroundstart) SpawnItems();
  if(spawninterval > 0.0) {
    if(itemTimer != INVALID_HANDLE)
    {
      KillTimer(itemTimer);
    }
    itemTimer = INVALID_HANDLE;
    itemTimer = CreateTimer(spawninterval, SpawnItemTimer, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
  }

  if(bgmCount > 0) {
    int prevBGM = currentBGM;
    currentBGM = GetRandomInt(0, bgmCount-1);

    for (int i = 1; i <= MaxClients; i++)
    {
      if(IsValidClient(i) && !IsFakeClient(i))
      {
        StopBGM(i, prevBGM);
        KillBGMTimer(i);
        
        hBGMTimer[i] = CreateTimer(0.5, BGMTimer, i);
      }
    }
  }
}