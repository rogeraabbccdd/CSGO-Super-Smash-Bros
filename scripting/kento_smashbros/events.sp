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
  
  if(spawninterval > 0.0) StartRoundItemTimer();

  StartRoundBGM();

  for (int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i))
    {
      ResetClientStatus(i);
    }
  }

  if(!bWarmUp) {
    freezetime = iCvarFreezetime;
    freezetimeTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
  }
}

public Action Countdown(Handle timer)
{
  freezetime--;
  if(freezetime <= 3)
  {
    char snd[64];
    Format(snd, sizeof(snd), "*/kento_smashbros/sfx/%d.mp3", freezetime);
    
    char overlay[64];
    if(freezetime > -1)  Format(overlay, sizeof(overlay), "kento_smashbros/%d", freezetime);
    else if(freezetime == -1)  Format(overlay, sizeof(overlay), "", freezetime);

    for (int i = 1; i <= MaxClients; i++)
    {
      if(IsValidClient(i) && !IsFakeClient(i))
      {
        SetClientOverlay(i, overlay);
        if(freezetime > -1) EmitSoundToClient(i, snd, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NONE, _, fvol[i]);
      }
    }

    if(freezetime == -1)
    {
      if(freezetimeTimer != INVALID_HANDLE)
      {
        KillTimer(freezetimeTimer);
        freezetimeTimer = INVALID_HANDLE;
      }
    }
  }
}

public void OnGameFrame()
{
  if(GameRules_GetProp("m_bWarmupPeriod") == 1)
    bWarmUp = true;

  else bWarmUp = false;
}
