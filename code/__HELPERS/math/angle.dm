/**
 * angle clockwise from north from point A to point B
 *
 * this is visual angle because pixel shifts don't determine loc.
 *
 * this is also visual angle because ss13 uses weird CW of N instead of CCW of E angles (which the rest of the math world does).
 */
/proc/get_visual_angle(atom/movable/start, atom/movable/end)
	// todo: atan2 instead of atan
	if(!start || !end)
		return 0
	var/dy =(32 * end.y + end.pixel_y) - (32 * start.y + start.pixel_y)
	var/dx =(32 * end.x + end.pixel_x) - (32 * start.x + start.pixel_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

/**
 * angle clockwise from north from point A to point B
 *
 * this is visual angle because pixel shifts don't determine loc.
 *
 * this is also visual angle because ss13 uses weird CW of N instead of CCW of E angles (which the rest of the math world does).
 */
/proc/get_visual_angle_raw(start_x, start_y, start_pixel_x, start_pixel_y, end_x, end_y, end_pixel_x, end_pixel_y)
	// todo: atan2 instead of atan
	var/dy = (32 * end_y + end_pixel_y) - (32 * start_y + start_pixel_y)
	var/dx = (32 * end_x + end_pixel_x) - (32 * start_x + start_pixel_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

/**
 * angle clockwise from north of a certain x / y offset.
 *
 * this is visual angle because pixel shifts don't determine loc.
 *
 * this is also visual angle because ss13 uses weird CW of N instead of CCW of E angles (which the rest of the math world does).
 */
/proc/get_visual_angle_offset(x, y)
	// todo: atan2 instead of atan
	if(!y)
		return (x >= 0) ? 90 : 270
	. = arctan(x/y)
	if(y < 0)
		. += 180
	else if(x < 0)
		. += 360

/**
 * get angle between two movables
 */
/proc/get_physics_angle(atom/movable/A, atom/movable/B)
	// todo: atan2 instead of atan
	if(!start || !end)
		return 0
	var/dy =(32 * end.y + end.step_y) - (32 * start.y + start.step_y)
	var/dx =(32 * end.x + end.step_x) - (32 * start.x + start.step_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

/**
 * get angle between two atoms, ignoring step values
 */
/proc/get_atom_angle(atom/A, atom/B)
	// todo: atan2 instead of atan
	if(!start || !end)
		return 0
	var/dy =(32 * end.y) - (32 * start.y)
	var/dx =(32 * end.x) - (32 * start.x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

