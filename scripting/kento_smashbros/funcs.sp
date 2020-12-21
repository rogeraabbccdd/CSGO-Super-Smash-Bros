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
  if(itemTimer != INVALID_HANDLE)
  {
    KillTimer(itemTimer);
    itemTimer = INVALID_HANDLE;
  }
  
  if(freezetimeTimer != INVALID_HANDLE)
  {
    KillTimer(freezetimeTimer);
    freezetimeTimer = INVALID_HANDLE;
  }

  for (int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i) && !IsFakeClient(i)) KillBGMTimer(i);
  }

  if(hRoundCountdown != INVALID_HANDLE)
  {
    KillTimer(hRoundCountdown);
    hRoundCountdown = INVALID_HANDLE;
  }
}

void SetClientFrags(int client, int value)
{
  SetEntProp(client, Prop_Data, "m_iFrags", value);
}

void SetClientDeaths(int client, int value)
{
  SetEntProp(client, Prop_Data, "m_iDeaths", value);
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

int GetItemByChance (float chance) {
  int idx = -1;

  for(int i=0;i<itemCount;i++) {
    if(chance > items[i].chance) {
      continue;
    } else {
      idx = i-1;
      break;
    }
  }

  return idx;
}

bool IsMapHasWeapon (int team, int type, char[] weapon)
{
  bool result = false;

  if(team ==  CS_TEAM_T)
  {
    if(type == 1)
    {
      for(int i=0;i<weaponCountPrimaryT;i++)
      {
        if(StrEqual(weapon, weaponPrimaryT[i]))
        {
          result = true;
          break;
        }
      }
    }
    else if (type == 2)
    {
      for(int i=0;i<weaponCountSecondaryT;i++)
      {
        if(StrEqual(weapon, weaponSecondaryT[i]))
        {
          result = true;
          break;
        }
      }
    }
  }
  else if(team ==  CS_TEAM_CT)
  {
    if(type == 1)
    {
      for(int i=0;i<weaponCountPrimaryCT;i++)
      {
        if(StrEqual(weapon, weaponPrimaryCT[i]))
        {
          result = true;
          break;
        }
      }
    }
    else if (type == 2)
    {
      for(int i=0;i<weaponCountSecondaryCT;i++)
      {
        if(StrEqual(weapon, weaponSecondaryCT[i]))
        {
          result = true;
          break;
        }
      }
    }
  }

  if(DEBUG)  LogError("team: %d, type: %d, name: %s, result: %d", team, type, weapon, result);
  return result;
}

void GetWeaponClassName(int weapon, char[]name, int maxlength)
{
  GetEdictClassname(weapon, name, maxlength);

  int index = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
  if(DEBUG) PrintToChatAll("weapon index %d", index);
  switch (index)
  {
    case 60: strcopy(name, maxlength, "weapon_m4a1_silencer");
    case 61: strcopy(name, maxlength, "weapon_usp_silencer");
    case 63: strcopy(name, maxlength, "weapon_cz75a");
    case 64: strcopy(name, maxlength, "weapon_revolver");
    case 23: strcopy(name, maxlength, "weapon_mp5sd");
  }
}
