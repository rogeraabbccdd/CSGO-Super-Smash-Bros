// Plan:
// Team mode
// FFA mode
// time deathmatch
// lifes
// spec

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <kento_smashbros>
#include <navareautilities>
#include <kento_csgocolors>
#include <clientprefs>

#pragma newdecls required

#define MAXHEALTHCHECK 500.0
#define MAXITEMS 100
#define MAXBGMS 100
#define MAXTRIGGER_HURTS 100

bool DEBUG = true;

// Natives
Handle OnItemSpawn;

// Last attacker info for rewrite player death event
enum struct LAST_ATTACK {
  int attacker;
  char weapon[64];
}
LAST_ATTACK lastAttackBy[MAXPLAYERS + 1];
int lastAttack[MAXPLAYERS + 1];

// Player damage
float fPlayerDMG[MAXPLAYERS + 1] = {0.0, ...}

// Display infos
Handle YourDamageMessage;
Handle TargetDamageMessage;

// Map configs
bool isNAUReady = false;
bool spawnroundstart;
float spawninterval;
int spawnitems;
int itemCount = 0;
enum struct ITEMS {
  char name[64];
  float chance;
}
ITEMS items[MAXITEMS];
float totalChace = 0.0;
Handle itemTimer = INVALID_HANDLE;

// BGM configs1
enum struct BGM {
  char name[1024];
  char file[1024];
  float length;
}
BGM bgm[MAXBGMS];
int bgmCount = 0;
Handle hBGMTimer[MAXPLAYERS + 1] = {INVALID_HANDLE, ...};
int currentBGM = -1;

// Cookie
Handle clientVolCookie;
float fvol[MAXPLAYERS+1];

// Trigger hurts on map
int TriggerHurts[MAXTRIGGER_HURTS];
int TriggerCount = 0;

int bWarmUp = false;

#include "kento_smashbros/funcs.sp"
#include "kento_smashbros/convars.sp"
#include "kento_smashbros/natives.sp"
#include "kento_smashbros/config.sp"
#include "kento_smashbros/items.sp"
#include "kento_smashbros/commands.sp"
#include "kento_smashbros/hitlogic.sp"
#include "kento_smashbros/events.sp"
#include "kento_smashbros/bgm.sp"
#include "kento_smashbros/assets.sp"
#include "kento_smashbros/menus.sp"

public Plugin myinfo =
{
  name = "[CS:GO] Super Smash Bros - Core",
  author = "Kento",
  description = "Core plugin of Super Smash Bros",
  version = "0.5",
  url = "http://steamcommunity.com/id/kentomatoryoshika/"
};

public void OnPluginStart()
{
  CreateConVars();

  HookEvent("player_spawn", Event_PlayerSpawn);
  HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
  HookEvent("round_start", Event_RoundStart, EventHookMode_Post);

  clientVolCookie = RegClientCookie("sb_vol", "Super Smash Bros Volume", CookieAccess_Protected);

  LoadTranslations("kento.smashbros.phrases");

  TargetDamageMessage = CreateHudSynchronizer();
  YourDamageMessage = CreateHudSynchronizer();

  RegConsoleCmd("sm_sb", Command_SmashBros);
  RegConsoleCmd("sm_sbvol", Command_Volume);

  if(DEBUG) {
    // Set damage to all players
    RegConsoleCmd("sm_dmg", Command_Damage);
    // Show all players' damage
    RegConsoleCmd("sm_alldmg", Command_AllDamage);
  }
}

public Action DisplayInformation(Handle timer) {
  for (int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i))
    {
      int score = RoundToFloor(fPlayerDMG[i]*100);
      CS_SetClientContributionScore(i, score);
      if(IsPlayerAlive(i) && !IsFakeClient(i))
      {
        SetHudTextParams(0.27, 0.60, 0.11, 255, 255, 255, 255);
        ShowSyncHudText(i, YourDamageMessage, "You: %.2f%%", fPlayerDMG[i]);

        if(IsValidClient(lastAttack[i]) && IsPlayerAlive(lastAttack[i])) {
          int la = lastAttack[i];
          SetHudTextParams(0.63, 0.60, 0.11, 255, 255, 255, 255);
          ShowSyncHudText(i, TargetDamageMessage, "%N: %.2f%%", la, fPlayerDMG[la]);
        }
      }
    }
  }
}

public void OnConfigsExecuted()
{
  GetConVarValues();
}

public void OnMapStart () {
  int iEnt = -1;
  while((iEnt = FindEntityByClassname(iEnt, "func_bomb_target")) != -1) //Find bombsites
  {
    AcceptEntityInput(iEnt,"kill"); //Destroy the entity
  }
  
  while((iEnt = FindEntityByClassname(iEnt, "func_hostage_rescue")) != -1) //Find rescue points
  {
    AcceptEntityInput(iEnt,"kill"); //Destroy the entity
  }
  
  while((iEnt = FindEntityByClassname(iEnt, "func_buyzone")) != -1) //Find buyzone
  {
    AcceptEntityInput(iEnt,"kill"); //Destroy the entity
  }
  
  while((iEnt = FindEntityByClassname(iEnt, "trigger_hurt")) != -1) //Find buyzone
  {
    float dmg = GetEntPropFloat(iEnt, Prop_Data, "m_flDamage");
    LogError("trigger entity %d, %f", iEnt, dmg);
    if(dmg >= 100.0)  {
      TriggerHurts[TriggerCount] = iEnt;
      TriggerCount++;
    }
  }

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

  LoadMapConfig(sMapName2);
  LoadBGMConfig(sMapName2);

  LoadAssets();

  CreateTimer(0.1, DisplayInformation, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void OnClientCookiesCached(int client)
{
  char buffer[5];
  GetClientCookie(client, clientVolCookie, buffer, 5);
  if(!StrEqual(buffer, ""))
  {
    fvol[client] = StringToFloat(buffer);
  }
  if(StrEqual(buffer,"")){
    fvol[client] = 0.8;
  }
}

public void OnClientPutInServer(int client)
{
  if(!IsValidClient(client) && IsFakeClient(client))
    return;
    
  if(currentBGM > -1)
  {
    hBGMTimer[client] = CreateTimer(2.0, BGMTimer, client, TIMER_FLAG_NO_MAPCHANGE);
  }
}

public void OnClientPostAdminCheck(int client) {
  SDKHook(client, SDKHook_TraceAttack, TraceAttack);
  SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);

  ResetClientStatus(client);
}

public void OnClientDisconnect(int client){
  SDKUnhook(client, SDKHook_TraceAttack, TraceAttack);
  SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);

  if(IsFakeClient(client)) return;

  StopBGM(client, currentBGM);
  KillBGMTimer(client);

  for (int i = 1; i <= MaxClients; i++)
  {
    if(lastAttack[i] == client) lastAttack[i] = 0;
  }

  ResetClientStatus(client);
}
