public void NAU_OnNavAreasLoaded()
{
	isNAUReady = true;
}

void StartRoundItemTimer() {
  itemTimer = CreateTimer(spawninterval, SpawnItemTimer, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action SpawnItemTimer (Handle timer) {
  SpawnItems();
}

void SpawnItems() {
  if(isNAUReady) {
    for(int i=0;i<spawnitems;i++) {
      // position
      float pos[3], vMins[3], vMaxs[3];
      CNavArea navArea = NAU_GetNavAreaAddressByIndex(GetRandomInt(0, NAU_GetNavAreaCount() - 1));
      navArea.GetRandomPos(vMins, vMaxs, pos);
      // retry when position blocked
      if(NAU_IsPositionBlocked(pos, vMins, vMaxs)) {
        if(DEBUG) {
          LogError("position blocked");
        }

        i--;
        continue;
      }

      // decide what item to spawn
      float chance = GetRandomFloat(0.0, totalChace);
      int itemid = GetItemByChance(chance);

      if(itemid > -1)
      {
        char itemname[64];
        Format(itemname, sizeof(itemname), "%s", items[itemid].name);

        if(DEBUG) {
          LogError("chance: %f, id: %d, name: %s, pos: %f, %f, %f", chance, itemid, itemname, pos[0], pos[1], pos[2]);
        }

        Call_StartForward(OnItemSpawn);
        Call_PushString(itemname);
        Call_PushArray(pos, sizeof(pos));
        Call_Finish();
      } else {
        if(DEBUG) {
          LogError("Not found, chance %f", chance);
        }
      }
    }

    for (int i = 1; i <= MaxClients; i++)
    {
      if(IsValidClient(i) && !IsFakeClient(i))  PrintHintText(i, "%T", "Item Spawned", i);
    }
  }
}

void SpawnItem(char []name, int count)
{
  if(isNAUReady) 
  {
    for(int i=0;i<count;i++)
    {
      float pos[3], vMins[3], vMaxs[3];
      CNavArea navArea = NAU_GetNavAreaAddressByIndex(GetRandomInt(0, NAU_GetNavAreaCount() - 1));
      navArea.GetRandomPos(vMins, vMaxs, pos);
      // retry when position blocked
      if(NAU_IsPositionBlocked(pos, vMins, vMaxs)) {
        if(DEBUG) {
          LogError("position blocked");
        }

        i--;
        continue;
      }

      Call_StartForward(OnItemSpawn);
      Call_PushString(name);
      Call_PushArray(pos, sizeof(pos));
      Call_Finish();
    }
    
    for (int i = 1; i <= MaxClients; i++)
    {
      if(IsValidClient(i) && !IsFakeClient(i))  PrintHintText(i, "%T", "Item Spawned", i);
    }
  }
}