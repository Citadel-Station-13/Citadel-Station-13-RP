//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * initializes physiology modifiers
 * paths in physiology modifier are converted to the cached instances in globals.
 */
/mob/living/proc/init_physiology()
	for(var/i in 1 to length(physiology_modifiers))
		if(ispath(physiology_modifiers[i]))
			physiology_modifiers[i] = cached_physiology_modifier(physiology_modifiers[i])
	rebuild_physiology()

/**
 * adds a modifier to physiology
 * you are responsible for not double-adding
 * paths are allowed; if modifier is a path, it'll be the globally cached modifier of that type.
 */
/mob/living/proc/add_physiology_modifier(datum/physiology_modifier/modifier)
	if(ispath(modifier))
		modifier = cached_physiology_modifier(modifier)
	ASSERT(!(modifier in physiology_modifiers))
	LAZYADD(physiology_modifiers, modifier)
	global_physiology.apply(modifier)
	return TRUE

/**
 * removes a modifier from physiology
 * you are responsible for not double-adding
 * paths are allowed
 */
/mob/living/proc/remove_physiology_modifier(datum/physiology_modifier/modifier)
	if(ispath(modifier))
		modifier = cached_physiology_modifier(modifier)
	ASSERT(modifier in physiology_modifiers)
	LAZYREMOVE(physiology_modifiers, modifier)
	if(!global_physiology.revert(modifier))
		// todo: optimize with reset().
		rebuild_physiology()
	return TRUE

/**
 * completely rebuilds physiology from our modifiers
 */
/mob/living/proc/rebuild_physiology()
	physiology = new
	for(var/datum/physiology_modifier/modifier as anything in physiology_modifiers)
		if(!istype(modifier))
			physiology_modifiers -= modifier
			continue
		global_physiology.apply(modifier)

// i'm not going to fucking support vv without automated backreferences and macros, holy shit.
// /mob/living/proc/get_varedit_physiology_modifier()
// 	RETURN_TYPE(/datum/physiology_modifier)
// 	. = locate(/datum/physiology_modifier/varedit) in physiology_modifiers
// 	if(!isnull(.))
// 		return
// 	var/datum/physiology_modifier/varedit/new_holder = new
// 	add_physiology_modifier(new_holder)
// 	return new_holder

// todo: you can tell from the proc name that this needs to be kicked somewhere eles later.
/proc/ask_admin_for_a_physiology_modifier(mob/user)
	var/datum/tgui_dynamic_query/query = new
	query.string("name", "Name", "Name your modifier.", 64, FALSE, "Custom Modifier")
	query.number("g_carry_strength_add", "Carry Strength - Add", "Modify the person's base carry strength. Higher is better.", default = 0)
	query.number("g_carry_strength_factor", "Carry Factor - Multiply", "Multiply the person's carry weight/encumbrance to slowdown effect when carrying over their limit. Lower is better.", default = 1)
	query.number("g_carry_strength_bias", "Carry Bias - Multiply", "Multiply the person's carry weight/encumbrance to slowdown bias when carrying over their limit. Lower is better.", default = 1)
	query.number("g_carry_weight_add", "Carry Weight - Add", "Modify the person's base carry weight. Higher is better. This only applies to weight, not encumbrance.", default = 0)
	query.number("g_carry_weight_factor", "Carry Weight - Multiply", "Multiply the person's weight to slowdown effect when carrying over their limit. Lower is better. This only applies to weight, not encumbrance.", default = 1)
	query.number("g_carry_weight_bias", "Carry Weight - Bias", "Multiply the person's weight to slowdown calculation bias; lower is better.", default = 1)

	var/list/choices = tgui_dynamic_input(user, "Add a physiology modifier", "Add Physiology Modifier", query)

	if(isnull(choices))
		return

	var/datum/physiology_modifier/modifier = new

	// we manually deserialize because we might have custom datatypes
	// in the future that won't be serialized by the ui necessarily in the same way
	// we would serialize it via json.

	modifier.name = choices["name"]
	modifier.g_carry_strength_add = choices["g_carry_strength_add"]
	modifier.g_carry_strength_factor = choices["g_carry_strength_factor"]
	modifier.g_carry_strength_bias = choices["g_carry_strength_bias"]
	modifier.g_carry_weight_add = choices["g_carry_weight_add"]
	modifier.g_carry_weight_factor = choices["g_carry_weight_factor"]
	modifier.g_carry_weight_bias = choices["g_carry_weight_bias"]

	return modifier
