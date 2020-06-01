#if defined _kento_sb_included
  #endinput
#endif

/**
 * Gets client damages.
 *
 * @param client     Player index.
 * @return	client damages.
 */
native float SB_GetClientDamage(int client);

/**
 * Sets client damages.
 *
 * @param client     Player index.
 * @param damage     Damage value to set.
 * @return	true if success, otherwise false.
 */
native bool SB_SetClientDamage(int client, float damage);

/**
 * Gets client give damage multiplier.
 *
 * @param client     Player index.
 * @return	client give damage multiplier.
 */
native float SB_GetClientGiveDamageMultiplier(int client);

/**
 * Sets client give damage multiplier.
 *
 * @param client     Player index.
 * @param multiplier     value to set.
 * @return	true if success, otherwise false.
 */
native bool SB_SetClientGiveDamageMultiplier(int client, float multiplier);

/**
 * Gets client take damage multiplier.
 *
 * @param client     Player index.
 * @return	client take damage multiplier.
 */
native float SB_GetClientTakeDamageMultiplier(int client);

/**
 * Sets client take damage multiplier.
 *
 * @param client     Player index.
 * @param multiplier     value to set.
 * @return	true if success, otherwise false.
 */
native bool SB_SetClientTakeDamageMultiplier(int client, float multiplier);

/**
 * Gets client pushback multiplier.
 *
 * @param client     Player index.
 * @return	client pushback multiplier.
 */
native float SB_GetClientPushbackMultiplier(int client);

/**
 * Sets client pushback multiplier.
 *
 * @param client     Player index.
 * @param multiplier     value to set.
 * @return	true if success, otherwise false.
 */
native bool SB_SetClientPushbackMultiplier(int client, float multiplier);

/**
 * Gets client upward force.
 *
 * @param client     Player index.
 * @return	client upward force.
 */
native float SB_GetClientUpwardForce(int client);

/**
 * Sets client upward force.
 *
 * @param client     Player index.
 * @param force     value to set.
 * @return	true if success, otherwise false.
 */
native bool SB_SetClientUpwardForce(int client, float force);

/**
 * Gets client angle.
 *
 * @param client     Player index.
 * @return	client angle.
 */
native float SB_GetClientAngle(int client);

/**
 * Sets client angle.
 *
 * @param client     Player index.
 * @param force     value to set.
 * @return	true if success, otherwise false.
 */
native bool SB_SetClientAngle(int client, float angle);

/**
 * Sets client angle.
 *
 * @param client     Player index.
 * @param force     value to set.
 * @return	true if success, otherwise false.
 */
native bool SB_KnockBackClient(int client, int attacker);

/**
 * When item should spawn.
 *
 * @param name     Item name.
 * @param pos      Position array.
 * @return	no return.
 */
forward Action SB_OnItemSpawn(const char[] name, float pos[3]);

/**
 * When client knockback.
 *
 * @param victim     Victim player index.
 * @param attacker      Attacker player index.
 * @velocity    Knockback velocity
 * @return	no return.
 */
forward Action SB_OnClientKnockBack(int victim, int attacker, float velocity[3]);

/**
 * When player take damage.
 *
 * @param victim     Victim player index.
 * @param attacker     Attacker player index.
 * @param inflictor     inflictor entity index, -1 if invalid.
 * @param damage      Damage
 * @return	no return.
 */
forward Action SB_OnTakeDamage(int victim, int attacker, int inflictor, float damage);
