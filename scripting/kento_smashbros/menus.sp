void ShowMainMenu(int client) {
  if(!IsValidClient(client)) return;

  Menu mainmenu = new Menu(MainMenu_Handler);
  
  char tmp[1024];
  Format(tmp, sizeof(tmp), "%T", "Main Menu Title", client);
  mainmenu.SetTitle(tmp);

  Format(tmp, sizeof(tmp), "%T", "Main Menu Volume", client);
  mainmenu.AddItem("vol", tmp);

  Format(tmp, sizeof(tmp), "%T", "Main Menu Weapon", client);
  mainmenu.AddItem("weapon", tmp);

  mainmenu.Display(client, MENU_TIME_FOREVER);
}

public int MainMenu_Handler(Menu menu, MenuAction action, int client,int param)
{
  if (action == MenuAction_Select)
  {
    char menuitem[20];
    menu.GetItem(param, menuitem, sizeof(menuitem));

    if(StrEqual(menuitem, "vol")) ShowVolumeMenu(client);
    else if(StrEqual(menuitem, "weapon")) ShowWeaponMenu(client);
  }
  else if (action == MenuAction_End)
  {
    delete menu;
  }
}

void ShowVolumeMenu(int client)
{
  if(!IsValidClient(client)) return;

  Menu vol_menu = new Menu(VolMenuHandler);

  char vol[1024];
  if(fvol[client] > 0.00)	Format(vol, sizeof(vol), "%.2f", fvol[client]);
  else Format(vol, sizeof(vol), "%T", "Mute", client);

  char tmp[1024];
  Format(tmp, sizeof(tmp), "%T", "Volume Menu Title", client, vol);
  vol_menu.SetTitle(tmp);

  Format(tmp, sizeof(tmp), "%T", "Mute", client);
  vol_menu.AddItem("0", tmp);

  vol_menu.AddItem("0.2", "20%");
  vol_menu.AddItem("0.4", "40%");
  vol_menu.AddItem("0.6", "60%");
  vol_menu.AddItem("0.8", "80%");
  vol_menu.AddItem("1.0", "100%");
  vol_menu.ExitBackButton = true;
  vol_menu.Display(client, MENU_TIME_FOREVER);
}

public int VolMenuHandler(Menu menu, MenuAction action, int client,int param)
{
  if(action == MenuAction_Select)
  {
    char vol[1024];
    GetMenuItem(menu, param, vol, sizeof(vol));

    fvol[client] = StringToFloat(vol);
    CPrintToChat(client, "%T", "Volume 2", client, fvol[client]);

    SetClientCookie(client, clientVolCookie, vol);

    StopBGM(client, currentBGM);
    KillBGMTimer(client);
    hBGMTimer[client] = CreateTimer(0.5, BGMTimer, client, TIMER_FLAG_NO_MAPCHANGE);
  }
  else if (action == MenuAction_Cancel && param == MenuCancel_ExitBack ) {
    ShowMainMenu(client);
  }
  else if (action == MenuAction_End)
  {
    delete menu;
  }
}

void ShowWeaponMenu(int client) 
{
  if(!IsValidClient(client)) return;

  bool hasweapon = false;

  Menu wp_menu = new Menu(WeaponMenuHandler);

  char tmp[1024];
  Format(tmp, sizeof(tmp), "%T", "Weapon Menu Title", client);
  wp_menu.SetTitle(tmp);

  if(weaponCountPrimaryT > 0) {
    Format(tmp, sizeof(tmp), "%T", "Weapon Menu T Primary", client);
    wp_menu.AddItem("primary_t", tmp);
    hasweapon = true;
  }

  if(weaponCountSecondaryT > 0) {
    Format(tmp, sizeof(tmp), "%T", "Weapon Menu T Secondary", client);
    wp_menu.AddItem("secondary_t", tmp);
    hasweapon = true;
  }

  if(weaponCountPrimaryCT > 0) {
    Format(tmp, sizeof(tmp), "%T", "Weapon Menu CT Primary", client);
    wp_menu.AddItem("primary_ct", tmp);
    hasweapon = true;
  }

  if(weaponCountSecondaryCT > 0) {
    Format(tmp, sizeof(tmp), "%T", "Weapon Menu CT Secondary", client);
    wp_menu.AddItem("secondary_ct", tmp);
    hasweapon = true;
  }

  if(!hasweapon)
  {
    Format(tmp, sizeof(tmp), "%T", "Weapon Menu No Weapon", client);
    wp_menu.AddItem("no_weapon", tmp);
  }

  wp_menu.ExitBackButton = true;
  wp_menu.Display(client, MENU_TIME_FOREVER);
}

public int WeaponMenuHandler(Menu menu, MenuAction action, int client,int param)
{
  if(action == MenuAction_Select)
  {
    char menuitem[20];
    menu.GetItem(param, menuitem, sizeof(menuitem));

    if(StrEqual(menuitem, "primary_t")) ShowTPrimaryMenu(client);
    else if(StrEqual(menuitem, "secondary_t")) ShowTSecondaryMenu(client);
    else if(StrEqual(menuitem, "primary_ct")) ShowCTPrimaryMenu(client);
    else if(StrEqual(menuitem, "secondary_ct")) ShowCTSecondaryMenu(client);
  }
  else if (action == MenuAction_Cancel && param == MenuCancel_ExitBack ) {
    ShowMainMenu(client);
  }
  else if (action == MenuAction_End)
  {
    delete menu;
  }
}

