/datum/controller/subsystem/mapping
	/// Ordered list of /datum/space_level - corrosponds to real z values!
	var/static/list/datum/space_level/ordered_levels = list()
	/// id to map level datum
	var/static/list/datum/space_level/keyed_levels = list()
	/// Ordered lookup list for multiz up
	var/list/cached_level_up
	/// Ordered lookup list for multiz down
	var/list/cached_level_down
	/// Ordered lookup list for east transition
	var/list/cached_level_east
	/// Ordered lookup list for west transition
	var/list/cached_level_west
	/// Ordered lookup list for north transition
	var/list/cached_level_north
	/// Ordered lookup list for south transition
	var/list/cached_level_south
	/// 2d array for crosslink lookups
	var/list/crosslinking_grid
	/// Z access lookup - z = list() of zlevels it can access. For performance, this is currently only including bidirectional links, AND does not support looping.
	var/list/z_stack_lookup
	/// Z stack needs updating
	var/z_stack_dirty = TRUE
	/// Active world_structs
	var/static/list/datum/world_struct/structs = list()
	/// World struct lookup by level
	var/static/list/datum/world_struct/struct_by_z = list()

#warn Recover()

/datum/controller/subsystem/mapping/proc/max_z_changed()
	synchronize_datastructures()

/**
 * Ensure all synchronized lists are valid
 */
/datum/controller/subsystem/mapping/proc/synchronize_datastructures()
#define SYNC(var) if(!var) { var = list() ; } ; if(var.len != world.maxz) { . = TRUE ; var.len = world.maxz; }
	. = FALSE
	SYNC(ordered_levels)
	SYNC(cached_level_up)
	SYNC(cached_level_down)
	SYNC(cached_level_east)
	SYNC(cached_level_west)
	SYNC(cached_level_north)
	SYNC(cached_level_south)
	SYNC(z_stack_lookup)
	SYNC(struct_by_z)
	z_stack_dirty = FALSE
	if(.)
		z_stack_dirty = TRUE
#undef SYNC

/**
 * Call whenever a zlevel's up/down is modified
 *
 * This does NOT rebuild turf graphics - call it on each level for that.
 */
/datum/controller/subsystem/mapping/proc/rebuild_verticality(datum/space_level/updated, datum/space_level/targeted, dir)
	if(!updated || !cached_level_up || !cached_level_down)
		// full rebuild
		z_stack_dirty = TRUE
		cached_level_up = list()
		cached_level_down = list()
		cached_level_up.len = world.maxz
		cached_level_down.len = world.maxz
		for(var/i in 1 to world.maxz)
			var/datum/space_level/level = ordered_levels[i]
			cached_level_up[i] = level.resolve_level_in_dir(UP)?.z_value
			cached_level_down[i] = level.resolve_level_in_dir(DOWN)?.z_value
	else
		// smart rebuild
		ASSERT(dir)
		if(!updated.instantiated)
			return
		z_stack_dirty = TRUE
		var/datum/space_level/level = updated
		switch(dir)
			if(UP)
				cached_level_up[level.z_value] = level.resolve_level_in_dir(UP)?.z_value
			if(DOWN)
				cached_level_down[level.z_value] = level.resolve_level_in_dir(DOWN)?.z_value
			else
				CRASH("Invalid dir: [dir]")
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MULTIZ_UPDATE_VERTICAL)

/**
 * Call whenever a zlevel's east/west/north/south is modified
 *
 * This does NOT rebuild turf graphics - call it on each level for that.
 */
