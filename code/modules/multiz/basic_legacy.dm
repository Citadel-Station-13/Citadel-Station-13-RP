
GLOBAL_LIST_EMPTY(connected_z_cache)

// todo: legacy code
/proc/GetConnectedZlevels(z)
	return SSmapping.level_get_stack(z)

// todo: legacy code
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
