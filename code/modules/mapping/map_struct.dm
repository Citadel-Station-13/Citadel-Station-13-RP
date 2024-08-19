//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * # Map Structs
 *
 * * Used to bunch zlevels up into managed sectors
 * * Internally is used by overmaps to act as level-collections
 * * Internally is used to resolve what levels corrospond to what world-sectors.
 */
/datum/map_struct
	//* Core *//
	/// our id
	///
	/// * must be globally (persistence-compatible) unique
	/// * if not provided, will be randomly generated.
	var/id

	//* Simulation *//
	/// default ceiling height
	var/ceiling_height_default = 5

	//* State *//
	/// are we built / created and ready for operation?
	var/tmp/constructed = FALSE
	/// the map_level datums in us
	///
	/// * this is an ordered list
	var/tmp/list/datum/map_level/levels
	/// the real zlevel indices
	///
	/// * this is an ordered list, with indices the same as [levels]
	var/tmp/list/z_indices

	//* Generated Data *//
	/// list of stringified z coordinates to the level datum
	///
	/// * "x,y,z" is the format
	var/tmp/list/z_grid
	/// total width of all levels
	///
	/// * if a level is at 0,0,0 and another is at 5,0,0 with nothing in between, our width is 5
	var/tmp/sparse_size_x
	/// total height of all levels
	///
	/// * if a level is at 0,0,0 and another is at 0,5,0 with nothing in between, our height is 5
	var/tmp/sparse_size_y
	/// total depth of all levels
	///
	/// * if a level is at 0,0,0 and another is at 0,0,5 with nothing in between, our depth is 5
	var/tmp/sparse_size_z

	#warn below

	/// Regex
	var/static/regex/grid_parser = new(@"([\n]+),([\n)]+,([\n]+)", "g")
	/// the overmap object we're attached to
	var/tmp/obj/effect/overmap/visitable/overmap_sector
	#warn hook/impl
	#warn if we're deconstructed this needs to be delinked and instructed to create its own struct later

#warn parse this file
#warn vvguard the parser

/datum/map_struct/Destroy(force)
	if(constructed)
		. = QDEL_HINT_LETMELIVE
		CRASH("Attempted to destroy a constructed map_struct.")
	return ..()

// The below code is a monstrosity.
// I am so sorry.

/datum/map_struct/proc/Construct(list/z_grid = src.z_grid, rebuild = TRUE)
	if(constructed)
		CRASH("Attempted to construct a constructed struct. This is pretty much universally a bad idea.")
	src.z_grid = z_grid
	if(!length(z_grid))
		CRASH("No zlevels")
	if(!Verify())
		CRASH("World struct failed verification")
	// determine dimensions and link + mark real zlevels
	planes = list()
	real_indices = list()
	width = 0
	height = 0
	depth = 0
	// first build x/y/z data and planes
	var/min_x
	var/min_y
	var/min_z
	var/max_x
	var/max_y
	var/max_z
	var/list/plane_cache = list()
	for(var/key in z_grid)
		var/id = z_grid[key]
		var/datum/space_level/L = SSmapping.keyed_levels[id]
		real_indices += L.z_value
		grid_parser.Find(key)
		var/x = text2num(grid_parser.group[1])
		var/y = text2num(grid_parser.group[2])
		var/z = text2num(grid_parser.group[3])
		L.struct_x = x
		L.struct_y = y
		L.struct_z = z
		if(!plane_cache["[z]"])
			plane_cache["[z]"] = list(z)
		else
			plane_cache["[z]"] |= z
		if(key == z_grid[1])
			min_x = max_x = x
			min_y = max_y = y
			min_z = max_z = z
		else
			min_x = min(min_x, x)
			max_x = max(max_x, x)
			min_y = min(min_y, y)
			max_y = max(max_y, y)
			min_z = min(min_z, z)
			max_z = max(max_z, z)
		var/datum/space_level/them
		var/has_up_down = FALSE
		var/has_adjacent = FALSE
		#warn fuck
		// we can build horizontals now, since they aren't as complicated
		them = _scan_dir(z_grid, x, y, z, EAST)
		if(them)
			L.set_east(them)
			has_adjacent = TRUE
		them = _scan_dir(z_grid, x, y, z, WEST)
		if(them)
			L.set_west(them)
			has_adjacent = TRUE
		them = _scan_dir(z_grid, x, y, z, NORTH)
		if(them)
			L.set_north(them)
			has_adjacent = TRUE
		them = _scan_dir(z_grid, x, y, z, SOUTH)
		if(them)
			L.set_south(them)
			has_adjacent = TRUE
		// build verticals too
		them = _scan_dir(z_grid, x, y, z, UP)
		if(them)
			L.set_up(them)
			has_up_down = TRUE
		them = _scan_dir(z_grid, x, y, z, DOWN)
		if(them)
			L.set_down(them)
			has_up_down = TRUE
		if(rebuild)
			if(has_adjacent)
				L.rebuild_transitions()
			if(has_up_down)
				L.rebuild_turfs()
	for(var/z_text in plane_cache)
		planes += plane_cache[z_text]
	width = max_x - min_x + 1
	height = max_y - min_y + 1
	depth = max_z - min_z + 1
	// now to build the vertical linkages and stacks
	// oh god this is going to be messy
	var/list/bottom_keys = get_bottom_level_keys(z_grid)
	stacks = build_stacks(z_grid, bottom_keys)
	// lastly, build plane and stack lookups
	ASSERT(real_indices.len == z_grid.len)
	plane_lookup = list()
	plane_lookup.len = real_indices.len
	for(var/i in 1 to real_indices.len)
		var/z = real_indices[i]
		var/list/found
		for(var/j in 1 to planes)
			var/list/L = planes[j]
			if(L.Find(z))
				plane_lookup[i] = L
				break
	stack_lookup = list()
	stack_lookup.len = real_indices.len
	for(var/i in 1 to real_indices.len)
		var/z = real_indices[i]
		var/list/found
		for(var/j in 1 to stacks)
			var/list/L = stacks[j]
			if(L.Find(z))
				plane_lookup[i] = L
				break
	// register
	Register()
	constructed = TRUE

