//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Until we get a proper world generation API (map_injections are not enough for worldgen)
 * with layers, this is what you get.
 */
/datum/legacy_jigsaw_worldgen_hijinks
	#warn impl

/datum/legacy_jigsaw_worldgen_hijinks/on_map_pre_init(datum/map_context/map_context, datum/dmm_context/dmm_context)
	..()

	if(!dmm_context)
		return

	if(dmm_context.loaded_bounds[MAP_MINZ] != dmm_context.loaded_bounds[MAP_MAXZ])
		CRASH("legacy_noise_ores only supports injection on a single Z-level at a time")

	// x/y low are aligned towards bottom left
	var/aligned_x_low = max(floor(dmm_context.loaded_bounds[MAP_MINX] / TURF_ALIGNMENT) * TURF_ALIGNMENT, TURF_ALIGNMENT) + 1
	var/aligned_y_low = max(floor(dmm_context.loaded_bounds[MAP_MINY] / TURF_ALIGNMENT) * TURF_ALIGNMENT, TURF_ALIGNMENT) + 1

	// x/y high are aligned towards top right
	var/aligned_x_high = min(ceil(dmm_context.loaded_bounds[MAP_MAXX] / TURF_ALIGNMENT) * TURF_ALIGNMENT, world.maxx - TURF_ALIGNMENT)
	var/aligned_y_high = min(ceil(dmm_context.loaded_bounds[MAP_MAXY] / TURF_ALIGNMENT) * TURF_ALIGNMENT, world.maxy - TURF_ALIGNMENT)

	var/aligned_width = aligned_x_high - aligned_x_low
	var/aligned_height = aligned_y_high - aligned_y_low

	var/grid_width = (aligned_width + 1) / TURF_ALIGNMENT
	var/grid_height = (aligned_height + 1) / TURF_ALIGNMENT

	ASSERT(ISINTEGER(grid_width) && ISINTEGER(grid_height), "Grid width/height must be integer.")

	var/datum/jigsaw_chain_generator/generator = new
	var/datum/jigsaw_buffer/buffer = new(grid_width, grid_height)

	#warn impl
