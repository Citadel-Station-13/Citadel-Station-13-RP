//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * get simple log string of current location with zlevel info
 * * shouldn't be player visible
 */
/atom/proc/audit_loc()
	// todo: split down the path chain for specific handling on types
	if(isarea(src))
		. = "('[src]' / [type] / z-[z])"
	else
		var/turf/where = get_turf(src)
		if(where)
			. = "([where.x]-[where.y]-[where.z] - [where.loc ? "'[where.loc]'" : "NULL AREA"] @ '[SSmapping.level_get_id(where.z)]')"
		else
			. = "(null)"

/**
 * get simple log string of current location with zlevel info, along with what we're nested in
 * * shouldn't be player visible
 */
/atom/proc/audit_nested_loc()
	// todo: nesting handling on movables
	return audit_loc()

