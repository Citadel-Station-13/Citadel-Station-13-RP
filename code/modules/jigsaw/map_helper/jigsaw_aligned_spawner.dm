//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/map_helper/jigsaw_aligned_spawner
	name = "Jigsaw Dungeon Spawner"
	desc = "Automatically emplaces a jigsaw dungeon on mapload."
	#warn sprite

	early = TRUE

	var/datum/jigsaw_template_config/template_config = /datum/jigsaw_template_config/everything
	var/datum/turf_auto_marker_config/auto_marker_config

	var/radius_tiles = 48
	var/radius_horizontal_tiles
	var/radius_vertical_tiles

	var/datum/jigsaw_template/spawn_template_centered
	var/spawn_template_centered_orientation = SOUTH

/obj/map_helper/jigsaw_aligned_spawner/New()
	if(ispath(template_config))
		template_config = new(template_config)
	if(ispath(auto_marker_config))
		auto_marker_config = new(auto_marker_config)
	..()

/obj/map_helper/jigsaw_aligned_spawner/map_initializations(datum/dmm_context/dmm_context, datum/map_context/map_context)
	..()
	generate()

/obj/map_helper/jigsaw_aligned_spawner/proc/generate()
	var/datum/jigsaw_generator/generator = new

	generator.auto_marker_config = auto_marker_config
	generator.template_config = template_config

	var/datum/jigsaw_buffer/generation = new

	if(spawn_template_centered)
		var/datum/jigsaw_template/template = fetch_cached_jigsaw_template(spawn_template_centered)

		if(!template)
			CRASH("Invalid initial template detected; skipping generation.")

		var/datum/jigsaw_buffer_enqueued_placement/initial_placement = new
		#warn impl

		generation.broadphase_enqueued += initial_placement

	generator.generate_at_turf_centered(get_turf(src), generation)