void ShowTPrimaryMenu(int client)
{
  if(!IsValidClient(client)) return;

  Menu tp_menu = new Menu(TPMenuHandler);

  char tmp[1024];
  Format(tmp, sizeof(tmp), "%T", "T Primary Menu Title", client);
  tp_menu.SetTitle(tmp);

  for(int i=0;i<weaponCountPrimaryT;i++)
  {
    Format(tmp, sizeof(tmp), "%s", weaponPrimaryT[i]);
    tp_menu.AddItem(weaponPrimaryT[i], tmp);
  }

  tp_menu.ExitBackButton = true;
  tp_menu.Display(client, MENU_TIME_FOREVER);
}

public int TPMenuHandler(Menu menu, MenuAction action, int client,int param)
{
  if(action == MenuAction_Select)
  {
    char menuitem[128];
    menu.GetItem(param, menuitem, sizeof(menuitem));

    CPrintToChat(client, "%T", "T Primary Set", client, menuitem);
    Format(weaponPrimaryTPlayer[client], sizeof(weaponPrimaryTPlayer[]), "%s", menuitem);
    SetClientCookie(client, hweaponPrimaryTPlayer, menuitem);
  }
  else if (action == MenuAction_Cancel && param == MenuCancel_ExitBack ) {
    ShowWeaponMenu(client);
  }
  else if (action == MenuAction_End)
  {
    delete menu;
  }
}

void ShowCTPrimaryMenu(int client)
{
  if(!IsValidClient(client)) return;

  Menu ctp_menu = new Menu(CTPMenuHandler);

  char tmp[1024];
  Format(tmp, sizeof(tmp), "%T", "CT Primary Menu Title", client);
  ctp_menu.SetTitle(tmp);
  
  for(int i=0;i<weaponCountPrimaryCT;i++)
  {
    Format(tmp, sizeof(tmp), "%s", weaponPrimaryCT[i]);
    ctp_menu.AddItem(weaponPrimaryCT[i], tmp);
  }

  ctp_menu.ExitBackButton = true;
  ctp_menu.Display(client, MENU_TIME_FOREVER);
}

public int CTPMenuHandler(Menu menu, MenuAction action, int client,int param)
{
  if(action == MenuAction_Select)
  {
    char menuitem[128];
    menu.GetItem(param, menuitem, sizeof(menuitem));

    CPrintToChat(client, "%T", "CT Primary Set", client, menuitem);
    Format(weaponPrimaryCTPlayer[client], sizeof(weaponPrimaryCTPlayer[]), "%s", menuitem);
    SetClientCookie(client, hweaponPrimaryCTPlayer, menuitem);
  }
  else if (action == MenuAction_Cancel && param == MenuCancel_ExitBack ) {
    ShowWeaponMenu(client);
  }
  else if (action == MenuAction_End)
  {
    delete menu;
  }
}

void ShowTSecondaryMenu(int client)
{
  if(!IsValidClient(client)) return;

  Menu ts_menu = new Menu(TSMenuHandler);

  char tmp[1024];
  Format(tmp, sizeof(tmp), "%T", "T Secondary Menu Title", client);
  ts_menu.SetTitle(tmp);
  
  for(int i=0;i<weaponCountSecondaryT;i++)
  {
    Format(tmp, sizeof(tmp), "%s", weaponSecondaryT[i]);
    ts_menu.AddItem(weaponSecondaryT[i], tmp);
  }

  ts_menu.ExitBackButton = true;
  ts_menu.Display(client, MENU_TIME_FOREVER);
}

public int TSMenuHandler(Menu menu, MenuAction action, int client,int param)
{
  if(action == MenuAction_Select)
  {
    char menuitem[128];
    menu.GetItem(param, menuitem, sizeof(menuitem));

    CPrintToChat(client, "%T", "T Secondary Set", client, menuitem);
    Format(weaponSecondaryTPlayer[client], sizeof(weaponSecondaryTPlayer[]), "%s", menuitem);
    SetClientCookie(client, hweaponSecondaryTPlayer, menuitem);
  }
  else if (action == MenuAction_Cancel && param == MenuCancel_ExitBack ) {
    ShowWeaponMenu(client);
  }
  else if (action == MenuAction_End)
  {
    delete menu;
  }
}

void ShowCTSecondaryMenu(int client)
{
  if(!IsValidClient(client)) return;

  Menu cts_menu = new Menu(CTSMenuHandler);

  char tmp[1024];
  Format(tmp, sizeof(tmp), "%T", "CT Secondary Menu Title", client);
  cts_menu.SetTitle(tmp);
  
  for(int i=0;i<weaponCountSecondaryCT;i++)
  {
    Format(tmp, sizeof(tmp), "%s", weaponSecondaryCT[i]);
    cts_menu.AddItem(weaponSecondaryCT[i], tmp);
  }

  cts_menu.ExitBackButton = true;
  cts_menu.Display(client, MENU_TIME_FOREVER);
}

public int CTSMenuHandler(Menu menu, MenuAction action, int client,int param)
{
  if(action == MenuAction_Select)
  {
    char menuitem[128];
    menu.GetItem(param, menuitem, sizeof(menuitem));

    CPrintToChat(client, "%T", "CT Secondary Set", client, menuitem);
    Format(weaponSecondaryCTPlayer[client], sizeof(weaponSecondaryCTPlayer[]), "%s", menuitem);
    SetClientCookie(client, hweaponSecondaryCTPlayer, menuitem);
  }
  else if (action == MenuAction_Cancel && param == MenuCancel_ExitBack ) {
    ShowWeaponMenu(client);
  }
  else if (action == MenuAction_End)
  {
    delete menu;
  }
}