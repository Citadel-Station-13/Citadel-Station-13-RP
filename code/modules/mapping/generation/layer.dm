//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * a procedural generation layer
 */
/datum/map_layer
	/// tgui internal id
	var/tgui_key = "MapgenLayer"
	/// seed override
	var/seed
	/// automatic seed provided by map_generation
	var/auto_seed
	/// dirty? regenerate state variables if so
	var/dirty = TRUE

/datum/map_layer/New()

/datum/map_layer/proc/preprocess_seed(seed)
	return seed

/datum/map_layer/proc/get_seed()
	return preprocess_seed(seed || auto_seed)

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
	return list(
		"seed-override" = list(
			type = "string",
			value = seed,
		)
	)

/datum/map_layer/proc/tgui_modify(id, val)
	switch(id)
		if("seed-override")
			src.seed = "[val]"
			return TRUE
	return FALSE

/**
 * set our seed
 */
/datum/map_layer/proc/set_forced_seed(seed)
	if(src.seed == seed)
		return
	dirty = TRUE
	src.seed = seed

/**
 * set our automatic seed
 */
/datum/map_layer/proc/set_auto_seed(seed)
	if(src.auto_seed == seed)
		return
	src.auto_seed = seed
	if(src.seed)
		return
	dirty = TRUE

/**
 * ensure any state variables that need to be generated are online
 */
/datum/map_layer/proc/ensure_state()
	if(dirty)
		setup_state()

/**
 * setup state
 */
/datum/map_layer/proc/setup_state()
	return

/**
 * terrain phase - setup base turfs and areas of the area into buffer
 *
 * @params
 * * generation - generation instance; avoid using this as much as possible.
 * * bounds - bounds in map bounds list format
 * * offsets - list(x, y, z)
 * * lookup - TBD
 * * buffer - TBD
 */
/datum/map_layer/proc/terrain_phase(datum/map_generation/generation, list/bounds, list/offsets, list/lookup, list/buffer)

/**
 * structural sweep - setup structures of the area
 *
 * @params
 * * generation - generation instance; avoid using this as much as possible.
 * * bounds - bounds in map bounds list format
 * * offsets - list(x, y, z)
 */
/datum/map_layer/proc/structural_sweep(datum/map_generation/generation, list/bounds, list/offsets)

/**
 * entity sweep - placing stuff like trees and mobs
 *4
 * @params
 * * generation - generation instance; avoid using this as much as possible.
 * * bounds - bounds in map bounds list format
 * * offsets - list(x, y, z)
 */
/datum/map_layer/proc/entity_sweep(datum/map_generation/generation, list/bounds, list/offsets)

#warn impl all

