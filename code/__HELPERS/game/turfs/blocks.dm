//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * get turfs bordering a block of turfs
 *
 * * returned list will be empty if distance = 0
 * * returned list will have all nulls incurred by turfs being outside world border
 * * returned list **has no particular order.**
 *
 * @params
 * * ll_x - lowerleft x
 * * ll_y - lowerleft y
 * * ur_x - upperright x
 * * ur_y - upperright y
 * * z - z level
 * * distance - border distance
 *
 * @return list() if distance = 0, list of turfs otherwise. turfs outside of world border will be null.
 */
/proc/border_of_turf_block(ll_x, ll_y, ur_x, ur_y, z, distance)
	if(distance <= 0)
		return list()
	. = block(
		ll_x - distance,
		ll_y - distance,
		z,
		ll_x - 1,
		ur_y + distance,
	) + block(
		ur_x + 1,
		ll_y - distance,
		z,
		ur_x + distance,
		ur_y + distance,
	) + block(
		ll_x,
		ur_y + 1,
		z,
		ur_x,
		ur_y + distance,
	) + block(
		ll_x,
		ll_y - distance,
		z,
		ur_x,
		ll_y - 1,
	)

/**
 * get turfs bordering a block of turfs
 *
 * * returned list will be empty if distance = 0
 * * returned list will have all nulls incurred by turfs being outside world border
 * * returned list is in clockwise order from the **upper left** turf, spiralling outwards from there.
 *
 * @params
 * * ll_x - lowerleft x
 * * ll_y - lowerleft y
 * * ur_x - upperright x
 * * ur_y - upperright y
 * * z - z level
 * * distance - border distance
 *
 * @return list() if distance = 0, list of turfs otherwise. turfs outside of world border will be null.
 */
/proc/border_of_turf_block_spiral_outwards_clockwise(ll_x, ll_y, ur_x, ur_y, z, distance)
	if(distance <= 0)
		return list()
	. = list()
	for(var/radius in distance)
		// gather top left to right
		for(var/x in (ll_x - radius) to (ur_x + radius))
			. += locate(x, ur_y + radius, z)
		// gather right top to bottom excluding top and bottom turf
		for(var/y in (ur_y + radius - 1) to (ll_y - radius + 1) step -1)
			. += locate(ur_x + radius, y, z)
		// gather bottom right to left
		for(var/x in (ur_x + radius) to (ll_x - radius) step -1)
			. += locate(x, ll_y - radius, z)
		// gather left bottom to top excluding top and bottom turf
		for(var/y in (ll_y - radius + 1) to (ur_y + radius - 1))
			. += locate(ll_x - radius, y, z)
