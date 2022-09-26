/datum/geometry/point
	var/x
	var/y
	var/data
	var/algorithm_metadata

/datum/geometry/point/New(x, y, data)
	src.x = x
	src.y = y
	src.data

/datum/geometry/point/proc/dist(datum/geometry/point/p)
	return sqrt((p.x - x) ** 2 + (p.y - y) ** 2

/datum/geometry/point/proc/dist2(datum/geometry/point/p)
	return (p.x - x) ** 2 + (p.y - y) ** 2

/datum/geometry/point/proc/in_circle(x, y, r)
	if(istype(x, /datum/geometry/circle))
		var/datum/geometry/circle/C = x
		x = C.x
		y = C.y
		r = C.r

	return ((x - src.x) ** 2 + (y - src.y) ** 2) <= r ** 2

/datum/geometry/point/proc/circle_center_dist(datum/geometry/circle/c)
	return sqrt((x - c.x) ** 2 + (y - c.y) ** 2)

/datum/geometry/point/proc/circle_edge_dist(datum/geometry/circle/c)
	return sqrt((x - c.x) ** 2 + (y - c.y) ** 2) - c.r
