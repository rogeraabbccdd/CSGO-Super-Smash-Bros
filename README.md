# THIS GAMEMODE IS NOT FINISHED YET.

# CSGO Super Smash Bros
Super Smash Bros gamemode for CSGO.

## Install
- Install [Nav Area Utilities](https://forums.alliedmods.net/showthread.php?p=2607220#post2607220)
- Edit `configs/kento_smashbros/items.cfg`
- Install item modules you need, such as [CSGO Weapons](https://github.com/rogeraabbccdd/CSGO-Super-Smash-Bros-CSGOWeapons)

## Developers
You can create item modules for variety experiences.  
Example item module plugin: [CSGO Weapons](https://github.com/rogeraabbccdd/CSGO-Super-Smash-Bros-CSGOWeapons)

```c
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
```

## Changelog
### 0.1
- Basic damage logic.
- Items config.
- Spawn items on map and items API.

### 0.2
- Add default items settings in config.
- Add BGM settings.
- Add simple damage HUD text.
- Prevent SetClientDamage to negative value.

## Video Preview
<a href="https://www.youtube.com/watch?v=3M2km3ePzAY" target="_blank">
  <img height="300" src="https://i.ytimg.com/vi/3M2km3ePzAY/maxresdefault.jpg">
</a>
