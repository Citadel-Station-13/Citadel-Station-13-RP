//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Datum used to generate jigsaw dungeons.
 */
/datum/jigsaw_generator
	/**
	 * Set to override auto-marker settings. Otherwise, this uses
	 * the map's auto-marker config.
	 */
	var/datum/turf_auto_marker_config/auto_marker_config
	/**
	 * Configuration for templates.
	 */
	var/datum/jigsaw_template_config/template_config

/datum/jigsaw_generator/proc/get_available_templates()
	return list()


#warn impl

/datum/jigsaw_generator/proc/generate_from_initial_piece(datum/jigsaw_template/initial_piece, turf/lower_left, orientation)

/datum/jigsaw_generator/proc/generate_at_turf_centered(turf/target)

/datum/jigsaw_generator/proc/generate_impl(turf/contextual_center, datum/jigsaw_generation/generation = new)
	var/contextual_zlev = get_z(contextual_center)
	if(!contextual_zlev)
		CRASH("Invalid contextual center.")

	var/datum/turf_auto_marker_config/auto_marker_config = auto_marker_config
	if(!auto_marker_config)
		var/datum/map/map = SSmapping.level_get_map(contextual_zlev)
		if(map)
			auto_marker_config = map.auto_marker_config
		else
			stack_trace("Could not autodetect turf auto-marker configuration, and it was not provided. Defaulting.")
			auto_marker_config = new

	// first, check if it has at least one valid template already emplaced
	// if it doesn't, we have to put one so the broadphase can act on something at all.



	// perform broadphase
	generate_impl_convex_broadphase(generation)
		#warn impl

/datum/jigsaw_generator/proc/generate_impl_place_initial_piece(datum/jigsaw_generation/generation, turf/contextual_center)

/datum/jigsaw_generator/proc/generate_impl_convex_broadphase(datum/jigsaw_generation/generation)


