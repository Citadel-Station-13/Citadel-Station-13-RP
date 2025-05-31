# Bindings

## `game`: DM-side bindings

Format: It goes under `datum/`, and will be named `Game_CamelCasePath`.

This is only for 'struct' `/datum`s without many subtypes, `#define`'d things, etc.

Example:

`/datum/loadout_item` becomes `datum/Game_LoadoutItem.ts`
`ATOM_SPAWN_FLAG_*` -> `DM_AtomSpawnFlags`

Do not be fancy, just do it.

## `json`: Json Assets

Example:

`/datum/asset_pack/json/character_setup`'s contents should be defined in `json/Json_CharacterSetup`

## `spritesheets`: Spritesheet Assets

Just contains spritesheet bindings and constants.
