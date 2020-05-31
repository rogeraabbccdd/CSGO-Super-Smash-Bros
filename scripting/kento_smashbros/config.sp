void LoadMapConfig(char [] mapname)
{
  char Configfile[PLATFORM_MAX_PATH];
  BuildPath(Path_SM, Configfile, sizeof(Configfile), "configs/kento_smashbros/items.cfg");

  if (!FileExists(Configfile))
  {
    SetFailState("Fatal error: Unable to open configuration file \"%s\"!", Configfile);
  }

  KeyValues kv = CreateKeyValues("configs");
  kv.ImportFromFile(Configfile);

  itemCount = 0;
  totalChace = 0.0;
  float chanceStart = 0.0;

  if(DEBUG) {
    LogError("looking for item configs for map %s", mapname);
  }

  if(kv.JumpToKey(mapname))
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
    if(DEBUG) {
      LogError("spawnroundstart: %d, spawninterval: %f, spawnitems: %d", view_as<int>(spawnroundstart), spawninterval, spawnitems);
    }
  }
  else
  {
    kv.Rewind();

    if(DEBUG) {
      LogError("No map item config found, use default", mapname);
    }
    if(kv.JumpToKey("default")) {
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
      if(DEBUG) {
        LogError("spawnroundstart: %d, spawninterval: %f, spawnitems: %d", view_as<int>(spawnroundstart), spawninterval, spawnitems);
      }
    }
    else {
      LogError("Error: Unable to find item settings in configuration file \"%s\"!", Configfile);
    }
  }

  kv.Rewind();
  delete kv;
}

void LoadBGMConfig(const char [] mapname)
{
  char Configfile[PLATFORM_MAX_PATH];
  BuildPath(Path_SM, Configfile, sizeof(Configfile), "configs/kento_smashbros/bgms.cfg");

  if (!FileExists(Configfile))
  {
    SetFailState("Fatal error: Unable to open configuration file \"%s\"!", Configfile);
  }

  KeyValues kv = CreateKeyValues("configs");
  kv.ImportFromFile(Configfile);

  bgmCount = 0

  if(DEBUG) {
    LogError("looking for bgm configs for map %s", mapname);
  }

  if(kv.JumpToKey(mapname))
  {
    if(kv.GotoFirstSubKey())
    {
      char name[1024];
      char file[1024];
      do
      {
        bgm[bgmCount].length = kv.GetFloat("length");

        kv.GetSectionName(name, sizeof(name));
        Format(bgm[bgmCount].name, 1024, "%s", name);

        kv.GetString("file", file, sizeof(file));
        Format(bgm[bgmCount].file, 1024, "%s", file);

        char filepath[1024];
        Format(filepath, sizeof(filepath), "sound/%s", bgm[bgmCount].file)
        AddFileToDownloadsTable(filepath);

        char soundpath[1024];
        Format(soundpath, sizeof(soundpath), "*/%s", bgm[bgmCount].file);
        FakePrecacheSound(soundpath);

        if(DEBUG) {
          LogError("BGM: %s, %f", bgm[bgmCount].name, bgm[bgmCount].length);
          LogError("sound path: %s", soundpath);
          LogError("file path: %s", filepath);
        }

        bgmCount++;
      }
      while (kv.GotoNextKey());
    }
  }
  else {
    kv.Rewind();

    if(DEBUG) {
      LogError("No map bgm config found, use default", mapname);
    }

    if(kv.JumpToKey("default")) {
      if(kv.GotoFirstSubKey())
      {
        char name[1024];
        char file[1024];
        do
        {
          bgm[bgmCount].length = kv.GetFloat("length");

          kv.GetSectionName(name, sizeof(name));
          Format(bgm[bgmCount].name, 1024, "%s", name);

          kv.GetString("file", file, sizeof(file));
          Format(bgm[bgmCount].file, 1024, "%s", file);

          char filepath[1024];
          Format(filepath, sizeof(filepath), "sound/%s", bgm[bgmCount].file)
          AddFileToDownloadsTable(filepath);

          char soundpath[1024];
          Format(soundpath, sizeof(soundpath), "*/%s", bgm[bgmCount].file);
          FakePrecacheSound(soundpath);

          if(DEBUG) {
            LogError("BGM: %s, %f", bgm[bgmCount].name, bgm[bgmCount].length);
            LogError("sound path: %s", soundpath);
            LogError("file path: %s", filepath);
          }

          bgmCount++;
        }
        while (kv.GotoNextKey());
      }
    }
    else {
      LogError("Error: Unable to find bgm settings in configuration file \"%s\"!", Configfile);
    }
  }

  kv.Rewind();
  delete kv;
}

