public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
  CreateNative("SB_GetClientDamage", Native_GetClientDamage);
  CreateNative("SB_SetClientDamage", Native_SetClientDamage);

  OnItemSpawn = CreateGlobalForward("SB_OnItemSpawn", ET_Ignore, Param_String, Param_Array);

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
    fPlayerDMG[client] = dmg;
    return true;
  }
  else return false;
}
