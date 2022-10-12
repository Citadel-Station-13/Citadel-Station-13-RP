/datum/geometry/triangle
	var/datum/geometry/point/a
	var/datum/geometry/point/b
	var/datum/geometry/point/c

/datum/geometry/triangle/New(datum/geometry/point/a, datum/geometry/point/b, datum/geometry/point/c)
	src.a = a
	src.b = b
	src.c = c

/datum/geometry/triangle/equals(datum/geometry/triangle/other)
	return a.equals(other.a) && b.equals(other.b) && c.equals(other.c)

//todo: /datum/geometry/triangle/volume()

/datum/geometry/triangle/proc/center(metadata)
	return new /datum/geometry/point((a.x + b.x + c.x) / 3, (a.y + b.y + c.y) / 3, metadata)
