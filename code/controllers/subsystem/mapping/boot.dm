//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * we must always have atleast one level on the server
 * this is not quite compatible with our new maploader format,
 * so we snowflaked it by compiling a single empty space level
 * this is called during initial world loading to expand that space level to the size of the world,
 * and init it as our first reserved level.
 */
/datum/controller/subsystem/mapping/proc/load_server_initial_reservation_area(width, height)
	ASSERT(world.maxz == 1)
	ASSERT(length(reserve_levels) == 0)
	reserved_level_count = 1
	reserve_levels = list(1)
	world.maxx = width
	world.maxy = height
	ordered_levels = list(new /datum/map_level/reserved)
	world.max_z_changed(0, 1)
