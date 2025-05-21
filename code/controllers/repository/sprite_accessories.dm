//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(sprite_accessories)
	name = "Repository - Sprite Accessories"
	expected_type = /datum/prototype/sprite_accessory

	var/list/legacy_hair_lookup = list()
	var/list/legacy_facial_hair_lookup = list()
	var/list/legacy_ears_lookup = list()
	var/list/legacy_tail_lookup = list()
	var/list/legacy_wing_lookup = list()

/datum/controller/repository/sprite_accessories/load(datum/prototype/sprite_accessory/instance)
	. = ..()
	if(istype(instance, /datum/prototype/sprite_accessory/ears))
		legacy_ears_lookup[instance.name] = instance
	else if(istype(instance, /datum/prototype/sprite_accessory/hair))
		legacy_hair_lookup[instance.name] = instance
	else if(istype(instance, /datum/prototype/sprite_accessory/facial_hair))
		legacy_facial_hair_lookup[instance.name] = instance
	else if(istype(instance, /datum/prototype/sprite_accessory/tail))
		legacy_tail_lookup[instance.name] = instance
	else if(istype(instance, /datum/prototype/sprite_accessory/wing))
		legacy_wing_lookup[instance.name] = instance


/datum/controller/repository/sprite_accessories/unload(datum/prototype/sprite_accessory/instance)
	. = ..()
	if(istype(instance, /datum/prototype/sprite_accessory/ears))
		legacy_ears_lookup -= instance.name
	else if(istype(instance, /datum/prototype/sprite_accessory/hair))
		legacy_hair_lookup -= instance.name
	else if(istype(instance, /datum/prototype/sprite_accessory/facial_hair))
		legacy_facial_hair_lookup -= instance.name
	else if(istype(instance, /datum/prototype/sprite_accessory/tail))
		legacy_tail_lookup -= instance.name
	else if(istype(instance, /datum/prototype/sprite_accessory/wing))
		legacy_wing_lookup -= instance.name

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
