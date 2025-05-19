//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * # Map Structs
 *
 * * Used to bunch zlevels up into managed sectors
 * * Internally is used by overmaps to act as level-collections
 * * Internally is used to resolve what levels corrospond to what world-sectors.
 *
 * This is basically the glue struct binding abstracted collections of levels
 * to other systems like overmaps and sectors.
 *
 * This is also the source of truth for those systems. If a map struct
 * is deleted for any reason, everything associated to it including
 * overmap entities and sectors must immediately cease to exist.
 *
 * Nothing is allowed to create or destroy map structs other than SSmapping,
 * which contains public APIs to request creation / destruction / archiving of levels.
 */
/datum/map_struct

	//* Simulation *//
	/// default ceiling height
	var/ceiling_height_default = 5

/**
 * validates our struct
 * * can be called before actually trying to construct
 *
 * @params
 * * z_grid - see construct()
 * * out_errors - (optional) human readable errors get added to this list if provided
 *
 * @return TRUE / FALSE
 */
/datum/map_struct/proc/validate(list/z_grid, list/out_errors)
	. = TRUE
	var/list/planes = list()
	for(var/idx in 1 to length(z_grid))
		var/pos_string = z_grid[idx]
		var/datum/map_level/level = z_grid[pos_string]
		if(!istype(level))
			out_errors?.Add("Index [idx] was not a map level datum.")
			. = FALSE
			continue
		if(!istext(pos_string))
			out_errors?.Add("Index [idx] did not have a valid z-grid string: '[pos_string]'")
			. = FALSE
			continue
		grid_parser.Find(pos_string)
		if(length(grid_parser.group) != 3)
			out_errors?.Add("Index [idx] failed grid position parse: '[pos_string]'.")
			. = FALSE
			continue
		var/x = text2num(grid_parser.group[1])
		var/y = text2num(grid_parser.group[2])
		var/z = text2num(grid_parser.group[3])
		if(length(grid_parser.group) != 3)
			out_errors?.Add("Index [idx] failed grid position decode: '[pos_string]'.")
			. = FALSE
			continue
		LAZYADD(planes["[x],[y]"], level)
	for(var/plane_key in planes)
		var/list/datum/map_level/plane_levels = planes[plane_key]
		var/found_ceiling_height
		for(var/datum/map_level/plane_level as anything in plane_levels)
			if(isnull(plane_level.ceiling_height))
				continue
			if(plane_level.ceiling_height == 0)
				out_errors?.Add("Plane [plane_key] has a zero ceiling height level.")
				. = FALSE
				break
			if(!isnull(found_ceiling_height) && found_ceiling_height != plane_level.ceiling_height)
				out_errors?.Add("Plane [plane_key] has mismatching ceiling heights.")
				. = FALSE
				break
			else
				found_ceiling_height = plane_level.ceiling_height

/**
 * Sets all the transitions and whatnot for our map levels
 *
 * * This'll make them lead to adjacent levels.
 * * This proc will trigger sleeping rebuilds of levels.
 * * This proc is waitfor = FALSE, meaning the rebuilds go on in the background.
 */
/datum/map_struct/proc/link_levels(rebuild = TRUE)
	set waitfor = FALSE
	for(var/datum/map_level/level as anything in levels)
		switch(level.linkage)
			if(Z_LINKAGE_FORCED)
			else
				var/datum/map_level/other
				var/had_vertical = FALSE
				var/had_horizontal = FALSE

				other = z_grid["[level.struct_x+1],[level.struct_y],[level.struct_z]"]
				if(other)
					level.link_east = other
					had_horizontal = TRUE
				other = z_grid["[level.struct_x-1],[level.struct_y],[level.struct_z]"]
				if(other)
					level.link_west = other
					had_horizontal = TRUE
				other = z_grid["[level.struct_x],[level.struct_y+1],[level.struct_z]"]
				if(other)
					level.link_north = other
					had_horizontal = TRUE
				other = z_grid["[level.struct_x],[level.struct_y-1],[level.struct_z]"]
				if(other)
					level.link_south = other
					had_horizontal = TRUE

				other = z_grid["[level.struct_x],[level.struct_y],[level.struct_z+1]"]
				if(other)
					level.link_above = other
					had_vertical = TRUE
				other = z_grid["[level.struct_x],[level.struct_y],[level.struct_z-1]"]
				if(other)
					level.link_below = other
					had_vertical = TRUE

				if(rebuild)
					if(had_horizontal)
						level.rebuild_transitions()
					if(had_vertical)
						level.rebuild_vertical_levels()

	if(rebuild)
		SSmapping.rebuild_transitions()
		SSmapping.rebuild_verticality()

