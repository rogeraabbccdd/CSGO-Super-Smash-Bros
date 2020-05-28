ConVar sb_upward_force;
ConVar sb_angles;
ConVar sb_dmg_multiplier;
ConVar sb_pushback_multiplier;
float fCvarUpwardForce;
float fCvarAngles;
float fCvarDMGMultiplier;
float fCvarPushBackMultiplier;

void CreateConVars () {
  sb_upward_force = CreateConVar("sb_upward_force", "1.5", "The upward force multiplier.", FCVAR_NOTIFY, true, 0.0);
  sb_angles = CreateConVar("sb_angles", "50.0", "Angles from 0 to 89. 0 looking down and up to 89 looking up.", FCVAR_NOTIFY, true, 0.0);
  sb_dmg_multiplier = CreateConVar("sb_dmg_multiplier", "0.1", "Dmage to % multiplier\n if set to 0.5, player's % will add damage*0.5", FCVAR_NOTIFY, true, 0.0);
  sb_pushback_multiplier= CreateConVar("sb_pushback_multiplier", "3.0", "Push back distance by damage\nif set to 3.0, distance will be damage*3.0", FCVAR_NOTIFY, true, 0.0);
  
  sb_upward_force.AddChangeHook(OnConVarChanged);
  sb_angles.AddChangeHook(OnConVarChanged);
  sb_dmg_multiplier.AddChangeHook(OnConVarChanged);
  sb_pushback_multiplier.AddChangeHook(OnConVarChanged);

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
  else if (convar == sb_dmg_multiplier)
  {
    fCvarDMGMultiplier = sb_dmg_multiplier.FloatValue;
  }
  else if (convar == sb_pushback_multiplier)
  {
    fCvarPushBackMultiplier = sb_pushback_multiplier.FloatValue;
  }
}

void GetConVarValues() {
  fCvarUpwardForce = sb_upward_force.FloatValue;
  fCvarAngles = sb_angles.FloatValue;
  fCvarDMGMultiplier = sb_dmg_multiplier.FloatValue;
  fCvarPushBackMultiplier = sb_pushback_multiplier.FloatValue;
}
