//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Datum used to generate jigsaw dungeons.
 */
/datum/jigsaw_generator
	var/datum/jigsaw_generator_config/config

/datum/jigsaw_generator/New(datum/jigsaw_generator_config/config)
	src.config = config

/datum/jigsaw_generator/proc/get_available_templates()
	return list()

#warn impl

/datum/jigsaw_generator/proc/generate_from_initial_piece(datum/prototype/jigsaw_template/initial_piece, turf/lower_left, orientation)

/datum/jigsaw_generator/proc/generate_at_turf_centered(turf/center, radius_horizontal_tiles, radius_vertical_tiles)
	if(isnull(radius_vertical_tiles))
		radius_vertical_tiles = radius_horizontal_tiles

/datum/jigsaw_generator/proc/generate_at_turf_lower_left(turf/lower_left, width, height)


/datum/jigsaw_generator/proc/generate_impl(datum/jigsaw_generation/generation)
	var/contextual_zlev = get_z(contextual_center)
	if(!contextual_zlev)
		CRASH("Invalid contextual center.")

	var/datum/turf_auto_marker_config/auto_marker_config = auto_marker_config
	if(!auto_marker_config)
		var/datum/map/map = SSmapping.level_get_map(contextual_zlev)
		if(map)
			auto_marker_config = map.load_auto_marker_config

	if(!auto_marker_config)
		stack_trace("Could not autodetect turf auto-marker configuration, and it was not provided. Defaulting.")
		auto_marker_config = new

	var/datum/jigsaw_template_resultant_config/templates = template_config.get_resultant_config()

	// first, check if it has at least one valid template already emplaced
	// if it doesn't, we have to put one so the broadphase can act on something at all.
	if(!length(generation.broadphase_enqueued))
		generate_impl_place_initial_piece(generation, templates, contextual_center)

	// seed templates
	generate_impl_seed_grid(generation, templates)

	// emplace templates
	generate_impl_emplace_grid(generation, templates)

	// cleanup
	generation.cleanup()

/datum/jigsaw_generator/proc/generate_impl_place_initial_piece(datum/jigsaw_generation/generation, datum/jigsaw_template_resultant_config/templates, turf/contextual_center)
	#warn impl

/datum/jigsaw_generator/proc/generate_impl_seed_grid(datum/jigsaw_generation/generation, datum/jigsaw_template_resultant_config/templates)
	#warn impl

/datum/jigsaw_generator/proc/generate_impl_emplace_grid(datum/jigsaw_generation/generation, datum/jigsaw_template_resultant_config/templates)
	// place templates down
	for(var/datum/jigsaw_buffer_enqueued/placement in generation.enqueued)
		var/datum/prototype/jigsaw_template/template = placement.template
		var/datum/dmm_context/context = new
		#warn impl context stuff

		template.load_cached()
		template.parsed.load(
			placement.lower_left_x,
			placement.lower_left_y,
			placement.lower_left_z,
			orientation = placement.orientation,
			context = context
		)
