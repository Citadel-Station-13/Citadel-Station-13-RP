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
 *
 * this proc is hilariously, hilariously unstable and changes as backend changes
 * why?
 *
 * because the backend is generally extremely tightly coupled
 * as an example, the backend API assumes all level allocs are done through SSmapping,
 * so it doesn't even allow for the existnece of an unmanaged level already being there;
 * such a thing is impossible outside of severe bugs
 *
 * so in this proc, we're basically hard-setting variables - with potential issues, because
 * this can get desynced with the rest of the subsystem's code - to 'fake' such a proper init cycle.
 *
 * at some point, SSmapping will be better coded, but for now, it's pretty messy.
 */
/datum/controller/subsystem/mapping/proc/load_server_initial_reservation_area(width, height)
	ASSERT(world.maxz == 1)
	world.maxx = width
	world.maxy = height
	ASSERT(length(reserve_levels) == 0)
	// basically makes allocate_level() grab the first one
	reusable_levels += 1
	ordered_levels += null
	world.max_z_changed(0, 1)
	synchronize_datastructures()
	allocate_reserved_level()
