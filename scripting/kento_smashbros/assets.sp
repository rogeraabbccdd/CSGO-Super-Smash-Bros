void LoadAssets() {
  AddFileToDownloadsTable("sound/kento_smashbros/sfx/3.mp3");
  AddFileToDownloadsTable("sound/kento_smashbros/sfx/2.mp3");
  AddFileToDownloadsTable("sound/kento_smashbros/sfx/1.mp3");
  AddFileToDownloadsTable("sound/kento_smashbros/sfx/0.mp3");

  FakePrecacheSound("*/kento_smashbros/sfx/3.mp3");
  FakePrecacheSound("*/kento_smashbros/sfx/2.mp3");
  FakePrecacheSound("*/kento_smashbros/sfx/1.mp3");
  FakePrecacheSound("*/kento_smashbros/sfx/0.mp3");

  PrecacheDecal("materials/kento_smashbros/3.vmt", true);
  PrecacheDecal("materials/kento_smashbros/3.vtf", true);
  PrecacheDecal("materials/kento_smashbros/2.vmt", true);
  PrecacheDecal("materials/kento_smashbros/2.vtf", true);
  PrecacheDecal("materials/kento_smashbros/1.vmt", true);
  PrecacheDecal("materials/kento_smashbros/1.vtf", true);
  PrecacheDecal("materials/kento_smashbros/0.vmt", true);
  PrecacheDecal("materials/kento_smashbros/0.vtf", true);
}