public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
  CreateNative("SB_GetClientDamage", Native_GetClientDamage);
  CreateNative("SB_SetClientDamage", Native_SetClientDamage);

  CreateNative("SB_GetClientGiveDamageMultiplier", Native_GetClientGiveDamageMultiplier);
  CreateNative("SB_GetClientTakeDamageMultiplier", Native_GetClientTakeDamageMultiplier);
  CreateNative("SB_GetClientPushbackMultiplier", Native_GetClientPushbackMultiplier);
  CreateNative("SB_GetClientUpwardForce", Native_GetClientUpwardForce);
  CreateNative("SB_GetClientAngle", Native_GetClientAngle);

  CreateNative("SB_SetClientGiveDamageMultiplier", Native_SetClientGiveDamageMultiplier);
  CreateNative("SB_SetClientTakeDamageMultiplier", Native_SetClientTakeDamageMultiplier);
  CreateNative("SB_SetClientPushbackMultiplier", Native_SetClientPushbackMultiplier);
  CreateNative("SB_SetClientUpwardForce", Native_SetClientUpwardForce);
  CreateNative("SB_SetClientAngle", Native_SetClientAngle);

  CreateNative("SB_KnockBackClient", Native_KnockBackClient);

  CreateNative("SB_IsFriendlyFire", Native_IsFriendlyFire);

  OnItemSpawn = CreateGlobalForward("SB_OnItemSpawn", ET_Ignore, Param_String, Param_Array);
  OnSBTakeDamage = CreateGlobalForward("SB_OnTakeDamage", ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Float);
  OnClientKnockBack = CreateGlobalForward("SB_OnClientKnockBack", ET_Ignore, Param_Cell, Param_Cell, Param_Array);

  RegPluginLibrary("kento_smashbros");
}

public int Native_GetClientDamage(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  return view_as<int>(fPlayerDMG[client]);
}

public int Native_SetClientDamage(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  float dmg = GetNativeCell(2);
  if(IsValidClient(client)) {
    fPlayerDMG[client] = dmg >= 0.0 ? dmg : 0.0;
    return true;
  }
  else return false;
}

public int Native_GetClientGiveDamageMultiplier(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  return view_as<int>(fClientGiveDMGMultiplier[client]);
}

public int Native_SetClientGiveDamageMultiplier(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  float value = GetNativeCell(2);
  if(IsValidClient(client)) {
    fClientGiveDMGMultiplier[client] = value;
    return true;
  }
  else return false;
}

public int Native_GetClientTakeDamageMultiplier(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  return view_as<int>(fClientTakeDMGMultiplier[client]);
}

public int Native_SetClientTakeDamageMultiplier(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  float value = GetNativeCell(2);
  if(IsValidClient(client)) {
    fClientTakeDMGMultiplier[client] = value;
    return true;
  }
  else return false;
}

public int Native_GetClientPushbackMultiplier(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  return view_as<int>(fClientPushBackMultiplier[client]);
}

public int Native_SetClientPushbackMultiplier(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  float value = GetNativeCell(2);
  if(IsValidClient(client)) {
    fClientPushBackMultiplier[client] = value;
    return true;
  }
  else return false;
}

public int Native_GetClientUpwardForce(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  return view_as<int>(fClientUpwardForce[client]);
}

public int Native_SetClientUpwardForce(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  float value = GetNativeCell(2);
  if(IsValidClient(client)) {
    fClientUpwardForce[client] = value;
    return true;
  }
  else return false;
}

public int Native_GetClientAngle(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  return view_as<int>(fClientAngles[client]);
}

public int Native_SetClientAngle(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  float value = GetNativeCell(2);
  if(IsValidClient(client)) {
    fClientAngles[client] = value;
    return true;
  }
  else return false;
}

public int Native_KnockBackClient(Handle plugin, int numParams)
{
  int client = GetNativeCell(1);
  int attacker = GetNativeCell(2);

  if(!IsValidClient(client) || !IsValidEdict(attacker))  return false;

  KnockBack(client, attacker);
  return true;
}

public int Native_IsFriendlyFire(Handle plugin, int numParams)
{
  return bCvarff;
}