/datum/controller/subsystem/mapping/proc/rebuild_transitions(datum/space_level/updated, datum/space_level/targeted, dir)
	if(!updated || !cached_level_east || !cached_level_west || !cached_level_north || !cached_level_south)
		// full rebuild
		cached_level_east = list()
		cached_level_west = list()
		cached_level_north = list()
		cached_level_south = list()
		cached_level_east.len = cached_level_west.len = cached_level_north.len = cached_level_south.len = world.maxz
		for(var/i in 1 to world.maxz)
			var/datum/space_level/level = ordered_levels[i]
			cached_level_north[i] = level.resolve_level_in_dir(NORTH)?.z_value
			cached_level_south[i] = level.resolve_level_in_dir(SOUTH)?.z_value
			cached_level_east[i] = level.resolve_level_in_dir(EAST)?.z_value
			cached_level_west[i] = level.resolve_level_in_dir(WEST)?.z_value
	else
		// smart rebuild
		if(!updated.instantiated)
			return
		ASSERT(dir)
		var/datum/space_level/level = updated
		var/datum/space_level/other
		switch(dir)
			if(NORTH)
				cached_level_north[level.z_value] = level.resolve_level_in_dir(NORTH)?.z_value
			if(SOUTH)
				cached_level_south[level.z_value] = level.resolve_level_in_dir(SOUTH)?.z_value
			if(EAST)
				cached_level_east[level.z_value] = level.resolve_level_in_dir(EAST)?.z_value
			if(WEST)
				cached_level_west[level.z_value] = level.resolve_level_in_dir(WEST)?.z_value
			else
				CRASH("Invalid dir: [dir]")
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MULTIZ_UPDATE_HORIZONTAL)

/**
 * Call to create a new level using a map datum - the map datum should be setup beforehand!
 *
 * Returns the zlevel index used/created.
 */
/datum/controller/subsystem/mapping/proc/instantiate_map_level(datum/space_level/level, load_from_path = TRUE, rebuild_datastructures_immediately = TRUE, rebuild_turfs_immediately = TRUE)
	ASSERT(istype(level))
	#warn add support for filling void tiles where there's no map!
	#warn not-so-microoptimization - change world.turf before z increase!

	// make new level
	var/new_z = allocate_zlevel(level.baseturf)
	#warn above --> void turf behavior??
	#warn MAKE SURE WIDTH/HEIGHT MATCHES PROMISED VALUEs, IF NOT, REJECT
	#warn if promised values are null, we set for them

	if(new_z in reusable_levels)
		reusable_levels -= new_z

	ordered_levels[new_z] = level

	var/list/datum/parsed_map/parsed_maps = list()

	// load path
	if(load_from_path)
		var/path = level.get_path()
		// can be file or path, NO .DMM STRINGS I SWEAR TO GOD
		// currently we do not support lists
		if(fexists(path) || isfile(path))
			var/datum/parsed_map/parsed = new(isfile(path)? path : file(level.get_path()))
			var/width = parsed.width
			var/height = parsed.height
			var/x = level.center? max(round((world.maxx - width) / 2), 1) : 1
			var/y = level.center? max(round((world.maxy - height) / 2), 1) : 1
			#warn fill level actual x/y's in here ahugoashodshojewiwir
			parsed.load(x, y, new_z, TRUE, TRUE, null, null, null, null, FALSE, level.orientation, FALSE, null)
			parsed_maps += parsed
		else if(path)	// didn't find, vs non existant
			stack_trace("Invalid path [path] in [level]")

	var/baseturf = level_baseturf(new_z)
	// for any turfs not changed,
	#warn this is a garbage fucking check, remove it with world.turf change god fucking DAMN
	for(var/turf/T as anything in block(locate(1, 1, new_z), locate(world.maxx, world.maxy, new_z)))
		if(istype(T, world.turf))
			T.ChangeTurf(baseturf, null, CHANGETURF_SKIP)

	// init template bounds
	for(var/datum/parsed_map/parsed as anything in parsed_maps)
		parsed.initTemplateBounds()

	// instantiated
	level.instantiated = TRUE

	// call postload
	level.post_load(., load_from_path)
	#warn we need to register to by id and we need to check for collisions BEFORE we load at all!

	// rebuild caches
	if(rebuild_datastructures_immediately)
		RebuildCrosslinking()
		rebuild_transitions()
		rebuild_verticality()

	if(rebuild_turfs_immediately)
		// we don't have to rebuild our own, because mapload should have done that for up/down, but we do have to do transitions
		level.rebuild_transitions()
		level.rebuild_adjacent_levels()
		level.rebuild_vertical_levels()

	return new_z

/**
 * Creates a naked level
 */
/datum/controller/subsystem/mapping/proc/instantiate_raw_level(rebuild_immediately)
	var/datum/space_level/level = new
	return instantiate_map_level(level, FALSE, rebuild_immediately)

/**
 * Called to instantiate a /datum/map_data's physical levels.
 *
 * Returns an ordered list of zlevel indices used/created, or null if failed
 */
