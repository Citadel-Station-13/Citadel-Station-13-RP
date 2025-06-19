//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Attributes must either be text or numbers.
 */
/datum/map_level_attribute
	/// our enum
	var/id
	/// description
	var/desc = "Some kind of attribute."
	/// allow admin editing
	var/allow_edit = FALSE
	/// numeric?
	var/numeric = FALSE

/datum/map_level_attribute/proc/ui_serialize()
	return list(
		"id" = initial(map_level_attribute_path.id),
		"desc" = initial(map_level_attribute_path.desc),
		"allowEdit" = initial(map_level_attribute_path.allow_edit),
		"numeric" = initial(map_level_attribute_path.numeric),
	)

