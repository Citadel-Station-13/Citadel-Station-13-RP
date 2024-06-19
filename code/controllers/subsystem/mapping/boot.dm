//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * we must always have atleast one level on the server
 * this is not quite compatible with our new maploader format,
 * so we snowflaked it by compiling a single empty space level
 * this is called during initial world loading to expand that space level to the size of the world,
 * and init it as our first reserved level.
 *
 * width and height exist to init the world's dimensions based on the map being loaded
 * this must be done before anything like spatial hashes are made, as those depend on world dimensions!
 */
/datum/controller/subsystem/mapping/proc/load_server_initial_reservation_area(width, height)
	ASSERT(world.maxz == 1)
	world.maxx = width
	world.maxy = height
	ASSERT(length(reserve_levels) == 0)
	reserved_level_count = 1
	reserve_levels = list(1)
	ordered_levels = list(new /datum/map_level/reserved)
	world.max_z_changed(0, 1)
	initialize_reserved_level(1)
