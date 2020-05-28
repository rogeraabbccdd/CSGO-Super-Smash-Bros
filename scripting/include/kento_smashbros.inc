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
native float SB_SetClientDamage(int client, float damage);

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
native float SB_SetClientGiveDamageMultiplier(int client, float multiplier);

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
native float SB_SetClientTakeDamageMultiplier(int client, float multiplier);

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
native float SB_SetClientPushbackMultiplier(int client, float multiplier);

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
native float SB_SetClientUpwardForce(int client, float force);

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
native float SB_SetClientAngle(int client, float angle);

/**
 * When item should spawn.
 *
 * @param name     Item name.
 * @param pos      Position array.
 * @param vMins     vMins array.
 * @param vMaxs     vMaxs array.
 * @return	no return.
 */
forward Action SB_OnItemSpawn(const char[] name, float pos[3]);
