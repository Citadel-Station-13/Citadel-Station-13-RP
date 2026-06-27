//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/map_helper/jigsaw_aligned_spawner
	name = "Jigsaw Dungeon Spawner"
	desc = "Automatically emplaces a jigsaw dungeon on mapload."
	#warn sprite

	early = TRUE

	var/datum/jigsaw_generator_preset/preset = /datum/prototype/jigsaw_generator_preset/empty
	var/respect_worldgen_overwrite_flags = TRUE

	/**
	 * Best-effort tile radius.
	 * * Because this is an aligned spawner, the radius
	 *   actually determines which aligned tiles we reach into.
	 */
	var/tile_radius = 48

/obj/map_helper/jigsaw_aligned_spawner/New()
	preset = RSjigsaw_presets.fetch_local_or_throw(preset)
	..()

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

	buffer.block_off_according_to_world_at(aligned_x_low, aligned_y_low, respect_worldgen_overwrite_flags)

	// generate
	var/datum/jigsaw_generator/generator = new(preset.get_config())

	#warn generate

	#warn apply