/datum/controller/subsystem/mapping/proc/instantiate_map_datum(datum/map_data/config, load_from_path = TRUE, rebuild_datastructures_immediately = TRUE, rebuild_turfs_immediately = TRUE)
	loaded_levels += config

	var/list/indices = list()

	for(var/datum/space_level/L as anything in config.levels)
		if(!istype(L))
			stack_trace("Invalid level [L] in [config]")
			continue
		indices += instantiate_map_level(L, load_from_path, FALSE, FALSE)

	if(config.world_structs)
		for(var/list/L as anything in config.world_structs)
			if(!islist(L))
				stack_trace("Invalid struct [L] in [config]")
				continue
			var/datum/world_struct/struct = new
			struct.Construct(L, FALSE)

	config.post_load(indices)

	if(rebuild_datastructures_immediately)
		RebuildCrosslinking()
		rebuild_transitions()
		rebuild_verticality()

	if(rebuild_turfs_immediately)
		RebuildMapLevelTurfs(indices)

	return indices.len? indices : null

/**
 * Automatically rebuilds the transitions and multiz of any zlevel that has them.
 * Usually called on world load.
 *
 * Can specify a list of zlevels to check (indices, not datums!), otherwise rebuilds all
 */
/datum/controller/subsystem/mapping/proc/RebuildMapLevelTurfs(list/indices, turfs, transitions)
	if(!indices)
		indices = list()
		for(var/i in 1 to world.maxz)
			indices += i
	for(var/number in indices)
		var/datum/space_level/L = ordered_levels[number]
		if(transitions)
			L.rebuild_transitions()
		if(turfs)
			L.rebuild_turfs()
		CHECK_TICK

#define CL_GRID(x, y, size) ((y - 1) * size + x)
/**
 * Rebuild crosslinking
 *
 * WARNING: Shuffles on every call.
 */
/datum/controller/subsystem/mapping/proc/RebuildCrosslinking()
	// gather levels
	var/list/datum/space_level/linking = list()
	for(var/datum/space_level/potential as anything in ordered_levels)
		if(potential.linkage_mode == Z_LINKAGE_CROSSLINKED)
			linking += potential
	// lay levels out in a 2d grid, the smallest square that can fit them all
	var/size
	for(size in 1 to 10)
		if((size * size) > linking)
			break
	crosslinking_grid = list()
	crosslinking_grid.len = size * size
	linking = shuffle(linking)
	for(var/i in 1 to size)
		for(var/j in 1 to size)
			var/level = CL_GRID(j, i, size)
			var/datum/space_level/L = linking[level]
			crosslinking_grid[level] = linking[L]
			// store the x/y too while we're at it
			L.cl_x = j
			L.cl_y = i
	// link based on this, wrapping around when we reach an edge or null
	if(size == 1)
		// wew
		var/datum/space_level/L = linking[1]
		L.set_east(L)
		L.set_west(L)
		L.set_north(L)
		L.set_south(L)
		return
	for(var/i in 1 to linking.len)
		var/datum/space_level/L = linking[i]
		L._CrosslinkGridScan(crosslinking_grid, size)

/**
 * Internal proc
 *
 * Scans for our neighbors from a grid.
 */
/datum/space_level/proc/_CrosslinkGridScan(list/grid, size)
	// current pos
	var/x
	var/y
	// scan left
	x = cl_x - 1
	y = cl_y
	do
		// wrap
		if(x == 0)
			x = size
		if(grid[CL_GRID(x, y, size)])
			set_west(grid[CL_GRID(x, y, size)])
		--x
	while(x != cl_x)
	// scan right
	x = cl_x + 1
	y = cl_y
	do
		// wrap
		if(x == size)
			x = 1
		if(grid[CL_GRID(x, y, size)])
			set_west(grid[CL_GRID(x, y, size)])
		++x
	while(x != cl_x)
	// scan up
	x = cl_x
	y = cl_y + 1
	do
		// wrap
		if(y == size)
			y = 1
		if(grid[CL_GRID(x, y, size)])
			set_west(grid[CL_GRID(x, y, size)])
		++y
	while(y != cl_y)
	// scan down
	x = cl_x
	y = cl_y - 1
	do
		// wrap
		if(y == 0)
			y = size
		if(grid[CL_GRID(x, y, size)])
			set_west(grid[CL_GRID(x, y, size)])
		++y
	while(y != cl_y)
	ASSERT(east)
	ASSERT(west)
	ASSERT(north)
	ASSERT(south)

