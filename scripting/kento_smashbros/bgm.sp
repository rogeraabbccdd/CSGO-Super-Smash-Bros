void StopBGM(int client, int id)
{
  if(id > -1){
  
    char path[300];
    Format(path, sizeof(path), "*/%s", bgm[id].file);
    StopSound(client, SNDCHAN_STATIC, path);
  }
}

void KillBGMTimer(int client) {
  if(hBGMTimer[client] != INVALID_HANDLE)
  {
    KillTimer(hBGMTimer[client]);
    hBGMTimer[client] = INVALID_HANDLE;
  }
}

void StartRoundBGM() {
  if(bgmCount > 0) {
    int prevBGM = currentBGM;
    currentBGM = GetRandomInt(0, bgmCount-1);

    for (int i = 1; i <= MaxClients; i++)
    {
      if(IsValidClient(i) && !IsFakeClient(i))
      {
        StopBGM(i, prevBGM);
        KillBGMTimer(i);
        hBGMTimer[i] = CreateTimer(0.5, BGMTimer, i, TIMER_FLAG_NO_MAPCHANGE);
      }
    }
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
    hBGMTimer[client] = CreateTimer(bgm[currentBGM].length, BGMTimer, client);
  }
}
