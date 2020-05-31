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
Check [include file](https://github.com/rogeraabbccdd/CSGO-Super-Smash-Bros/blob/master/scripting/include/kento_smashbros.inc) for more info.

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

### 0.3
- Fix BGM timer.
- Fix item spawn timer.
- Fix trigger_hurt detect.

### 0.4
- Split damage multiplier to give multiplier and take multiplier.
- Multipliers are set by client now.
- Add "sb_ff" svar.
- Fix molotov damage and grenade damage.
- Add more natives.

### 0.5
- Add freezetime countdown timer.
- Add set BGM volume command.
- Add gamemode menu.
- Fix BGM timer length.
- Fix BGM not stop.
- Knock back player to correct direction, not just push up.

### 0.6
- Add forward SB_OnTakeDamage.
- Add round end overlay.
- Add round end countdown sound.
- Fix item spawn timer.
- Add hitgroup multiplier cvars.

### 0.7
- Add weapons settings, data saved in clientprefs by map.
- Fix kill event weapon.
- Add blow away sounds.
- Add cheer sounds when player killed.
- Add item spawned message.
- Fix wrong player damage when take control of bot.

## Video Preview
<a href="https://www.youtube.com/watch?v=3M2km3ePzAY" target="_blank">
  <img height="300" src="https://i.ytimg.com/vi/3M2km3ePzAY/maxresdefault.jpg">
</a>
