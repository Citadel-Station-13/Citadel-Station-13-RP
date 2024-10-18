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

#warn impl

/datum/loadout_item_descriptor/serialize()
	return list()

/datum/loadout_item_descriptor/deserialize(list/data)

/**
 * Binding: tgui/bindings/datum/Game_LoadoutItemDescriptor
 */
/datum/loadout_item_descriptor/proc/tgui_data()
	#warn impl