#undef CL_GRID

/**
 * Gets the /datum/space_level of a zlevel or id
 */
/datum/controller/subsystem/mapping/proc/fetch_level_datum(id_or_z)
	if(istext(id_or_z))
		return keyed_levels[id_or_z]
	if(id_or_z < 1 || id_or_z > world.maxz)
		CRASH("Z out of bounds")
	return ordered_levels[id_or_z]

/**
 * Gets the /datum/world_struct of a zlevel or id
 */
/datum/controller/subsystem/mapping/proc/fetch_struct_datum(id_or_z)
	#warn impl

/**
 * Gets the sorted Z stack list of a level - the levels accessible from a single level, in multiz
 */
/datum/controller/subsystem/mapping/proc/get_z_stack(z)
	if(z_stack_dirty)
		recalculate_z_stack()
	var/list/L = z_stack_lookup[z]
	return L.Copy()

/**
 * Recalculates Z stack
 *
 * **Warning**: rebuild_verticality must be called to recalculate up/down lookups,
 * as this proc uses them for speed!
 */
/datum/controller/subsystem/mapping/proc/recalculate_z_stack()
	validate_no_loops()
	z_stack_lookup = list()
	z_stack_lookup.len = world.maxz
	var/list/left = list()
	for(var/z in 1 to world.maxz)
		if(struct_by_z[z])
			var/datum/world_struct/struct = struct_by_z[z]
			z_stack_lookup[z] = struct.stack_lookup[struct.real_indices.Find(z)]
		else
			left += z
	var/list/datum/space_level/bottoms = list()
	// let's sing the bottom song
	for(var/z in left)
		if(cached_level_down[z])
			continue
		bottoms += z
	for(var/datum/space_level/bottom as anything in bottoms)
		// register us
		var/list/stack = list(bottom.z_value)
		z_stack_lookup[bottom.z_value] = stack
		// let's sing the list manipulation song
		var/datum/space_level/next = ordered_levels[cached_level_up[bottom.z_value]]
		while(next)
			stack += next.z_value
			z_stack_lookup[next.z_value] = stack
			next = ordered_levels[cached_level_up[next.z_value]]

/**
 * Ensures there's no up/down infinite loops
 */
/datum/controller/subsystem/mapping/proc/validate_no_loops()
	var/list/loops = list()
	for(var/z in 1 to world.maxz)
		var/list/found
		found = list(z)
		var/next = z
		while(next)
			next = cached_level_up[next]
			if(next in found)
				loops += next
				break
			if(next)
				found += next
		next = z
		while(next)
			next = cached_level_down[next]
			if(next in found)
				loops += next
				break
			if(next)
				found += next
	if(!loops.len)
		return
	for(var/z in loops)
		var/datum/space_level/level = ordered_levels[z]
		level.set_up(null)
		level.set_down(null)
		if(struct_by_z[z])
			var/datum/world_struct/struct = struct_by_z[z]
			struct.Deconstruct()
			qdel(struct)
	stack_trace("WARNING: Up/Down loops found in zlevels [english_list(loops)]. This is not allowed and will cause both falling and zcopy to infinitely loop. All zlevels involved have been disconnected, and any structs involved have been destroyed.")
	rebuild_verticality()

/**
 * Gets the list of Z indices on the same horizontal plane as a zlevel in a world_struct
 *
 * Returns list(itself) if not in struct
 */
/datum/controller/subsystem/mapping/proc/levels_in_plane(z)
	if(!struct_by_z[z])
		return list(z)
	var/datum/world_struct/struct = struct_by_z[z]
	return struct.plane_lookup[struct.real_indices.Find(z)]

/**
 * Rebuilds world struct lookup
 */
/datum/controller/subsystem/mapping/proc/rebuild_struct_lookup()
	struct_by_z = list()
	struct_by_z.len = world.maxz
	for(var/datum/world_struct/struct as anything in structs)
		for(var/z in struct.real_indices)
			struct_by_z[z] = struct

/**
 * ensures that a level has a struct; make one with just that level at 0, 0, 0, if needed
 *
 * returns existing OR new struct
 */
/datum/controller/subsystem/mapping/proc/ensure_struct(z)
	RETURN_TYPE(/datum/world_struct)
	#warn impl
