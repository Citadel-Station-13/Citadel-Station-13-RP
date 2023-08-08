/**
 * default implemetation of filling the entire map (or a portion of it) with a certain set of turfs
 */
/datum/map_layer/terrain/flat
	/// turf type
	var/turf_type = /turf/space
	/// lower x
	var/min_x = -INFINITY
	/// lower y
	var/min_y = -INFINITY
	/// upper x
	var/max_x = INFINITY
	/// upper y
	var/max_y = INFINITY

#warn impl all
