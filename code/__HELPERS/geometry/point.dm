/**
 * core of geometry: the point
 *
 * if data is specified, data will be carried through on cloning of any object with this point
 *
 * data is basically never considered for geometry; it's only there to be helpful for
 * algorithms where converting to/from points can be annoying otherwise.
 */
/datum/geometry/point
	var/x
	var/y
	var/data
	var/algorithm_metadata

/datum/geometry/point/New(x, y, data)
	src.x = x
	src.y = y
	src.data

/datum/geometry/point/equals(datum/geometry/point/other)
	return x == other.x && y == other.y

/datum/geometry/point/volume()
	return 0

/datum/geometry/point/clone()
	return new /datum/geometry/point(x, y, data)

/datum/geometry/point/proc/dist_point(datum/geometry/point/p)
	return sqrt((p.x - x) ** 2 + (p.y - y) ** 2)

/datum/geometry/point/proc/dist2_point(datum/geometry/point/p)
	return (p.x - x) ** 2 + (p.y - y) ** 2
