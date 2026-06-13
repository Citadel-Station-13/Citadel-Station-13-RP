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
			auto_marker_config = map.load_auto_marker_config

	if(!auto_marker_config)
		stack_trace("Could not autodetect turf auto-marker configuration, and it was not provided. Defaulting.")
		auto_marker_config = new

	var/datum/jigsaw_template_resultant_config/templates = template_config.get_resultant_config()

	// first, check if it has at least one valid template already emplaced
	// if it doesn't, we have to put one so the broadphase can act on something at all.
	if(!length(generation.broadphase_enqueued))
		generate_impl_place_initial_piece(generation, templates, contextual_center)

	// perform broadphase
	generate_impl_convex_broadphase(generation, templates)

	// emplace broadphase templates
	#warn impl

	// perform narrowphase afterwards
	#warn impl

	// cleanup
	generation.cleanup()

/datum/jigsaw_generator/proc/generate_impl_place_initial_piece(datum/jigsaw_generation/generation, datum/jigsaw_template_resultant_config/templates, turf/contextual_center)
	#warn impl

/datum/jigsaw_generator/proc/generate_impl_convex_broadphase(datum/jigsaw_generation/generation, datum/jigsaw_template_resultant_config/templates)
	#warn impl

/datum/jigsaw_generator/proc/generate_impl_emplace_broadphase(datum/jigsaw_generation/generation, datum/jigsaw_template_resultant_config/templates)
	// get rid of current connectors
	QDEL_LIST(generation.pending_connectors)

	// add hook for pending connectors.
	// what this does is allow templates to spawn connectors that bind into this, so narrowphase
	// can continue to grow the templates.
	GLOB.jigsaw_connectors_pending = generation.pending_connectors


	// place templates down
	for(var/datum/jigsaw_generation_enqueued_placement/placement in generation.broadphase_enqueued)
		var/datum/jigsaw_template/template = placement.template
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

	// dedupe connectors so narrowphase can run cleanly
	var/list/datum/jigsaw_pending_connector/keep_pending_connectors = list()
	for(var/datum/jigsaw_pending_connector/connector in generation.pending_connectors)
		if(connector.spent)
			continue
		keep_pending_connectors += connector
	generation.pending_connectors = keep_pending_connectors

/datum/jigsaw_generator/proc/generate_impl_narrowphase(datum/jigsaw_generation/generation, datum/jigsaw_template_resultant_config/templates)
	#warn impl
