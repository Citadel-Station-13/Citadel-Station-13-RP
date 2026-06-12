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

/datum/jigsaw_generator/proc/get_available_templates()
	return list()


#warn impl

/datum/jigsaw_generator/proc/generate_from_initial_piece(datum/jigsaw_template/initial_piece, turf/lower_left, orientation)

/datum/jigsaw_generator/proc/generate_at_turf_centered(turf/target)

/datum/jigsaw_generator/proc/generate_impl()

	var/datum/turf_auto_marker_config/config = auto_marker_config
	if(!config)
		#warn impl

/datum/jigsaw_generator/proc/generate_impl_convex_broadphase(datum/jigsaw_generation/generation)


