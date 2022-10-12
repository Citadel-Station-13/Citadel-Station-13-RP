/datum/geometry/circle
	var/datum/geometry/point/p
	var/r

/datum/geometry/circle/New(p, r)
	src.p = p
	src.r = r

/datum/geometry/circle/equals(datum/geometry/circle/other)
	return r == other.r && p.equals(other.p)

/datum/geometry/circle/volume()
	return M_PI * r ** 2

/datum/geometry/circle/proc/contains_point(datum/point/p)
	return dist_edge_point(p) < 0

/datum/geometry/circle/proc/dist_center_point(datum/point/p)
	return sqrt((p.x - src.p.x) ** 2 + (p.y - src.p.y) ** 2)

/datum/geometry/circle/proc/dist_edge_point(datum/point/p)
	return dist_center_point(p) - r

