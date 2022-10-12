/datum/geometry/edge
	var/datum/geometry/point/a
	var/datum/geometry/point/b

/datum/geometry/edge/equals(datum/geometry/edge/other)
	return a.equals(other.a) && b.equals(other.b)

/datum/geometry/edge/volume()
	return 0

/datum/geometry/edge/proc/length()
	return a.dist_point(b)

/datum/geometry/edge/proc/midpoint(metadata)
	RETURN_TYPE(/datum/geometry/point)
	return new /datum/point((a.x + b.x) / 2, (a.y + b.y) / 2, metadata)
