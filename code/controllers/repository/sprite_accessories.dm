//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(sprite_accessories)
	name = "Repository - Sprite Accessories"
	expected_type = /datum/prototype/sprite_accessory

/**
 * turns a list of SPRITE_ACCESSORY_SLOT_X = accessory into the cached global accessory instances.
 *
 * accessory may be an accessory, path, or id string.
 */
/datum/controller/repository/sprite_accessories/proc/resolve_slot_key_value_list_inplace(list/accessories)
	for(var/key in accessories)
		var/value = accessories[key]
		accessories[key] = fetch(value)
	return accessories
