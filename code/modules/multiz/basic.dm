// If you add a more comprehensive system, just untick this file.
var/global/list/z_levels = list() // Each bit re... haha just kidding this is a list of bools now

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

/turf/proc/Above()
	return HasAbove(z)? get_step(src, UP) : null

/turf/proc/Below()
	return HasBelow(z)? get_step(src, DOWN) : null



GLOBAL_LIST_EMPTY(connected_z_cache)

/proc/GetConnectedZlevels(z)
	. = list(z)
	// Traverse up and down to get the multiz stack.
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

	// Check stack for any laterally connected neighbors.
	for(var/tz in .)
		var/obj/level_data/level = GLOB.levels_by_z["[tz]"]
		if(level)
			level.find_connected_levels(.)


/proc/AreConnectedZLevels(zA, zB)
	if (zA <= 0 || zB <= 0 || zA > world.maxz || zB > world.maxz)
		return FALSE
	if (zA == zB)
		return TRUE
	if (length(GLOB.connected_z_cache) >= zA && length(GLOB.connected_z_cache[zA]) >= zB)
		return GLOB.connected_z_cache[zA][zB]
	var/list/levels = GetConnectedZlevels(zA)
	var/list/new_entry = new(world.maxz)
	for (var/entry in levels)
		new_entry[entry] = TRUE
	if (GLOB.connected_z_cache.len < zA)
		GLOB.connected_z_cache.len = zA
	GLOB.connected_z_cache[zA] = new_entry
	return new_entry[zB]

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)
