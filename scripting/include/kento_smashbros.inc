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
 * When item should spawn.
 *
 * @param name     Item name.
 * @param pos      Position array.
 * @param vMins     vMins array.
 * @param vMaxs     vMaxs array.
 * @return	no return.
 */
forward Action SB_OnItemSpawn(const char[] name, float pos[3]);
