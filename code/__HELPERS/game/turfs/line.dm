//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
 * * diagonal_expand_north - get turfs above diagonal if perfect diagonal. if both expand params are null, we use the same priority as SS13's movement handler.
 * * diagonal_expand_south - get turfs below diagonal if perfect diagonal. if both expand params are null, we use the same priority as SS13's movement handler.
 */
/proc/pixel_physics_raycast(turf/starting, starting_px, starting_py, angle, distance, include_start, diagonal_expand_north, diagonal_expand_south)
	if(starting_px < 0 || starting_py < 0 || starting_px > 33 || starting_py > 33)
		CRASH("starting_px or starting_py is not 0 < x < 33")
	starting_px = clamp(starting_px, 1, 32)
	starting_py = clamp(starting_py, 1, 32)

	. = list()

	if(include_start)
		. += starting

	var/remaining_distance = distance
	var/safety = world.maxx + world.maxy

	// if angle is completely cardinal or completely diagonal
	// we use MODULUS_F because it's floating-compatible
	if(!MODULUS_F(angle, 45))
		// normalize; we already know it's basically diagonal
		angle = angle % 360
		if(angle < 0)
			angle += 360
		// go do cardinal / diagonal specials
		if(!(angle % 90))
			// cardinal
			var/c_sdx
			var/c_sdy
			var/c_dist_to_next
			var/turf/c_moving_into = starting
			switch(angle)
				if(0)
					c_sdx = 0
					c_sdy = 1
					c_dist_to_next = (WORLD_ICON_SIZE + 0.5) - starting_py
				if(90)
					c_sdx = 1
					c_sdy = 0
					c_dist_to_next = (WORLD_ICON_SIZE + 0.5) - starting_px
				if(180)
					c_sdx = 0
					c_sdy = -1
					c_dist_to_next = starting_py - 0.5
				if(270)
					c_sdx = -1
					c_sdy = 0
					c_dist_to_next = starting_px - 0.5

			remaining_distance -= c_dist_to_next
			while(remaining_distance >= 0)
				c_moving_into = locate(c_moving_into.x + c_sdx, c_moving_into.y + c_sdy, c_moving_into.z)
				if(!c_moving_into)
					break
				. += c_moving_into
				remaining_distance -= WORLD_ICON_SIZE
			return
		else
			var/is_diagonal_case
			var/turf/d_moving_into = starting
			var/d_diagonal_distance = (((WORLD_ICON_SIZE ** 2) * 2) ** 0.5)
			var/d_dist_to_next
			var/d_sdx
			var/d_sdy
			/// direction to go if we want to include the northern-most cardinal step
			var/d_north_dir
			/// direction to go if we want to include the southern-most cardinal step
			var/d_south_dir
			/// direction to go if using ss13 native movement to solve for the cardinal steps
			var/d_native_dir
			// we're diagonal
			switch(angle)
				if(45)
					is_diagonal_case = round(starting_px, 1) == round(starting_py, 1)
					d_sdx = 1
					d_sdy = 1
					d_dist_to_next = ((((WORLD_ICON_SIZE + 0.5) ** 2) * 2) ** 0.5) - (starting_px / WORLD_ICON_SIZE) * d_diagonal_distance
					d_north_dir = WEST
					d_south_dir = SOUTH
					d_native_dir = WEST
				if(135)
					is_diagonal_case = round(starting_px, 1) == (WORLD_ICON_SIZE - round(starting_py, 1) + 1)
					d_sdx = 1
					d_sdy = -1
					d_dist_to_next = ((((WORLD_ICON_SIZE + 0.5) ** 2) * 2) ** 0.5) - (starting_px / WORLD_ICON_SIZE) * d_diagonal_distance
					d_north_dir = NORTH
					d_south_dir = WEST
					d_native_dir = WEST
				if(225)
					is_diagonal_case = round(starting_px, 1) == round(starting_py, 1)
					d_sdx = -1
					d_sdy = -1
					d_dist_to_next = ((starting_px - 0.5) / WORLD_ICON_SIZE) * d_diagonal_distance
					d_north_dir = NORTH
					d_south_dir = EAST
					d_native_dir = EAST
				if(315)
					is_diagonal_case = round(starting_px, 1) == (WORLD_ICON_SIZE - round(starting_py, 1) + 1)
					d_sdx = -1
					d_sdy = 1
					d_dist_to_next = ((starting_px - 0.5) / WORLD_ICON_SIZE) * d_diagonal_distance
					d_north_dir = EAST
					d_south_dir = SOUTH
					d_native_dir = EAST
			// only do special diag stuff if it's a close enough to a perfect diagonal
			if(is_diagonal_case)
				remaining_distance -= d_dist_to_next
				var/use_ss13_default_priority = isnull(diagonal_expand_north) && isnull(diagonal_expand_south)
				while(remaining_distance >= 0)
					d_moving_into = locate(d_moving_into.x + d_sdx, d_moving_into.y + d_sdy, d_moving_into.z)
					if(!d_moving_into)
						break
					. += d_moving_into
					if(use_ss13_default_priority)
						. += get_step(d_moving_into, d_native_dir)
					else
						if(diagonal_expand_north)
							// we actually want to get the one behind them; we don't need to null check either because of that
							. += get_step(d_moving_into, d_north_dir)
						if(diagonal_expand_south)
							// we actually want to get the one behind them; we don't need to null check either because of that
							. += get_step(d_moving_into, d_south_dir)
					remaining_distance -= WORLD_ICON_SIZE
				return

	// dx, dy for every distance pixel
	var/ddx = sin(angle)
	var/ddy = cos(angle)

	// sign of dx, dy as 1 or -1
	var/sdx = ddx > 0? 1 : -1
	var/sdy = ddy > 0? 1 : -1

	var/cx = starting_px
	var/cy = starting_py

	var/turf/moving_into = starting
	while(safety-- > 0 && remaining_distance > 0)
		var/d_next_horizontal = \
			(sdx? ((sdx > 0? (WORLD_ICON_SIZE + 0.5) - cx : -cx + 0.5) / ddx) : INFINITY)
		var/d_next_vertical = \
			(sdy? ((sdy > 0? (WORLD_ICON_SIZE + 0.5) - cy : -cy + 0.5) / ddy) : INFINITY)
		var/consumed = 0

		if(d_next_horizontal == d_next_vertical)
			// we're diagonal
			if(d_next_horizontal <= remaining_distance)
				moving_into = locate(moving_into.x + sdx, moving_into.y + sdy, moving_into.z)
				consumed = d_next_horizontal
				if(!moving_into)
					break
				cx = sdx > 0? 0.5 : (WORLD_ICON_SIZE + 0.5)
				cy = sdy > 0? 0.5 : (WORLD_ICON_SIZE + 0.5)
			else
				break
		else if(d_next_horizontal < d_next_vertical)
			// closer is to move left/right
			if(d_next_horizontal <= remaining_distance)
				moving_into = locate(moving_into.x + sdx, moving_into.y, moving_into.z)
				consumed = d_next_horizontal
				if(!moving_into)
					break
				cx = sdx > 0? 0.5 : (WORLD_ICON_SIZE + 0.5)
				cy = cy + d_next_horizontal * ddy
		else if(d_next_vertical < d_next_horizontal)
			// closer is to move up/down
			if(d_next_vertical <= remaining_distance)
				moving_into = locate(moving_into.x, moving_into.y + sdy, moving_into.z)
				consumed = d_next_vertical
				if(!moving_into)
					break
				cx = cx + d_next_vertical * ddx
				cy = sdy > 0? 0.5 : (WORLD_ICON_SIZE + 0.5)
			else
				break

		remaining_distance -= consumed

		// if we need to move
		if(moving_into)
			. += moving_into
