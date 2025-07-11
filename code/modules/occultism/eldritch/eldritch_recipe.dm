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
	var/image/preview = get_preview_image()
	var/serialized_icon = preview && preview.icon && preview.icon_state ? icon2base64(icon(preview.icon, preview.icon_state)) : null

	return list(
		"id" = id,
		"name" = name,
		"desc" = desc,
		"iconAsBase64" = serialized_icon,
	)
