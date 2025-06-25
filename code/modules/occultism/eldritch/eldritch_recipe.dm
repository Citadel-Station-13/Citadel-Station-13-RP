//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * default-locked crafting recipes used by heretics
 */
/datum/crafting_recipe/eldritch_recipe
	abstract_type = /datum/crafting_recipe/eldritch_recipe
	always_available = FALSE

	/// description in interface.
	var/desc = "An eldritch item you can craft."

// TODO: better personal crafting system so we don't need to make this polled

/datum/crafting_recipe/eldritch_recipe/check_special_learned(mob/user)
	return id in user.eldritch_get_holder().recipe_ids

/datum/crafting_recipe/eldritch_recipe/proc/ui_serialize_recipe()
	var/serialized_icon
	#warn impl

	return list(
		"id" = id,
		"name" = name,
		"desc" = desc,
		"iconAsBase64" = serialized_icon,
	)
