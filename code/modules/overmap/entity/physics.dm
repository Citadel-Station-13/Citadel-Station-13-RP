// obviously this file is wip for ship --> entity conversion huh

/**
 * check if we're moving, used to determine if we need to start ticking
 */
/obj/effect/overmap/visitable/ship/proc/is_moving()
	return QUANTIZE_OVERMAP_DISTANCE(vel_x) || QUANTIZE_OVERMAP_DISTANCE(vel_y)
