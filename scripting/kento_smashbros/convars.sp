ConVar sb_upward_force;
ConVar sb_angles;
ConVar sb_givedmg_multiplier;
ConVar sb_takedmg_multiplier;
ConVar sb_pushback_multiplier;
ConVar sb_head_multiplier;
ConVar sb_chest_multiplier;
ConVar sb_stomach_multiplier;
ConVar sb_leftarm_multiplier;
ConVar sb_rightarm_multiplier;
ConVar sb_leftleg_multiplier;
ConVar sb_rightleg_multiplier;
ConVar sb_ff;
ConVar mp_freezetime;
ConVar mp_restartgame;
ConVar mp_roundtime;

float fCvarUpwardForce;
float fCvarAngles;
float fCvarGiveDMGMultiplier;
float fCvarTakeDMGMultiplier;
float fCvarPushBackMultiplier;
float fCvarhead_multiplier;
float fCvarchest_multiplier;
float fCvarstomach_multiplier;
float fCvarleftarm_multiplier;
float fCvarrightarm_multiplier;
float fCvarleftleg_multiplier;
float fCvarrightleg_multiplier;
bool bCvarff;
float fCvarFreezetime;
int freezetime;
float fmp_roundtime;

float fClientUpwardForce[MAXPLAYERS + 1];
float fClientAngles[MAXPLAYERS + 1];
float fClientGiveDMGMultiplier[MAXPLAYERS + 1];
float fClientTakeDMGMultiplier[MAXPLAYERS + 1];
float fClientPushBackMultiplier[MAXPLAYERS + 1];

