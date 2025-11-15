/// I shouldn't have to specify that this is only here because it's an admin proc wrapper, ///
/// and that you shouldn't be using SDQL to invoke the maploader.                          ///

/proc/sdql_dmm_load_raw_level(path, orientation = SOUTH, center = TRUE)
	var/datum/dmm_parsed/parsed = parse_map(isfile(path)? path : file(path))
	if(!parsed.bounds)
		CRASH("seemingly invalid file")
	var/datum/map_level/level = SSmapping.allocate_level(/datum/map_level/dynamic)
	ASSERT(level.z_index)

	var/ll_x = 1
	var/ll_y = 1
	var/ll_z = level.z_index
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? parsed.height : parsed.width
	var/real_height = sideways? parsed.width : parsed.height

	if(center)
		ll_x = round((world.maxx - real_width) / 2)
		ll_x = round((world.maxy - real_height) / 2)

	return parsed.load(ll_x, ll_y, ll_z, orientation = orientation)

/proc/sdql_dmm_load_raw_chunk(path, x, y, z, orientation = SOUTH, center = TRUE)
	ASSERT(x && y && z)

	var/datum/dmm_parsed/parsed = parse_map(isfile(path)? path : file(path))
	if(!parsed.bounds)
		CRASH("seemingly invalid file")

	var/ll_x = x
	var/ll_y = y
	var/ll_z = z
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? parsed.height : parsed.width
	var/real_height = sideways? parsed.width : parsed.height

	if(center)
		ll_x -= round(real_width / 2)
		ll_y -= round(real_height / 2)

	return parsed.load(ll_x, ll_y, ll_z, orientation = orientation)