void LoadWeaponsConfig(const char [] mapname)
{
  char Configfile[PLATFORM_MAX_PATH];
  BuildPath(Path_SM, Configfile, sizeof(Configfile), "configs/kento_smashbros/weapons.cfg");

  if (!FileExists(Configfile))
  {
    SetFailState("Fatal error: Unable to open configuration file \"%s\"!", Configfile);
  }

  KeyValues kv = CreateKeyValues("configs");
  kv.ImportFromFile(Configfile);

  if(DEBUG) {
    LogError("looking for weapon configs for map %s", mapname);
  }

  if(kv.JumpToKey(mapname))
  {
    if(kv.JumpToKey("primary") && kv.GotoFirstSubKey(false))
    {
      do
      {
        char name[128];
        char team[8];
        kv.GetSectionName(name, sizeof(name));
        kv.GetString(NULL_STRING, team, sizeof(team));

        if(StrEqual(team, "CT") || StrEqual(team, "BOTH")){
          Format(weaponPrimaryCT[weaponCountPrimaryCT], 128, name);
          weaponCountPrimaryCT++

          if(DEBUG) {
            LogError("primary name: %s, team: CT", name);
          }
        }
        if(StrEqual(team, "T") || StrEqual(team, "BOTH")){
          Format(weaponPrimaryT[weaponCountPrimaryT], 128, name);
          weaponCountPrimaryT++

          if(DEBUG) {
            LogError("primary name: %s, team: T", name);
          }
        }
      }
      while (kv.GotoNextKey(false));

      kv.GoBack();
    }

    kv.GoBack();

    if(kv.JumpToKey("secondary") && kv.GotoFirstSubKey(false))
    {
      do
      {
        char name[128];
        char team[8];
        kv.GetSectionName(name, sizeof(name));
        kv.GetString(NULL_STRING, team, sizeof(team));

        if(StrEqual(team, "CT") || StrEqual(team, "BOTH")){
          Format(weaponSecondaryCT[weaponCountSecondaryCT], 128, name);
          weaponCountSecondaryCT++;

          if(DEBUG) {
            LogError("Secondary name: %s, team: CT", name);
          }
        }
        if(StrEqual(team, "T") || StrEqual(team, "BOTH")){
          Format(weaponSecondaryT[weaponCountSecondaryT], 128, name);
          weaponCountSecondaryT++;

          if(DEBUG) {
            LogError("Secondary name: %s, team: T", name);
          }
        }
      }
      while (kv.GotoNextKey(false));
      kv.GoBack();
    }
  }
  else {
    kv.Rewind();

    if(DEBUG) {
      LogError("No map weapon config found, use default", mapname);
    }

    if(kv.JumpToKey("default")) {
      if(kv.JumpToKey("primary") && kv.GotoFirstSubKey(false))
      {
        do
        {
          char name[128];
          char team[8];
          kv.GetSectionName(name, sizeof(name));
          kv.GetString(NULL_STRING, team, sizeof(team));

          if(StrEqual(team, "CT") || StrEqual(team, "BOTH")){
            Format(weaponPrimaryCT[weaponCountPrimaryCT], 128, name);
            weaponCountPrimaryCT++

            if(DEBUG) {
              LogError("primary name: %s, team: CT", name);
            }
          }
          if(StrEqual(team, "T") || StrEqual(team, "BOTH")){
            Format(weaponPrimaryT[weaponCountPrimaryT], 128, name);
            weaponCountPrimaryT++

            if(DEBUG) {
              LogError("primary name: %s, team: T", name);
            }
          }
        }
        while (kv.GotoNextKey(false));

        kv.GoBack();
      }

      kv.GoBack();

      if(kv.JumpToKey("secondary") && kv.GotoFirstSubKey(false))
      {
        do
        {
          char name[128];
          char team[8];
          kv.GetSectionName(name, sizeof(name));
          kv.GetString(NULL_STRING, team, sizeof(team));

          if(StrEqual(team, "CT") || StrEqual(team, "BOTH")){
            Format(weaponSecondaryCT[weaponCountSecondaryCT], 128, name);
            weaponCountSecondaryCT++;

            if(DEBUG) {
              LogError("Secondary name: %s, team: CT", name);
            }
          }
          if(StrEqual(team, "T") || StrEqual(team, "BOTH")){
            Format(weaponSecondaryT[weaponCountSecondaryT], 128, name);
            weaponCountSecondaryT++;

            if(DEBUG) {
              LogError("Secondary name: %s, team: T", name);
            }
          }
        }
        while (kv.GotoNextKey(false));
        kv.GoBack();
      }
    }
    else {
      LogError("Error: Unable to find weapon settings in configuration file \"%s\"!", Configfile);
    }
  }
}