void CreateConVars () {
  sb_upward_force = CreateConVar("sb_upward_force", "1.5", "Default upward force multiplier.", FCVAR_NOTIFY, true, 0.0);
  sb_angles = CreateConVar("sb_angles", "50.0", "Default push angles from 0 to 89. 0 looking down and up to 89 looking up.", FCVAR_NOTIFY, true, 0.0);
  sb_givedmg_multiplier = CreateConVar("sb_givedmg_multiplier", "0.1", "Default dmage to % multiplier when giving damage\n Player's % will add damage*give_multiplier*take_multiplier", FCVAR_NOTIFY, true, 0.0);
  sb_takedmg_multiplier = CreateConVar("sb_takedmg_multiplier", "1.0", "Default dmage to % multiplier when taking damage\n Player's % will add damage*give_multiplier*take_multiplier", FCVAR_NOTIFY, true, 0.0);
  sb_pushback_multiplier = CreateConVar("sb_pushback_multiplier", "5.0", "Default push back distance by damage\nif set to 3.0, distance will be damage*3.0", FCVAR_NOTIFY, true, 0.0);
  sb_ff = CreateConVar("sb_ff", "0", "Allow friendly fire or not.", FCVAR_NOTIFY, true, 0.0, true, 1.0);

  sb_head_multiplier = CreateConVar("sb_head_multiplier", "4.0", "Head multiplier.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
  sb_chest_multiplier = CreateConVar("sb_chest_multiplier", "1.0", "Head multiplier.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
  sb_stomach_multiplier = CreateConVar("sb_stomach_multiplier", "1.25", "Head multiplier.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
  sb_leftarm_multiplier = CreateConVar("sb_leftarm_multiplier", "1.0", "Head multiplier.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
  sb_rightarm_multiplier = CreateConVar("sb_rightarm_multiplier", "1.0", "Head multiplier.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
  sb_leftleg_multiplier = CreateConVar("sb_leftleg_multiplier", "0.75", "Head multiplier.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
  sb_rightleg_multiplier = CreateConVar("sb_rightleg_multiplier", "0.75", "Head multiplier.", FCVAR_NOTIFY, true, 0.0, true, 1.0);

  mp_freezetime = FindConVar("mp_freezetime");
  mp_restartgame = FindConVar("mp_restartgame");
  mp_roundtime = FindConVar("mp_roundtime");

  sb_upward_force.AddChangeHook(OnConVarChanged);
  sb_angles.AddChangeHook(OnConVarChanged);
  sb_givedmg_multiplier.AddChangeHook(OnConVarChanged);
  sb_takedmg_multiplier.AddChangeHook(OnConVarChanged);
  sb_pushback_multiplier.AddChangeHook(OnConVarChanged);
  sb_ff.AddChangeHook(OnConVarChanged);

  sb_head_multiplier.AddChangeHook(OnConVarChanged);
  sb_chest_multiplier.AddChangeHook(OnConVarChanged);
  sb_stomach_multiplier.AddChangeHook(OnConVarChanged);
  sb_leftarm_multiplier.AddChangeHook(OnConVarChanged);
  sb_rightarm_multiplier.AddChangeHook(OnConVarChanged);
  sb_leftleg_multiplier.AddChangeHook(OnConVarChanged);
  sb_rightleg_multiplier.AddChangeHook(OnConVarChanged);

  mp_freezetime.AddChangeHook(OnConVarChanged);
  mp_restartgame.AddChangeHook(RestartHandler);
  mp_roundtime.AddChangeHook(OnConVarChanged);

  AutoExecConfig(true, "kento_smashbros");
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
  if (convar == sb_upward_force)
  {
    fCvarUpwardForce = sb_upward_force.FloatValue;
  }
  else if (convar == sb_angles)
  {
    fCvarAngles = sb_angles.FloatValue;
  }
  else if (convar == sb_givedmg_multiplier)
  {
    fCvarGiveDMGMultiplier = sb_givedmg_multiplier.FloatValue;
  }
  else if (convar == sb_takedmg_multiplier)
  {
    fCvarTakeDMGMultiplier = sb_takedmg_multiplier.FloatValue;
  }
  else if (convar == sb_pushback_multiplier)
  {
    fCvarPushBackMultiplier = sb_pushback_multiplier.FloatValue;
  }
  else if (convar == sb_ff)
  {
    bCvarff = sb_ff.BoolValue;
  }
  else if (convar == mp_freezetime)
  {
    fCvarFreezetime = mp_freezetime.FloatValue;
  }
  else if (convar == mp_roundtime)
  {
    fmp_roundtime = mp_roundtime.FloatValue;
  }
  else if (convar == sb_head_multiplier) 
  {
    fCvarhead_multiplier = sb_head_multiplier.FloatValue;
  }
  else if (convar == sb_chest_multiplier) 
  {
    fCvarchest_multiplier = sb_chest_multiplier.FloatValue;
  }
  else if (convar == sb_stomach_multiplier) 
  {
    fCvarstomach_multiplier = sb_stomach_multiplier.FloatValue;
  }
  else if (convar == sb_leftarm_multiplier) 
  {
    fCvarleftarm_multiplier = sb_leftarm_multiplier.FloatValue;
  }
  else if (convar == sb_rightarm_multiplier) 
  {
    fCvarrightarm_multiplier = sb_rightarm_multiplier.FloatValue;
  }
  else if (convar == sb_leftleg_multiplier) 
  {
    fCvarleftleg_multiplier = sb_leftleg_multiplier.FloatValue;
  }
  else if (convar == sb_rightleg_multiplier) 
  {
    fCvarrightleg_multiplier = sb_rightleg_multiplier.FloatValue;
  }
}

void GetConVarValues() {
  fCvarUpwardForce = sb_upward_force.FloatValue;
  fCvarAngles = sb_angles.FloatValue;
  fCvarGiveDMGMultiplier = sb_givedmg_multiplier.FloatValue;
  fCvarTakeDMGMultiplier = sb_takedmg_multiplier.FloatValue;
  fCvarPushBackMultiplier = sb_pushback_multiplier.FloatValue;
  bCvarff = sb_ff.BoolValue;
  fCvarFreezetime = mp_freezetime.FloatValue;
  fmp_roundtime = mp_roundtime.FloatValue;
  fCvarhead_multiplier = sb_head_multiplier.FloatValue;
  fCvarchest_multiplier = sb_chest_multiplier.FloatValue;
  fCvarstomach_multiplier = sb_stomach_multiplier.FloatValue;
  fCvarleftarm_multiplier = sb_leftarm_multiplier.FloatValue;
  fCvarrightarm_multiplier = sb_rightarm_multiplier.FloatValue;
  fCvarleftleg_multiplier = sb_leftleg_multiplier.FloatValue;
  fCvarrightleg_multiplier = sb_rightleg_multiplier.FloatValue;
}

public void RestartHandler(Handle convar, const char[] oldValue, const char[] newValue)
{
	if (convar == mp_restartgame)
	{
    // ResetTimers();
	}
}