/datum/map_struct/proc/Deconstruct(rebuild = TRUE)
	if(!constructed)
		CRASH("Tried to deconstruct a map_struct that isn't constructed.")
	for(var/datum/space_level/L as anything in levels)
		var/had_up_down = L.resolve_level_in_dir(UP) || L.resolve_level_in_dir(DOWN)
		var/had_adjacent = L.resolve_level_in_dir(NORTH) || L.resolve_level_in_dir(SOUTH) || L.resolve_level_in_dir(EAST) || L.resolve_level_in_dir(WEST)
		L.struct = null
		L.set_down(null)
		L.set_east(null)
		L.set_west(null)
		L.set_south(null)
		L.set_north(null)
		L.set_up(null)
		L.struct_x = 0
		L.struct_y = 0
		L.struct_z = 0
		if(rebuild)
			if(had_adjacent)
				INVOKE_ASYNC(L, /datum/space_level/proc/rebuild_transitions)
			if(had_up_down)
				INVOKE_ASYNC(L, /datum/space_level/proc/rebuild_turfs)
	Unregister(rebuild)
	constructed = FALSE

/datum/map_struct/proc/Register(rebuild = TRUE)
	SSmapping.structs += src
	SSmapping.z_stack_dirty = TRUE
	if(rebuild)
		SSmapping.rebuild_struct_lookup()
		SSmapping.rebuild_verticality()
		SSmapping.rebuild_transitions()
		SSmapping.RebuildCrosslinking()

/datum/map_struct/proc/Unregister(rebuild = TRUE)
	SSmapping.structs -= src
	SSmapping.z_stack_dirty = TRUE
	if(rebuild)
		SSmapping.rebuild_struct_lookup()
		SSmapping.rebuild_verticality()
		SSmapping.rebuild_transitions()
		SSmapping.RebuildCrosslinking()

/**
 * Ensures all level IDs exist as currently instantiated levels,
 * and also ensures there's no dupe keys/IDs
 */
/datum/map_struct/proc/Verify()
	. = TRUE
	var/list/keymap = list()
	var/list/idmap = list()
	for(var/key in z_grid)
		if(keymap[key])
			stack_trace("Duplicate key [key].")
			. = FALSE
		keymap[key] = TRUE
		grid_parser.Find(key)
		if(key != "[grid_parser.group[1]],[grid_parser.group[2]],[grid_parser.group[3]]")
			stack_trace("Invalid key [key].")
			. = FALSE
		var/id = z_grid[key]
		if(!SSmapping.keyed_levels[id])
			stack_trace("Couldn't locate level id [id] in SSmapping keyed_levels list.")
			. = FALSE
		if(SSmapping.keyed_levels[id].struct)
			stack_trace("Level id [id] was already in a struct.")
			. = FALSE
		if(idmap[id])
			stack_trace("Duplicate level ID [id]")
			. = FALSE
		idmap[id] = TRUE

//! level fetching
/**
 * returns mutable copy of real_indices
 */
/datum/map_struct/proc/fetch_z_list()
	return real_indices.Copy()

/**
 * directly fetches real indices
 * DO NOT MODIFY RETURNED LIST
 */
/datum/map_struct/proc/direct_z_list()
	return real_indices
