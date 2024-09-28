//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * get coordinate and direction tuple when entity is moved relative with a 'block' movement,
 * in respects to a specific anchoring point
 *
 * * this specifically does not support multi-tile objects right now!
 * * coords lists can have extraneous indices beyond 3, they'll just be ignored.
 * * this means chaining this proc is easy!
 *
 * @params
 * * coords - list(x,y,z) of entity
 * * dir - dir of entity
 * * old_coords - list(x,y,z) of pre-move anchor point
 * * new_coords - list(x,y,z) of post-move anchor point
 * * old_dir - dir of pre-move anchor point
 * * new_dir - dir of post-move anchor point
 *
 * @return list(x,y,z,dir) of where the entity should be
 */
/proc/calculate_entity_motion_with_respect_to_moving_point(
	list/coords,
	dir,
	list/old_coords,
	list/new_coords,
	old_dir,
	new_dir,
)

	// unpack everything for readability

	var/entity_x = coords[1]
	var/entity_y = coords[2]

	var/old_x = old_coords[1]
	var/old_y = old_coords[2]

	var/new_x = new_coords[1]
	var/new_y = new_coords[2]
	var/new_z = new_coords[3]

	// get pre-move distances from anchor
	var/dx_from_anchor = old_x - entity_x
	var/dy_from_anchor = old_y - entity_y

	// how we're doing this:
	// we can break this move down to
	// 1. the entity moving around / rotating with the rotating anchor
	// 2. the rotating anchor then translating to the new location

	// thus, first, handle rotation around the anchor

	// dir2angle is north-zero clockwise
	// turn_amount will therefore be how much we need to turn clockwise to get there
	//
	// we know this will be a whole number so we use native % instead of MODULUS_F
	var/turn_amount = (dir2angle(new_dir) - dir2angle(old_dir)) % 360

	// rotated x/y is where the entity will be after being rotated in its **current**
	// location, in respect to the rotating anchor
	var/rotated_x
	var/rotated_y

	switch(turn_amount)
		if(0)
			rotated_x = old_x - dx_from_anchor
			rotated_y = old_y - dy_from_anchor
		if(90)
			rotated_x = old_x - dy_from_anchor
			rotated_y = old_y + dx_from_anchor
		if(180)
			rotated_x = old_x + dx_from_anchor
			rotated_y = old_y + dy_from_anchor
		if(270)
			rotated_x = old_x + dy_from_anchor
			rotated_y = old_y - dx_from_anchor

	// second, handle moving with the anchor

	// get offsets of the anchor's move
	var/dx_from_new = new_x - old_x
	var/dy_from_new = new_y - old_y

	// get the new offsets
	return list(
		rotated_x + dx_from_new,
		rotated_y + dy_from_new,
		new_z,
		turn(dir, -turn_amount), // turn() is counterclockwise, turn_amount is clockwise
	)
