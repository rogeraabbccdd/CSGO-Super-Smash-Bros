void LoadMapConfig()
{
  char Configfile[PLATFORM_MAX_PATH];
  BuildPath(Path_SM, Configfile, sizeof(Configfile), "configs/kento_smashbros/items.cfg");
  
  if (!FileExists(Configfile))
  {
    SetFailState("Fatal error: Unable to open configuration file \"%s\"!", Configfile);
  }
  
  KeyValues kv = CreateKeyValues("configs");
  kv.ImportFromFile(Configfile);
  
  char sMapName[128], sMapName2[128];
  GetCurrentMap(sMapName, sizeof(sMapName));
  
  // Does current map string contains a "workshop" prefix at a start?
  if (strncmp(sMapName, "workshop", 8) == 0)
  {
    Format(sMapName2, sizeof(sMapName2), sMapName[19]);
  }
  else
  {
    Format(sMapName2, sizeof(sMapName2), sMapName);
  }
  
  itemCount = 0;
  float totalChace = 0.0;
  float chanceStart = 0.0;

  if(DEBUG) {
    LogError("looking for configs for map %s", sMapName2);
  }

  if(kv.JumpToKey(sMapName2))
  {
    spawnroundstart = view_as<bool>(kv.GetNum("spawnroundstart", 0));
    spawninterval = kv.GetFloat("spawninterval", 0.0);
    spawnitems = kv.GetNum("spawnitems", 0);

    if(kv.JumpToKey("items") && kv.GotoFirstSubKey(false))
    {
      do
      {
        char name[64];
        float chance;
        kv.GetSectionName(name, sizeof(name));
        chance = kv.GetFloat(NULL_STRING, 0.0);

        totalChace += chance;
        chanceStart = totalChace;
        items[itemCount].chance = chanceStart;
        Format(items[itemCount].name, 64, "%s", name);

        itemCount++;
        
        if(DEBUG) {
          LogError("item name: %s, %f", name, chance);
        }
      }
      while (kv.GotoNextKey(false));
    }

    if(itemCount == 0) {
      spawnroundstart = false;
      spawninterval = 0.0;
      spawnitems = 0;
      LogError("Can't found any item in map config.");
    }
    if (totalChace != 100.0) {
      spawnroundstart = false;
      spawninterval = 0.0;
      spawnitems = 0;
      LogError("Expect sum of item chances is 100.0, current chances is %f, items are disabled.", totalChace);
    }
    if(DEBUG) {
      LogError("spawnroundstart: %d, spawninterval: %f, spawnitems: %d", view_as<int>(spawnroundstart), spawninterval, spawnitems);
    }
  }
  else {
    LogError("Error: Unable to find item settings of current map in configuration file \"%s\"!", Configfile);
  }
  
  kv.Rewind();
  delete kv;
}