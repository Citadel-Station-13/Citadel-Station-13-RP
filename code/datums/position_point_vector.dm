//Designed for things that need precision trajectories like projectiles.
//Don't use this for anything that you don't absolutely have to use this with (like projectiles!) because it isn't worth using a datum unless you need accuracy down to decimal places in pixels.

// todo: rewrite positions they're bad

/datum/position			//For positions with map x/y/z and pixel x/y so you don't have to return lists. Could use addition/subtraction in the future I guess.
	var/x = 0
	var/y = 0
	var/z = 0
	var/pixel_x = 0
	var/pixel_y = 0

/datum/position/proc/valid()
	return x && y && z && !isnull(pixel_x) && !isnull(pixel_y)

/datum/position/New(_x = 0, _y = 0, _z = 0, _pixel_x = 0, _pixel_y = 0)	//first argument can also be a /datum/point.
	if(istype(_x, /datum/point))
		var/datum/point/P = _x
		var/turf/T = P.return_turf()
		_x = T.x
		_y = T.y
		_z = T.z
		_pixel_x = P.return_px()
		_pixel_y = P.return_py()
	else if(istype(_x, /atom))
		var/atom/A = _x
		_x = A.x
		_y = A.y
		_z = A.z
		_pixel_x = A.pixel_x
		_pixel_y = A.pixel_y
	x = _x
	y = _y
	z = _z
	pixel_x = _pixel_x
	pixel_y = _pixel_y

/datum/position/proc/return_turf()
	return locate(x, y, z)

/datum/position/proc/return_px()
	return pixel_x

/datum/position/proc/return_py()
	return pixel_y

/datum/position/proc/return_point()
	return new /datum/point(src)

//* Points *//

/proc/midpoint_between_points(datum/point/a, datum/point/b)	//Obviously will not support multiZ calculations! Same for the two below.
	return new point(a.x + (b.x - a.x) / 2, a.y + (b.y - a.y) / 2, a.z)

/proc/distance_between_points(datum/point/a, datum/point/b)
	return sqrt(((b.x - a.x) ** 2) + ((b.y - a.y) ** 2))

/proc/angle_between_points(datum/point/a, datum/point/b)
	return arctan((b.y - a.y), (b.x - a.x))

/**
 * Precision point on map, used for projectile rendering
 *
 * New() may be called with either:
 * * precision x/y/z pair, with x/y being pixel being from left and bottom respectively, from edge of map
 * * a /datum/position or /atom, with x/y/z/pixel x/pixel y translated accordingly. pixel x/y 0/0 will be x/y offsets 16, 16 on that turf.
 */
/datum/point
	/// pixel x from left of map; 1 is the first pixel.
	var/x
	/// pixel y from bottom of map; 1 is the first pixel.
	var/y
	/// z level
	var/z

/datum/point/New(x, y, z)
	if(!isnum(x))
		switch(x:type)
			if(/datum/position)
				var/datum/position/casted = x
				src.x = casted.x * WORLD_ICON_SIZE - ((WORLD_ICON_SIZE / 2) - 1) + casted.pixel_x
				src.y = casted.y * WORLD_ICON_SIZE - ((WORLD_ICON_SIZE / 2) - 1) + casted.pixel_y
				src.z = casted.z
			if(/datum/point)
				var/datum/point/casted = x
				src.x = casted.x
				src.y = casted.y
				src.z = casted.z
		if(isatom(x))
			var/atom/casted = x
			src.x = casted.x * WORLD_ICON_SIZE - (WORLD_ICON_SIZE / 2) + casted.pixel_x
			src.y = casted.y * WORLD_ICON_SIZE - (WORLD_ICON_SIZE / 2) + casted.pixel_y
			src.z = casted.z
		if(isnull(x))
			return
		CRASH("unknown x value on point init")
	src.x = x
	src.y = y
	src.z = z

/datum/point/clone()
	return new /datum/point(src)

/datum/point/proc/turf()
	return locate(round(x / WORLD_ICON_SIZE) + 1, round(y / WORLD_ICON_SIZE) + 1, z)

/datum/point/proc/coords()
	return list(round(x / WORLD_ICON_SIZE) + 1, round(y / WORLD_ICON_SIZE) + 1, z)

/datum/point/proc/position()
	return new /datum/position(src)

/datum/point/proc/pixel_x()
	. = x % WORLD_ICON_SIZE
	// 32, 32 is aligned to +16, +16 since 16, 16 is the defined 'center' of the point
	return . == 0? 16 : . - 16

/datum/point/proc/pixel_y()
	. = y % WORLD_ICON_SIZE
	// 32, 32 is aligned to +16, +16 since 16, 16 is the defined 'center' of the point
	return . == 0? 16 : . - 16

