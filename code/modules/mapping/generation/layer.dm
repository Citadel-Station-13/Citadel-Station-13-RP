//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * a procedural generation layer
 */
/datum/map_layer
	/// tgui internal id
	var/tgui_key = "MapgenLayer"

/datum/map_layer/proc/tgui_data()
	return list(
		"options" = tgui_options(),
	)

/**
 * returns customizable options
 *
 * return format: list("key" = list(type = "number|string"|"boolean" | list(option1, option2, ...), value = val))
 */
/datum/map_layer/proc/tgui_options()
	return list()
