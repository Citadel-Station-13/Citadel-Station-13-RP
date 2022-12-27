/**
 * get north-0-clockwise angle from atom A to atom B
 *
 * does not take into account step positions for movables
 */
/proc/get_physics_angle_tile(atom/A, atom/B)
	CRASH("not implemented")

/**
 * get north-0-clockwise angle from movable A to movable B
 *
 * aims center mass.
 * assumes A, B have centered bounding boxes.
 */
/proc/get_physics_angle_movable(atom/movable/A, atom/movable/B)
	CRASH("not implemented")

/**
 * get north-0-clockwise angle from arbitrary atom A to atom B
 *
 * aims center mass.
 * assumes A, B have centered bounding boxes.
 */
/proc/get_physics_angle(atom/A, atom/B)
	CRASH("not implemented")

/**
 * get north-0-clockwise angle from point x to point y
 */
/proc/get_physics_angle_raw(x1, y1, x2, y2)
	CRASH("not implemented")

#warn impl
