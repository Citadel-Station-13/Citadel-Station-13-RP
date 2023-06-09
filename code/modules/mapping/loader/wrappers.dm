// basically debug / adminbus / advanced wrappers. never use in code.

// For your ever biggening badminnery kevinz000
// ❤ - Cyberboss
// <3 cyberboss you are epic
/proc/__load_raw_level(path, orientation = SOUTH, center = TRUE)
	var/datum/dmm_parsed/parsed = parse_map(path)
	var/datum/map_level/dynamic/level = new

	SSmapping.allocate_level(level)
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

	parsed.load(ll_x, ll_y, ll_z, orientation = orientation)

/proc/__load_raw_chunk(path, x, y, z, orientation = SOUTH, center = TRUE)
	ASSERT(x && y && z)

	var/datum/dmm_parsed/parsed = parse_map(path)

	var/ll_x = x
	var/ll_y = y
	var/ll_z = z
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? parsed.height : parsed.width
	var/real_height = sideways? parsed.width : parsed.height

	if(center)
		ll_x -= round(real_width / 2)
		ll_y -= round(real_height / 2)

	parsed.load(ll_x, ll_y, ll_z, orientation = orientation)
