public Action Command_Damage (int client, int args) {
  char arg[20];
  float dmg;
  GetCmdArg(1, arg, sizeof(arg));
  dmg = StringToFloat(arg);
  for(int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i)) fPlayerDMG[i] = dmg;
  }
  return Plugin_Handled;
}

public Action Command_AllDamage (int client, int args) {
  for(int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i)) PrintToChat(client, "%N: %f", i, fPlayerDMG[i]);
  }
  return Plugin_Handled;
}

public Action Command_SmashBros (int client, int args) {
  if(IsValidClient(client) && !IsFakeClient(client))
  {
    ShowMainMenu(client);
  }
  return Plugin_Handled;
}

public Action Command_Volume (int client, int args)
{
  if(IsValidClient(client) && !IsFakeClient(client))
  {
    char arg[20];
    float volume;
    
    if (args < 1)
    {
      CPrintToChat(client, "%T", "Volume 1", client);
      return Plugin_Handled;
    }
      
    GetCmdArg(1, arg, sizeof(arg));
    volume = StringToFloat(arg);
    
    if (volume < 0.0 || volume > 1.0)
    {
      CPrintToChat(client, "%T", "Volume 1", client);
      return Plugin_Handled;
    }
    
    fvol[client] = StringToFloat(arg);
    CPrintToChat(client, "%T", "Volume 2", client, fvol[client]);
    
    SetClientCookie(client, clientVolCookie, arg);

    StopBGM(client, currentBGM);
    KillBGMTimer(client);
    hBGMTimer[client] = CreateTimer(0.5, BGMTimer, client, TIMER_FLAG_NO_MAPCHANGE);
  }
  return Plugin_Handled;
}

public Action Command_MyDamage(int client, int args)
{
  PrintToChat(client, "fClientUpwardForce %f", fClientUpwardForce[client]);
  PrintToChat(client, "fClientAngles %f", fClientAngles[client]);
  PrintToChat(client, "fClientGiveDMGMultiplier %f", fClientGiveDMGMultiplier[client]);
  PrintToChat(client, "fClientTakeDMGMultiplier %f", fClientTakeDMGMultiplier[client]);
  PrintToChat(client, "fClientPushBackMultiplier %f", fClientPushBackMultiplier[client]);
}

public Action Command_Weapon(int client, int args)
{
  if(!IsValidClient(client)) return;
  ShowWeaponMenu(client);
}

public Action Command_SpawnItem(int client, int args)
{
  if (args < 2)
  {
    CPrintToChat(client, "%T", "Spawn Item Args", client);
    return Plugin_Handled;
  }

  char itemname[20];
  char count[20];
  int icount;

  GetCmdArg(1, itemname, sizeof(itemname));
  GetCmdArg(2, count, sizeof(count));
  icount = StringToInt(count);

  SpawnItem(itemname, icount);

  return Plugin_Handled;
}