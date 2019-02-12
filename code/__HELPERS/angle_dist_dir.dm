//Defines for hyper speed.
//These store the result in var/ANGLEVAR, can not be used in statements.
#define AUTO_GET_ANGLE(A, B, ANGLEVAR)\
	var/atom/movable/__A = A;\
	var/atom/movable/__B = B;\
	var/##ANGLEVAR = (istype(__A) && istype(__B))? GET_ANGLE_MOVABLE(__A, __B) : GET_ANGLE(A, B)

#define AUTO_GET_VISUAL_ANGLE(A, B, ANGLEVAR)\
	var/atom/movable/__A = A;\
	var/atom/movable/__B = B;\
	var/##ANGLEVAR = (istype(__A) && istype(__B))? GET_VISUAL_ANGLE_MOVABLE(__A, __B) : GET_VISUAL_ANGLE(A, B)

//These are safe to use in statements.
#define GET_ANGLE(A, B) ATAN2(\
		(\
			(B.x * world.icon_size) -\
			(A.x * world.icon_size)\
		),\
		(\
			(B.y * world.icon_size) -\
			(A.y * world.icon_size)\
		)\
	)

#define GET_VISUAL_ANGLE(A, B) ATAN2(\
		(\
			((B.x * world.icon_size) + B.pixel_x) -\
			((A.x * world.icon_size) + A.pixel_x)\
		),\
		(\
			((B.y * world.icon_size) + B.pixel_y) -\
			((A.y * world.icon_size) + A.pixel_y)\
		)\
	)

#define GET_ANGLE_MOVABLE(A, B) ATAN2(\
		(\
			((B.x * world.icon_size) + B.step_x) -\
			((A.x * world.icon_size) + A.step_x)\
		),\
		(\
			((B.y * world.icon_size) + B.step_y) -\
			((A.y * world.icon_size) + A.step_y)\
		)\
	)

#define GET_VISUAL_ANGLE_MOVABLE(A, B) ATAN2(\
		(\
			((B.x * world.icon_size) + B.step_x + B.pixel_x) -\
			((A.x * world.icon_size) + A.step_x + A.pixel_x)\
		),\
		(\
			((B.y * world.icon_size) + B.step_y + B.pixel_y) -\
			((A.y * world.icon_size) + A.step_y + A.pixel_y)\
		)\
	)

// Returns direction-string, rounded to multiples of 22.5, from the first parameter to the second
// N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
/proc/get_precise_turf_dir(turf/A, turf/B)
	var/degree = GET_ANGLE(A, B)
	switch(round(degree%360, 22.5))
		if(0)
			return "North"
		if(22.5)
			return "North-Northeast"
		if(45)
			return "Northeast"
		if(67.5)
			return "East-Northeast"
		if(90)
			return "East"
		if(112.5)
			return "East-Southeast"
		if(135)
			return "Southeast"
		if(157.5)
			return "South-Southeast"
		if(180)
			return "South"
		if(202.5)
			return "South-Southwest"
		if(225)
			return "Southwest"
		if(247.5)
			return "West-Southwest"
		if(270)
			return "West"
		if(292.5)
			return "West-Northwest"
		if(315)
			return "Northwest"
		if(337.5)
			return "North-Northwest"
