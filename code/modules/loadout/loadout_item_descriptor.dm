//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Instance descriptor of loadout items
 */
/datum/loadout_item_descriptor
	/// loadout_item id
	var/id
	/// packed coloration string
	var/coloration

/datum/loadout_item_descriptor/serialize()
	return list(
		"id" = id,
		"coloration" = coloration,
	)

/datum/loadout_item_descriptor/deserialize(list/data)
	id = data["id"]
	coloration = data["coloration"]

/**
 * Binding: `Game_LoadoutItemDescriptor`
 */
/datum/loadout_item_descriptor/ui_serialize()
	return list(
		"id" = id,
		"colors" = unpack_coloration_string(coloration),
	)

/**
 * Set coloration to a packed string.
 *
 * * Does not sanitize. Be careful.
 */
/datum/loadout_item_descriptor/proc/set_packed_coloration(packed)
	coloration = packed

/**
 * Set coloration to a set of channels.
 *
 * * Does not sanitize. Be careful.
 */
/datum/loadout_item_descriptor/proc/set_unpacked_coloration(list/colors)
	coloration = pack_coloration_string(colors)
