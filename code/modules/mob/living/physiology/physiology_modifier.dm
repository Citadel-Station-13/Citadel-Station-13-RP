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
	var/g_carry_strength_add = 0
	var/g_carry_strength_factor = 1
	var/g_carry_strength_bias = 1
	var/g_carry_weight_add = 0
	var/g_carry_weight_factor = 1
	var/g_carry_weight_bias = 1

	//* -- local modifiers -- *//

	//* inbound damage multiply *//
	var/l_inbound_brute_mod = 1
	var/l_inbound_burn_mod = 1

	//* wound thresholds *//
	var/l_bone_fracture_threshold_mod = 1

	#warn add to admin interface & serialize & deserialize

/datum/physiology_modifier/serialize()
	. = ..()
	if(name != initial(name))
		.["name"] = name
	if(g_carry_strength_add != initial(g_carry_strength_add))
		.["g_carry_strength_add"] = g_carry_strength_add
	if(g_carry_strength_factor != initial(g_carry_strength_factor))
		.["g_carry_strength_factor"] = g_carry_strength_factor

/datum/physiology_modifier/deserialize(list/data)
	. = ..()
	if(istext(data["name"]))
		name = data["name"]
	if(isnum(data["g_carry_strength_add"]))
		g_carry_strength_add = data["g_carry_strength_add"]
	if(isnum(data["g_carry_strength_factor"]))
		g_carry_strength_factor = data["g_carry_strength_factor"]
	if(isnum(data["g_carry_strength_bias"]))
		g_carry_strength_bias = data["g_carry_strength_bias"]
	if(isnum(data["g_carry_weight_add"]))
		g_carry_weight_add = data["g_carry_weight_add"]
	if(isnum(data["g_carry_weight_factor"]))
		g_carry_weight_factor = data["g_carry_weight_factor"]
	if(isnum(data["g_carry_weight_bias"]))
		g_carry_weight_bias = data["g_carry_weight_bias"]

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
