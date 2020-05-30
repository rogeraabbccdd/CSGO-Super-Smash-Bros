stock bool IsValidClient(int client)
{
  if (client <= 0) return false;
  if (client > MaxClients) return false;
  if (!IsClientConnected(client)) return false;
  return IsClientInGame(client);
}

// https://wiki.alliedmods.net/Csgo_quirks
stock void FakePrecacheSound(const char[] szPath)
{
  AddToStringTable(FindStringTable("soundprecache"), szPath);
}

bool SetClientOverlay(int client, char[] strOverlay)
{
  if (IsValidClient(client) && !IsFakeClient(client))
  {
    int iFlags = GetCommandFlags("r_screenoverlay") & (~FCVAR_CHEAT);
    SetCommandFlags("r_screenoverlay", iFlags);	
    ClientCommand(client, "r_screenoverlay \"%s\"", strOverlay);
    return true;
  }
  return false;
}

void ResetTimers()
{
  KillItemTimer();
  
  if(freezetimeTimer != INVALID_HANDLE)
  {
    KillTimer(freezetimeTimer);
    freezetimeTimer = INVALID_HANDLE;
  }

  for (int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i))
    {
      ResetClientStatus(i);
      
      if(!IsFakeClient(i))  KillBGMTimer(i);
    }
  }

  if(hRoundCountdown != INVALID_HANDLE)
  {
    KillTimer(hRoundCountdown);
    hRoundCountdown = INVALID_HANDLE;
  }
}
