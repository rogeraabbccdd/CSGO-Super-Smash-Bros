public void NAU_OnNavAreasLoaded()
{
	isNAUReady = true;
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
      float chance = GetRandomFloat(0.0, 100.0);
      int itemid = GetItemByChance(chance);
      char itemname[64];
      Format(itemname, sizeof(itemname), "%s", items[itemid].name);

      if(DEBUG) {
        LogError("chance: %f, item: %s, pos: %f, %f, %f", chance, itemname, pos[0], pos[1], pos[2]);
      }

      Call_StartForward(OnItemSpawn);
      Call_PushString(itemname);
      Call_PushArray(pos, sizeof(pos));
      Call_Finish();
    }
  }
}

int GetItemByChance (float chance) {
  int idx = -1;
  float totalChance = 0.0;
  for(int i=0;i<itemCount;i++) {
    totalChance += items[0].chance;
    if(chance < totalChance) {
      idx = i;
      break;
    }
  }
  return idx;
}