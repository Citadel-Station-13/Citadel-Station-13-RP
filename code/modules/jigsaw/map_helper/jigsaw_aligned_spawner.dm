//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/map_helper/jigsaw_aligned_spawner
	name = "Jigsaw Dungeon Spawner"
	desc = "Automatically emplaces jigsaw dungeon(s) on mapload."
	icon = 'icons/modules/jigsaw/map_helpers.dmi'
	icon_state = "spawner"

	early = TRUE

	var/respect_worldgen_overwrite_flags = TRUE

	/**
	 * Best-effort tile radius.
	 * * Because this is an aligned spawner, the radius
	 *   actually determines which aligned tiles we reach into.
	 */
	var/tile_radius = 48

/obj/map_helper/jigsaw_aligned_spawner/map_initializations(datum/dmm_context/dmm_context, datum/map_context/map_context)
	..()
	generate()

/obj/map_helper/jigsaw_aligned_spawner/proc/generate()
	if(!isturf(loc))
		CRASH("Jigsaw spawner must be placed on a turf.")

	if(tile_radius <= 0)
		CRASH("Jigsaw spawner must have a non-negative tile radius.")

	// check and align location
	var/x = loc.x
	var/y = loc.y
	var/z = loc.z

	// x/y low are aligned towards bottom left
	var/aligned_x_low = max(floor(((x - tile_radius) + 1) / TURF_ALIGNMENT) * TURF_ALIGNMENT, TURF_ALIGNMENT) + 1
	var/aligned_y_low = max(floor(((y - tile_radius) + 1) / TURF_ALIGNMENT) * TURF_ALIGNMENT, TURF_ALIGNMENT) + 1

	// x/y high are aligned towards top right
	var/aligned_x_high = min(ceil(((x + tile_radius) + 0) / TURF_ALIGNMENT) * TURF_ALIGNMENT, world.maxx - TURF_ALIGNMENT) - 0
	var/aligned_y_high = min(ceil(((y + tile_radius) + 0) / TURF_ALIGNMENT) * TURF_ALIGNMENT, world.maxy - TURF_ALIGNMENT) - 0

	if(aligned_x_low >= aligned_x_high || aligned_y_low >= aligned_y_high)
		CRASH("Jigsaw spawner has no valid area to generate in; the world is too small.")

	var/aligned_width = aligned_x_high - aligned_x_low
	var/aligned_height = aligned_y_high - aligned_y_low

	var/grid_width = (aligned_width + 1) / TURF_ALIGNMENT
	var/grid_height = (aligned_height + 1) / TURF_ALIGNMENT

	ASSERT(ISINTEGER(grid_width) && ISINTEGER(grid_height), "Grid width/height must be integer.")

	var/datum/jigsaw_buffer/buffer = new(grid_width, grid_height)

	ASSERT(buffer.fits_in_world_at(aligned_x_low, aligned_y_low), "Buffer must fit in world at aligned coordinates.")

	buffer.block_off_according_to_world_at(aligned_x_low, aligned_y_low, z, respect_worldgen_overwrite_flags)

	var/datum/jigsaw_generator_results/results = generate_buffer(buffer)

	buffer.load_into_world(
		aligned_x_low,
		aligned_y_low,
		z,
	)

/obj/map_helper/jigsaw_aligned_spawner/proc/generate_buffer(datum/jigsaw_buffer/buffer) as /datum/jigsaw_generator_results
	return

/obj/map_helper/jigsaw_aligned_spawner/specific
	var/datum/prototype/jigsaw_generator_preset/preset = /datum/prototype/jigsaw_generator_preset/empty

/obj/map_helper/jigsaw_aligned_spawner/specific/New()
	preset = RSjigsaw_generator_presets.fetch_local_or_throw(preset)
	..()

/obj/map_helper/jigsaw_aligned_spawner/specific/generate_buffer(datum/jigsaw_buffer/buffer)
	// generate
	var/datum/jigsaw_generator/generator = new(preset.get_config())
	return generator.generate(buffer)

/obj/map_helper/jigsaw_aligned_spawner/anything

/obj/map_helper/jigsaw_aligned_spawner/anything/generate_buffer(datum/jigsaw_buffer/buffer)
	var/list/datum/prototype/jigsaw_generator_preset/presets = RSjigsaw_generator_presets.fetch_subtypes_mutable(/datum/prototype/jigsaw_generator_preset)

	var/datum/jigsaw_generator_results/overall_results = new
	var/iterations = 100
	var/failed = TRUE

	while(iterations > 0)
		iterations--

		var/datum/prototype/jigsaw_generator_preset/preset = SAFEPICK(presets)
		if(!preset)
			break

			var/datum/jigsaw_chain_generator/generator = new(preset.get_config())
			var/datum/jigsaw_generator_results/results = generator.generate(buffer)
			overall_results.merge_from(results)

			if(!results.failed)
				failed = FALSE
				break

	overall_results.failed = failed

	return overall_results
