// Plan:
// Team mode
// FFA mode
// time deathmatch
// lifes
// item api

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <kento_smashbros>
#include <navareautilities>

#pragma newdecls required

#define MAXHEALTHCHECK 500
#define MAXITEMS 100

bool DEBUG = true

// Cvar
ConVar sb_upward_force;
ConVar sb_angles;
ConVar sb_dmg_multiplier;
float fCvarUpwardForce;
float fCvarAngles;
float fCvarDMGMultiplier;

// Natives
Handle OnItemSpawn;

// Last attacker info for rewrite player death event
enum struct LAST_ATTACK {
  int attacker;
  char weapon[64];
}
LAST_ATTACK lastAttack[MAXPLAYERS + 1];

// Player damage
float fPlayerDMG[MAXPLAYERS + 1] = {0.0, ...}
Handle PrintDmgTimer[MAXPLAYERS + 1] = {INVALID_HANDLE, ...};

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
Handle itemTimer = INVALID_HANDLE;


#include "kento_smashbros/natives.sp"
#include "kento_smashbros/config.sp"
#include "kento_smashbros/items.sp"
#include "kento_smashbros/convars.sp"
#include "kento_smashbros/commands.sp"
#include "kento_smashbros/hitlogic.sp"
#include "kento_smashbros/events.sp"

public Plugin myinfo =
{
  name = "[CS:GO] Super Smash Bros - Core",
  author = "Kento",
  description = "Core plugin of Super Smash Bros",
  version = "0.1",
  url = "http://steamcommunity.com/id/kentomatoryoshika/"
};

public void OnPluginStart()
{
  CreateConVars();

  HookEvent("player_spawn", Event_PlayerSpawn);
  HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
  HookEvent("round_start", Event_RoundStart, EventHookMode_Post);

  if(DEBUG) {
    RegConsoleCmd("sm_dmg", Command_Damage);
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

  LoadMapConfig();
}

public void OnClientPostAdminCheck(int client) {
  SDKHook(client, SDKHook_TraceAttack, TraceAttack);
  SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);

  lastAttack[client].attacker = 0;
}

public void OnClientDisconnect(int client){
  SDKUnhook(client, SDKHook_TraceAttack, TraceAttack);
  SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);

  if(PrintDmgTimer[client] != INVALID_HANDLE)
  {
    KillTimer(PrintDmgTimer[client]);
    PrintDmgTimer[client] = INVALID_HANDLE;
  }

  lastAttack[client].attacker = 0;
  Format(lastAttack[client].weapon, 64, "");
}

stock bool IsValidClient(int client)
{
  if (client <= 0) return false;
  if (client > MaxClients) return false;
  if (!IsClientConnected(client)) return false;
  return IsClientInGame(client);
}
