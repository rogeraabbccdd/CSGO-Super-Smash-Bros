ConVar sb_upward_force;
ConVar sb_angles;
ConVar sb_givedmg_multiplier;
ConVar sb_takedmg_multiplier;
ConVar sb_pushback_multiplier;
ConVar sb_ff;

float fCvarUpwardForce;
float fCvarAngles;
float fCvarGiveDMGMultiplier;
float fCvarTakeDMGMultiplier;
float fCvarPushBackMultiplier;
bool bCvarff;

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

  sb_upward_force.AddChangeHook(OnConVarChanged);
  sb_angles.AddChangeHook(OnConVarChanged);
  sb_givedmg_multiplier.AddChangeHook(OnConVarChanged);
  sb_takedmg_multiplier.AddChangeHook(OnConVarChanged);
  sb_pushback_multiplier.AddChangeHook(OnConVarChanged);
  sb_ff.AddChangeHook(OnConVarChanged);

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
}

void GetConVarValues() {
  fCvarUpwardForce = sb_upward_force.FloatValue;
  fCvarAngles = sb_angles.FloatValue;
  fCvarGiveDMGMultiplier = sb_givedmg_multiplier.FloatValue;
  fCvarTakeDMGMultiplier = sb_takedmg_multiplier.FloatValue;
  fCvarPushBackMultiplier = sb_pushback_multiplier.FloatValue;
  bCvarff = sb_ff.BoolValue;
}
