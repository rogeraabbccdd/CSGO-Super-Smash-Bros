void StopBGM(int client, int id)
{
  if(id > -1){
    char path[300];
    Format(path, sizeof(path), "*/%s", bgm[id].file);
    StopSound(client, SNDCHAN_STATIC, bgm[id].file);
  }
}

void KillBGMTimer(int client) {
  if(hBGMTimer[client] != INVALID_HANDLE)
  {
    KillTimer(hBGMTimer[client]);
    hBGMTimer[client] = INVALID_HANDLE;
  }
}

public Action BGMTimer(Handle tmr, any client)
{
  if(IsValidClient(client) && !IsFakeClient(client))
  { 
    char path[300];
    Format(path, sizeof(path), "*/%s", bgm[currentBGM].file);
    CPrintToChat(client, "%T", "BGM", client, bgm[currentBGM].name);
    EmitSoundToClient(client, path, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NONE, _, fvol[client]);
    hBGMTimer[client] = CreateTimer(195.0, BGMTimer, client);
  }
}