/**
 * Unsets all the transitions for our levels
 *
 * * This'll make them lead nowhere.
 * * This proc will trigger sleeping rebuilds of levels.
 * * This proc is waitfor = FALSE, meaning the rebuilds go on in the background.
 */
/datum/map_struct/proc/unlink_levels(rebuild = TRUE)
	set waitfor = FALSE
	for(var/datum/map_level/level as anything in levels)
		var/had_vertical = level.link_above || level.link_below
		var/had_horizontal = level.link_east || level.link_west || level.link_north || level.link_south
		level.link_above = null
		level.link_below = null
		level.link_east = null
		level.link_west = null
		level.link_north = null
		level.link_south = null
		if(rebuild)
			if(had_horizontal)
				level.rebuild_transitions()
			if(had_vertical)
				level.rebuild_vertical_levels()

	if(rebuild)
		SSmapping.rebuild_transitions()
		SSmapping.rebuild_verticality()

/**
 * Builds and generates our data.
 *
 * * Will also verify integrity of zlevels and whatnot.
 *
 * @params
 * * z_grid - list of "x,y,z" = /datum/map_level instance
 * * link - automatically link levels together after construction?
 */
/datum/map_struct/proc/construct(list/z_grid = src.z_grid, link = TRUE, rebuild = TRUE)
	. = do_construct(z_grid, link, rebuild)
	if(!.)
		deconstruct(link, rebuild)

