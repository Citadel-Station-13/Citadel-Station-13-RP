//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * line drawing algorithm
 *
 * basically, takes one pixel,
 * and returns all turfs it touches as it passes through a certain angle
 * for a certain number of pixels
 *
 * we can't use DDA or Bresenham because it's, ironically, not as accurate for
 * our purposes.
 *
 * we have to bias full diagonal's (45, 135, 225, 315) to one side
 *
 * todo: make sure this is consistent with how byond would behave if using step; or not, i don't care lmao
 *
 * @params
 * * starting - starting turf
 * * starting_px - pixel x on starting turf. this is not pixel_x on atom, 1 is the bottomleft, 32 is topright.
 * * starting_py - pixel y on starting turf. this is not pixel_y on atom. 1 is bottomleft, 32 is topright.
 * * angle - angle, clockwise of north
 * * distance - pixels to go forwards
 * * include_start - include starting turf
 */
/proc/pixel_physics_raycast(turf/starting, starting_px, starting_py, angle, distance, include_start)
	if(starting_px < 0 || starting_py < 0 || starting_px > 33 || starting_py > 33)
		CRASH("starting_px or starting_py is not 0 < x < 33")
	starting_px = clamp(starting_px, 1, 32)
	starting_py = clamp(starting_py, 1, 32)

	. = list()

	if(include_start)
		. += starting

	// if angle is completely cardinal or completely diagonal
	// we use MODULUS_F because it's floating-compatible
	if(!MODULUS_F(angle, 45))
		angle = angle % 360 // normalize; we already know it's basically diagonal
		if(angle % 90)
			// cardinal
			var/c_sdx
			var/c_sdy
			switch(angle)
				if(0)
					c_sdx = 0
					c_sdy = 1
				if(90)
					c_sdx = 1
					c_sdy = 0
				if(180)
					c_sdx = 0
					c_sdy = -1
				if(270)
					c_sdx = -1
					c_sdy = 0
		else
			var/d_sdx
			var/d_sdy
			// we're diagonal
			switch(angle)
				if(45)
					d_sdx = 1
					d_sdy = 1
				if(135)
					d_sdx = 1
					d_sdy = -1
				if(225)
					d_sdx = -1
					d_sdy = -1
				if(315)
					d_sdx = -1
					d_sdy = 1

	// dx, dy for every distance pixel
	var/ddx = sin(angle)
	var/ddy = cos(angle)

	// sign of dx, dy as 1 or -1
	var/sdx = ddx > 0? 1 : -1
	var/sdy = ddy > 0? 1 : -1

#warn impl
