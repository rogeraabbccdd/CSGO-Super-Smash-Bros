void RegMapCookie(char [] mapname)
{
  char cookieName[64];
  Format(cookieName, sizeof(cookieName), "sb_weapon_tp_%s", mapname);
  hweaponPrimaryTPlayer = RegClientCookie(cookieName, "Smash Bros T Primary Weapon", CookieAccess_Protected);

  Format(cookieName, sizeof(cookieName), "sb_weapon_ts_%s", mapname);
  hweaponSecondaryTPlayer = RegClientCookie(cookieName, "Smash Bros T Secondary Weapon", CookieAccess_Protected);

  Format(cookieName, sizeof(cookieName), "sb_weapon_ctp_%s", mapname);
  hweaponPrimaryCTPlayer = RegClientCookie(cookieName, "Smash Bros CT Primary Weapon", CookieAccess_Protected);

  Format(cookieName, sizeof(cookieName), "sb_weapon_cts_%s", mapname);
  hweaponSecondaryCTPlayer = RegClientCookie(cookieName, "Smash Bros T Secondary Weapon", CookieAccess_Protected);
}

void GetClientCookies(int client)
{
  char buffer[128];
  GetClientCookie(client, clientVolCookie, buffer, sizeof(buffer));
  if(!StrEqual(buffer, ""))
  {
    fvol[client] = StringToFloat(buffer);
  }
  if(StrEqual(buffer,"")){
    fvol[client] = 0.8;
  }

  // TP
  GetClientCookie(client, hweaponPrimaryTPlayer, buffer, sizeof(buffer));
  if(!StrEqual(buffer, ""))
  {
    bool has = IsMapHasWeapon(CS_TEAM_T, 1, buffer);
    if(has)  {
      SetClientCookie(client, hweaponPrimaryTPlayer, weaponPrimaryT[0]);
      Format(weaponPrimaryTPlayer[client], sizeof(weaponPrimaryTPlayer[]), "%s", buffer);
    }
    else {
      if(weaponCountPrimaryT > 0) Format(weaponPrimaryTPlayer[client], sizeof(weaponPrimaryTPlayer[]), "%s", weaponPrimaryT[0]);
      else {
        Format(weaponPrimaryTPlayer[client], sizeof(weaponPrimaryTPlayer[]), "");
        SetClientCookie(client, hweaponPrimaryTPlayer, "");
      }
    }
  }
  if(StrEqual(buffer,"")){
    if(weaponCountPrimaryT > 0) {
      SetClientCookie(client, hweaponPrimaryTPlayer, weaponPrimaryT[0]);
      Format(weaponPrimaryTPlayer[client], sizeof(weaponPrimaryTPlayer[]), "%s", weaponPrimaryT[0]);
    }
    else {
      Format(weaponPrimaryTPlayer[client], sizeof(weaponPrimaryTPlayer[]), "");
      SetClientCookie(client, hweaponPrimaryTPlayer, "");
    }
  }

  // CTP
  GetClientCookie(client, hweaponPrimaryCTPlayer, buffer, sizeof(buffer));
  if(!StrEqual(buffer, ""))
  {
    bool has = IsMapHasWeapon(CS_TEAM_CT, 1, buffer);
    if(has)  Format(weaponPrimaryCTPlayer[client], sizeof(weaponPrimaryCTPlayer[]), "%s", buffer);
    else {
      if(weaponCountPrimaryCT > 0) {
        SetClientCookie(client, hweaponSecondaryTPlayer, weaponPrimaryCT[0]);
        Format(weaponPrimaryCTPlayer[client], sizeof(weaponPrimaryCTPlayer[]), "%s", weaponPrimaryCT[0]);
      }
      else {
        Format(weaponPrimaryCTPlayer[client], sizeof(weaponPrimaryCTPlayer[]), "");
        SetClientCookie(client, hweaponPrimaryCTPlayer, "");
      }
    }
  }
  if(StrEqual(buffer,"")){
    if(weaponCountPrimaryCT > 0) {
      SetClientCookie(client, hweaponSecondaryTPlayer, weaponPrimaryCT[0]);
      Format(weaponPrimaryCTPlayer[client], sizeof(weaponPrimaryCTPlayer[]), "%s", weaponPrimaryCT[0]);
    }
    else {
      SetClientCookie(client, hweaponPrimaryCTPlayer, "");
      Format(weaponPrimaryCTPlayer[client], sizeof(weaponPrimaryCTPlayer[]), "");
    }
  }

  // TS
  GetClientCookie(client, hweaponSecondaryTPlayer, buffer, sizeof(buffer));
  if(!StrEqual(buffer, ""))
  {
    bool has = IsMapHasWeapon(CS_TEAM_T, 2, buffer);
    if(has)  Format(weaponSecondaryTPlayer[client], sizeof(weaponSecondaryTPlayer[]), "%s", buffer);
    else {
      if(weaponCountSecondaryT > 0) {
        SetClientCookie(client, hweaponSecondaryTPlayer, weaponSecondaryT[0]);
        Format(weaponSecondaryTPlayer[client], sizeof(weaponSecondaryTPlayer[]), "%s", weaponSecondaryT[0]);
      }
      else {
        SetClientCookie(client, hweaponSecondaryTPlayer, "");
        Format(weaponSecondaryTPlayer[client], sizeof(weaponSecondaryTPlayer[]), "");
      }
    }
  }
  if(StrEqual(buffer,"")){
    if(weaponCountSecondaryT > 0) {
      SetClientCookie(client, hweaponSecondaryTPlayer, weaponSecondaryT[0]);
      Format(weaponSecondaryTPlayer[client], sizeof(weaponSecondaryTPlayer[]), "%s", weaponSecondaryT[0]);
    }
    else {
      SetClientCookie(client, hweaponSecondaryTPlayer, "");
      Format(weaponSecondaryTPlayer[client], sizeof(weaponSecondaryTPlayer[]), "");
    }
  }

  // CTS
  GetClientCookie(client, hweaponSecondaryCTPlayer, buffer, sizeof(buffer));
  if(!StrEqual(buffer, ""))
  {
    bool has = IsMapHasWeapon(CS_TEAM_CT, 2, buffer);
    if(has)  Format(weaponSecondaryCTPlayer[client], sizeof(weaponSecondaryCTPlayer[]), "%s", buffer);
    else {
      if(weaponCountSecondaryCT > 0) {
        Format(weaponSecondaryCTPlayer[client], sizeof(weaponSecondaryCTPlayer[]), "%s", weaponSecondaryCT[0]);
        SetClientCookie(client, hweaponSecondaryCTPlayer, weaponSecondaryCT[0]);
      }
      else {
        SetClientCookie(client, hweaponSecondaryCTPlayer, "");
        Format(weaponSecondaryCTPlayer[client], sizeof(weaponSecondaryCTPlayer[]), "");
      }
    }
  }
  if(StrEqual(buffer,"")){
    if(weaponCountSecondaryCT > 0) {
      Format(weaponSecondaryCTPlayer[client], sizeof(weaponSecondaryCTPlayer[]), "%s", weaponSecondaryCT[0]);
      SetClientCookie(client, hweaponSecondaryCTPlayer, weaponSecondaryCT[0]);
    }
    else {
      SetClientCookie(client, hweaponSecondaryCTPlayer, "");
      Format(weaponSecondaryCTPlayer[client], sizeof(weaponSecondaryCTPlayer[]), "");
    }
  }
}