void ShowMainMenu(int client) {
  if(!IsValidClient(client)) return;

  Menu mainmenu = new Menu(MainMenu_Handler);
  
  char tmp[1024];
  Format(tmp, sizeof(tmp), "%T", "Main Menu Title", client);
  mainmenu.SetTitle(tmp);

  Format(tmp, sizeof(tmp), "%T", "Main Menu Volume", client);
  mainmenu.AddItem("vol", tmp);

  mainmenu.Display(client, MENU_TIME_FOREVER);
}

public int MainMenu_Handler(Menu menu, MenuAction action, int client,int param)
{
  switch(action)
  {
    case MenuAction_Select:
    {
      char menuitem[20];
      menu.GetItem(param, menuitem, sizeof(menuitem));

      if(StrEqual(menuitem, "vol")) ShowVolumeMenu(client);
    }
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
}