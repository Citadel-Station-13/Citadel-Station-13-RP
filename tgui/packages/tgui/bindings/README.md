# Bindings

## Struct Datums

Format: It goes under `datum/`, and will be named `Game_CamelCasePath`.

* This is only for 'struct' datums without many subtypes.
* This is only for datums where the logic of what a user can see is binary, e.g. /datum/map_level's which are used in admin interfaces.
* This is not for datums with custom behavior for what someone can / can't see, as that would require internal switching while this is just a standardized way to represent datastructures in TGUI.

Example:

`/datum/loadout_item` becomes `datum/Game_LoadoutItem.ts`

Do not be fancy, just do it.

## Asset Pack JSON's

Example:

`/datum/asset_pack/json/character_setup`'s contents should be defined in `asset_packs/Pack_CharacterSetup`
