public Action Event_PlayerSpawn (Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  
  ResetClientStatus(client);

  fPlayerDMG[client] = 0.0;

  CreateTimer(0.1, GiveWeapons, client);
}

public Action GiveWeapons(Handle timer, int client)
{
  if(IsValidClient(client))
  {
    Client_RemoveAllWeapons(client, "weapon_knife", true);
  
    int team = GetClientTeam(client);
    if(team == CS_TEAM_T)
    {
      GivePlayerItem(client, weaponPrimaryTPlayer[client]);
      GivePlayerItem(client, weaponSecondaryTPlayer[client]);
    }
    else if(team == CS_TEAM_CT)
    {
      GivePlayerItem(client, weaponPrimaryCTPlayer[client]);
      GivePlayerItem(client, weaponSecondaryCTPlayer[client]);
    }
  }
}

public Action Event_PlayerDeath (Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));

  bool changed = false;

  if(IsValidClient(lastAttackBy[client].attacker)) {
    int attacker = lastAttackBy[client].attacker;
    changed = true;
    Event event_fake = CreateEvent("player_death", true);
    event_fake.SetInt("attacker", GetClientUserId(attacker));
    event_fake.SetInt("userid", event.GetInt("userid"));
    event_fake.SetString("weapon", lastAttackBy[client].weapon);

    for(int i = 0; i < MaxClients; i++)
    {
      if(IsValidClient(i) && !IsFakeClient(i)) event_fake.FireToClient(i);
    }
    
    event_fake.Cancel();

    kills[attacker]++;
    SetClientFrags(attacker, kills[attacker]);
  }

  deaths[client]++;
  SetClientDeaths(client, deaths[client]);
  SetClientFrags(client, kills[client]);

  lastAttackBy[client].attacker = 0;
  Format(lastAttackBy[client].weapon, 64, "");

  char path[300];
  if(fPlayerDMG[client] >= 200.0) Format(path, sizeof(path), "*/kento_smashbros/sfx/cheer_l.mp3");
  else if(fPlayerDMG[client] >= 100.0)  Format(path, sizeof(path), "*/kento_smashbros/sfx/cheer_m.mp3");
  else if(fPlayerDMG[client] >= 0.0)  Format(path, sizeof(path), "*/kento_smashbros/sfx/cheer_s.mp3");

  for (int i = 1; i <= MaxClients; i++)
  {
    if(lastAttack[i] == client) lastAttack[i] = 0;

    if(IsValidClient(i) && !IsFakeClient(i))
    {
      EmitSoundToClient(i, path, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NONE, _, fvol[i]);
    }
  }

  ResetClientStatus(client);

  fPlayerDMG[client] = 0.0;

  if(changed) {
    event.BroadcastDisabled = true;
    return Plugin_Changed;
  }
  else return Plugin_Continue;
}

public Action Event_RoundStart (Event event, const char[] name, bool dontBroadcast)
{
  ResetTimers();
  
  if(spawnroundstart) SpawnItems();
  
  if(spawninterval > 0.0) {
    KillItemTimer();
    StartRoundItemTimer();
  }

  StartRoundBGM();

  for (int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i))
    {
      SetClientOverlay(i, "");
      ResetClientStatus(i);
    }
  }

  CreateTimer(0.0001, startTimerDelay);
}

public Action startTimerDelay(Handle timer)
{
  if(!bWarmUp) {
    freezetime = RoundToFloor(fCvarFreezetime);
    freezetimeTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
    roundtime = fmp_roundtime * 60.0 + fCvarFreezetime;
    hRoundCountdown = CreateTimer(1.0, RoundCountdown, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
  }
}

public Action Countdown(Handle timer)
{
  freezetime--;
  if(freezetime <= 3)
  {
    char snd[64];
    if(freezetime > 0) Format(snd, sizeof(snd), "*/kento_smashbros/sfx/%d.mp3", freezetime);
    else if(freezetime > -1) Format(snd, sizeof(snd), "*/kento_smashbros/sfx/go.mp3", freezetime);
    
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

public Action Event_RoundEnd (Event event, const char[] name, bool dontBroadcast)
{
  char message[256];
  event.GetString("message", message, sizeof(message));

  char overlay[64];
  char snd[64];
  
  // Round Draw
  // play timeover sound
  if(StrEqual(message,"#SFUI_Notice_Round_Draw", false))
  {
    Format(overlay, sizeof(overlay), "kento_smashbros/timeup");
    Format(snd, sizeof(snd), "*/kento_smashbros/sfx/timeup.mp3");
  }
  else {
    Format(overlay, sizeof(overlay), "kento_smashbros/gameset");
    Format(snd, sizeof(snd), "*/kento_smashbros/sfx/gameset.mp3");
  }

  for (int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i) && !IsFakeClient(i))
    {
      SetClientOverlay(i, overlay);
      EmitSoundToClient(i, snd, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NONE, _, fvol[i]);
    }
  }

  event.BroadcastDisabled = true; 
  
  ResetTimers();

  return Plugin_Changed;
}

public Action RoundCountdown(Handle tmr)
{
  --roundtime;

  if (roundtime <= 5.0 && roundtime > 0.0)
  {
    char snd[64];
    Format(snd, sizeof(snd), "*/kento_smashbros/sfx/%d.mp3", RoundToFloor(roundtime));

    for (int i = 1; i <= MaxClients; i++)
    {
      if (IsValidClient(i) && !IsFakeClient(i)) 
      {
        EmitSoundToClient(i, snd, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NONE, _, fvol[i]);
      }
    }
  }

  else if (roundtime <= 0)
  {
    if(hRoundCountdown != INVALID_HANDLE)
    {
      KillTimer(hRoundCountdown);
      hRoundCountdown = INVALID_HANDLE;
    }
  }
}

public Action Event_BotTakeover(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  int bot = GetClientOfUserId(event.GetInt("botid"));
  fPlayerDMG[client] = fPlayerDMG[bot];
}

public void OnGameFrame()
{
  if(GameRules_GetProp("m_bWarmupPeriod") == 1)
    bWarmUp = true;

  else bWarmUp = false;
}
