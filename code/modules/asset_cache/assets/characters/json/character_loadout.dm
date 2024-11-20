//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains:
 *
 * * Loadout Items
 *
 * Requires:
 *
 * * asset_pack/spritesheet/loadout
 */
/datum/asset_pack/json/character_loadout
	name = "CharacterLoadout"

/datum/asset_pack/json/character_loadout/generate()
	. = list()

	var/list/assembling = list()
	for(var/id in global.gear_datums)
		var/datum/loadout_entry/entry = global.gear_datums[id]
		assembling[entry.id] = entry.ui_serialize()
	.["keyedItems"] = assembling

#warn impl
