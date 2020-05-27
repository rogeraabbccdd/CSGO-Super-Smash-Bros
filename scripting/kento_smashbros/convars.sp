void CreateConVars () {
  sb_upward_force= CreateConVar("sb_upward_force", "1.5", "The upward force multiplier.", FCVAR_NOTIFY, true, 0.0);
  sb_angles = CreateConVar("sb_angles", "50.0", "Angles from 0 to 89. 0 looking down and up to 89 looking up.", FCVAR_NOTIFY, true, 0.0);
  sb_dmg_multiplier = CreateConVar("sb_dmg_multiplier", "0.1", "Dmage to % multiplier\n if set to 0.5, player's % will add damage*0.5", FCVAR_NOTIFY, true, 0.0);
  sb_upward_force.AddChangeHook(OnConVarChanged);
  sb_angles.AddChangeHook(OnConVarChanged);
  sb_dmg_multiplier.AddChangeHook(OnConVarChanged);

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
}

void GetConVarValues() {
  fCvarUpwardForce = sb_upward_force.FloatValue;
  fCvarAngles = sb_angles.FloatValue;
  fCvarDMGMultiplier = sb_dmg_multiplier.FloatValue;
}
