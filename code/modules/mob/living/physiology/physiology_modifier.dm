//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * physiology modifier
 */
/datum/physiology_modifier
	abstract_type = /datum/physiology_modifier

	/// our name
	var/name = "Some Modifier"
	/// is this a globally cached modifier?
	var/is_globally_cached = FALSE
	/// biologies this applies to, for limb-specific modifiers
	var/biology_types = BIOLOGY_TYPES_ALL

	//* -- global modifiers -- *//

	//* carry strength / weight *//
	var/carry_strength_add = 0
	var/carry_strength_factor = 1
	var/carry_strength_bias = 1
	var/carry_weight_add = 0
	var/carry_weight_factor = 1
	var/carry_weight_bias = 1

/datum/physiology_modifier/serialize()
	. = ..()
	if(name != initial(name))
		.["name"] = name
	if(carry_strength_add != initial(carry_strength_add))
		.["carry_strength_add"] = carry_strength_add
	if(carry_strength_factor != initial(carry_strength_factor))
		.["carry_strength_factor"] = carry_strength_factor

/datum/physiology_modifier/deserialize(list/data)
	. = ..()
	if(istext(data["name"]))
		name = data["name"]
	if(isnum(data["carry_strength_add"]))
		carry_strength_add = data["carry_strength_add"]
	if(isnum(data["carry_strength_factor"]))
		carry_strength_factor = data["carry_strength_factor"]
	if(isnum(data["carry_strength_bias"]))
		carry_strength_bias = data["carry_strength_bias"]
	if(isnum(data["carry_weight_add"]))
		carry_weight_add = data["carry_weight_add"]
	if(isnum(data["carry_weight_factor"]))
		carry_weight_factor = data["carry_weight_factor"]
	if(isnum(data["carry_weight_bias"]))
		carry_weight_bias = data["carry_weight_bias"]

/**
 * subtype for hardcoded physiology modifiers
 */
/datum/physiology_modifier/intrinsic
	abstract_type = /datum/physiology_modifier/intrinsic

/**
 * subtype for admin varedit tracking
 */
/datum/physiology_modifier/varedit
	name = "Admin Varedits"

GLOBAL_LIST_EMPTY(cached_physiology_modifiers)

/proc/cached_physiology_modifier(datum/physiology_modifier/path)
	ASSERT(ispath(path, /datum/physiology_modifier))
	ASSERT(initial(path.abstract_type) != path)
	// if it already exists, set default return value to it and return
	if((. = GLOB.cached_physiology_modifiers[path]))
		return
	var/datum/physiology_modifier/modifier = new path
	modifier.is_globally_cached = TRUE
	GLOB.cached_physiology_modifiers[path] = modifier
	return modifier
