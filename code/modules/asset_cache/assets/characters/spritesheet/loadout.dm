//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains sprites of every loadout item, with the name of the sprite being the id of the item.
 */
/datum/asset_pack/spritesheet/loadout
	name = "Loadout"

/datum/asset_pack/spritesheet/loadout/generate()
	for(var/id in global.gear_datums)
		var/datum/loadout_entry/item = global.gear_datums[id]
		var/obj/item/casted_path = item.path
		insert(id, initial(casted_path.icon), initial(casted_path.icon_state), SOUTH, 1, FALSE)