/datum/map_struct/proc/do_construct(list/z_grid = src.z_grid, link, rebuild)
	PRIVATE_PROC(TRUE)
	// level datums
	var/list/datum/map_level/levels = list()
	// real z-indices
	var/list/level_indices = list()
	// "[x],[y]" = list(levels with x, y)
	var/list/x_y_stacks = list()
	// "[z]" = list(levels in z)
	var/list/z_planes = list()

	var/min_x = INFINITY
	var/min_y = INFINITY
	var/min_z = INFINITY
	var/max_x = -INFINITY
	var/max_y = -INFINITY
	var/max_z = -INFINITY

	// assemble levels
	for(var/tuple in z_grid)
		var/datum/map_level/level_id_or_instance = z_grid[tuple]
		var/datum/map_level/resolved
		if(istext(level_id_or_instance))
			resolved = SSmapping.keyed_levels[level_id_or_instance]
		else if(istype(level_id_or_instance, /datum/map_level))
			resolved = level_id_or_instance
		else if(ispath(level_id_or_instance, /datum/map_level))
			resolved = SSmapping.keyed_levels[initial(level_id_or_instance.id)]
		if(!resolved)
			CRASH("FATAL: failed to resolve a level during struct construction.")
		if(resolved in levels)
			CRASH("FATAL: duplicate level")
		if(!resolved.loaded)
			CRASH("FATAL: attempted to include an unloaded level in a struct. structs do not currently support lazy-loading.")
		if(resolved.struct)
			CRASH("FATAL: level already had struct")

		// add to levels list
		levels += resolved
		level_indices += resolved.z_index
		resolved.struct_level_index = length(levels)

		// parse coords
		grid_parser.Find(tuple)
		var/x = text2num(grid_parser.group[1])
		var/y = text2num(grid_parser.group[2])
		var/z = text2num(grid_parser.group[3])

		if(!ISINRANGE(x, -(SHORT_REAL_LIMIT * 0.5), (SHORT_REAL_LIMIT * 0.5)) || (round(x) != x))
			CRASH("[x] out of bounds or fractional")
		if(!ISINRANGE(y, -(SHORT_REAL_LIMIT * 0.5), (SHORT_REAL_LIMIT * 0.5)) || (round(x) != x))
			CRASH("[y] out of bounds or fractional")
		if(!ISINRANGE(z, -(SHORT_REAL_LIMIT * 0.5), (SHORT_REAL_LIMIT * 0.5)) || (round(x) != x))
			CRASH("[z] out of bounds or fractional")

		min_x = min(min_x, x)
		max_x = max(max_x, x)
		min_y = min(min_y, y)
		max_y = max(max_y, y)
		min_z = min(min_z, z)
		max_z = max(max_z, z)

		// set coords
		resolved.struct_x = x
		resolved.struct_y = y
		resolved.struct_z = z

		// reference us
		resolved.struct = src

		// resolve x_y_stacks and z_planes
		var/list/datum/map_level/x_y_stack = x_y_stacks["[x],[y]"]
		if(x_y_stack)
			x_y_stack += resolved
		else
			x_y_stacks["[x],[y]"] = list(resolved)
		var/list/datum/map_level/z_plane = z_planes["[z]"]
		if(z_plane)
			if((z_plane[length(z_plane)].ceiling_height || ceiling_height_default) != (resolved.ceiling_height || ceiling_height_default))
				stack_trace("mismatched ceiling height on [resolved] against [z_plane[length(z_plane)]] during struct construction, on v-zplane [z]")
			z_plane += resolved
		else
			z_planes["[z]"] = list(resolved)

	// sort x_y_stacks by level z index
	for(var/i in 1 to length(x_y_stacks))
		var/list/stack = x_y_stacks[x_y_stacks[i]]
		tim_sort(stack, /proc/cmp_map_level_struct_z_asc)

	// calculate and sort elevations
	// elevation_tuples = list[z] = elev
	var/list/elevation_tuples = list()
	for(var/i in 1 to length(z_planes))
		var/z_str = z_planes[i]
		var/list/datum/map_level/z_plane = z_planes[z_str]
		elevation_tuples["[z_str]"] = z_plane[1].ceiling_height || ceiling_height_default
	tim_sort(elevation_tuples, /proc/cmp_numeric_text_asc, TRUE)
	// unpack elevations
	var/list/elevation_tuple_z = list()
	var/list/elevation_tuple_height = list()
	for(var/z_str in elevation_tuples)
		var/height = elevation_tuples[z_str]
		elevation_tuple_z += text2num(z_str)
		elevation_tuple_height += height

	// set level data
	for(var/datum/map_level/level as anything in levels)
		level.virtual_alignment_x = level.struct_x * (world.maxx - LEVEL_BORDER_WIDTH * 2) - LEVEL_BORDER_WIDTH
		level.virtual_alignment_y = level.struct_y * (world.maxy - LEVEL_BORDER_WIDTH * 2) - LEVEL_BORDER_WIDTH
		if(level.struct_z == 0)
			level.virtual_elevation = 0
		else if(level.struct_z > 0)
			var/index_of_first_nonnegative
			var/total_height = 0
			for(index_of_first_nonnegative in 1 to length(elevation_tuple_z))
				if(elevation_tuple_z[index_of_first_nonnegative] >= 0)
					break
			var/last_virtual_z  = 0
			for(var/index in index_of_first_nonnegative to length(elevation_tuple_z))
				var/virtual_z = elevation_tuple_z[index]
				if(virtual_z != last_virtual_z)
					total_height += ceiling_height_default * ((virtual_z - 1) - last_virtual_z)
				// if it's on the level we're tallying to we ignore it as we don't tally ourselves
				// because virtual_elevation is meters off the ground.. of the ground.
				if(virtual_z == level.struct_z)
					break
				else if(virtual_z > level.struct_z)
					CRASH("overshot level somehow?")
				// tally current level
				total_height += elevation_tuple_height[index]
				// +1 to skip over the current level, which we already tallied
				last_virtual_z = virtual_z + 1
			level.virtual_elevation = total_height
		else if(level.struct_z < 0)
			var/index_of_first_negative
			var/total_height = 0
			for(index_of_first_negative in length(elevation_tuple_z) to 1 step -1)
				if(elevation_tuple_z[index_of_first_negative] < 0)
					break
			var/last_virtual_z = 0
			for(var/index in index_of_first_negative to 1 step -1)
				var/virtual_z = elevation_tuple_z[index]
				if(virtual_z != last_virtual_z)
					total_height -= ceiling_height_default * (last_virtual_z - (virtual_z + 1))
				// tally current level
				total_height -= elevation_tuple_height[index]
				// if we're on the level we're tallying to, we're done
				if(virtual_z == level.struct_z)
					break
				// sanity check
				else if(virtual_z < level.struct_z)
					CRASH("overshot level somehow?")
			level.virtual_elevation = total_height

	// set our data
	src.z_grid = z_grid
	src.z_indices = level_indices
	src.levels = levels
	src.sparse_size_x = max_x - min_x + 1
	src.sparse_size_y = max_y - min_y + 1
	src.sparse_size_z = max_z - min_z + 1

	if(link)
		link_levels(rebuild)

	constructed = TRUE
	SSmapping.active_structs += src

	SEND_SIGNAL(src, COMSIG_MAP_STRUCT_CONSTRUCTED)

	return TRUE

/**
 * Completely destroys our state and unbinds levels.
 */
/datum/map_struct/proc/deconstruct(unlink = TRUE, rebuild = TRUE)
	if(unlink)
		unlink_levels(rebuild)

	for(var/datum/map_level/level as anything in levels)
		level.virtual_alignment_x = 0
		level.virtual_alignment_y = 0
		level.virtual_elevation = 0
		level.struct = null
		level.struct_x = level.struct_y = level.struct_z = null
		level.struct_level_index = null

	levels = null
	z_indices = null
	z_grid = null
	sparse_size_x = null
	sparse_size_y = null
	sparse_size_z = null

	SSmapping.active_structs -= src
	constructed = FALSE

	SEND_SIGNAL(src, COMSIG_MAP_STRUCT_DECONSTRUCTED)

	return TRUE
