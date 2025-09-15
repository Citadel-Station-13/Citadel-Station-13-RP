//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Physics - Configuration *//

/**
 * sets our angle
 */
/obj/projectile/proc/set_angle(new_angle)
	angle = new_angle

	// update sprite
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(angle)
		transform = M

	// update trajectory
	calculated_dx = sin(new_angle)
	calculated_dy = cos(new_angle)
	calculated_sdx = calculated_dx == 0? 0 : (calculated_dx > 0? 1 : -1)
	calculated_sdy = calculated_dy == 0? 0 : (calculated_dy > 0? 1 : -1)

	var/normalized_to_first_quadrant = MODULUS_F(new_angle, 90)
	angle_chebyshev_divisor = cos(normalized_to_first_quadrant >= 45? (90 - normalized_to_first_quadrant) : normalized_to_first_quadrant)

	// record our tracer's change
	if(hitscanning)
		record_hitscan_deflection()

/**
 * sets our speed in pixels per decisecond
 */
/obj/projectile/proc/set_speed(new_speed)
	speed = clamp(new_speed, 1, WORLD_ICON_SIZE * 100)

/**
 * sets our angle and speed
 */
/obj/projectile/proc/set_velocity(new_angle, new_speed)
	// this is so this can be micro-optimized later but for once i'm not going to do it early for no reason
	set_speed(new_speed)
	set_angle(new_angle)

/**
 * todo: this is somewhat mildly terrible
 */
/obj/projectile/proc/set_homing_target(atom/A)
	if(!A || (!isturf(A) && !isturf(A.loc)))
		return FALSE
	homing = TRUE
	homing_target = A
	homing_offset_x = rand(homing_inaccuracy_min, homing_inaccuracy_max)
	homing_offset_y = rand(homing_inaccuracy_min, homing_inaccuracy_max)
	if(prob(50))
		homing_offset_x = -homing_offset_x
	if(prob(50))
		homing_offset_y = -homing_offset_y

/**
 * initializes physics vars
 */
/obj/projectile/proc/setup_physics()
	distance_travelled = 0

/**
 * called after an unhandled forcemove is detected, or other event
 * that should reset our on-turf state
 */
/obj/projectile/proc/reset_physics_to_turf()
	// we use this because we can center larger than 32x32 projectiles
	// without disrupting physics this way
	//
	// we add by (WORLD_ICON_SIZE / 2) because
	// pixel_x / pixel_y starts at center,
	//
	current_px = pixel_x - base_pixel_x + (WORLD_ICON_SIZE / 2)
	current_py = pixel_y - base_pixel_y + (WORLD_ICON_SIZE / 2)
	// interrupt active move logic
	trajectory_moving_to = null

//* Physics - Processing *//

/obj/projectile/process(delta_time)
	if(paused)
		return
	physics_iteration(min(10 * WORLD_ICON_SIZE, delta_time * speed * SSprojectiles.global_projectile_speed_multiplier), delta_time)

/**
 * immediately processes hitscan
 */
/obj/projectile/proc/physics_hitscan(safety = 250, resuming)
	SHOULD_NOT_SLEEP(TRUE)
	// setup
	if(!resuming)
		hitscanning = TRUE
		record_hitscan_start(muzzle_marker = TRUE, kick_forwards = 16)

	// just move as many times as we can
	while(!QDELETED(src) && loc)
		// check safety
		safety--
		if(safety <= 0)
			// if you're here, you shouldn't be. do not bump safety up, fix whatever
			// you're doing because no one should be making projectiles go more than 250
			// tiles in a single life.
			stack_trace("projectile hit iteration limit for hitscan")
			break

		// move forwards by 1 tile length
		var/pixels_moved = physics_step(WORLD_ICON_SIZE)
		distance_travelled += pixels_moved
		// if we're being yanked, yield
		if(movable_flags & MOVABLE_IN_MOVED_YANK)
			spawn(0)
				physics_hitscan(safety, TRUE)
			return

		// see if we're done
		if(distance_travelled >= range)
			legacy_on_range()
			break

	hitscanning = FALSE

/**
 * ticks forwards a number of pixels
 *
 * todo: potential lazy animate support for performance, as we honestly don't need to animate at full fps if the server's above 20fps
 *
 * * delta_tiem is in deciseconds, not seconds.
 */
/obj/projectile/proc/physics_iteration(pixels, delta_time, additional_animation_length)
	// setup iteration
	var/safety = 15
	var/pixels_remaining = pixels
	distance_travelled_this_iteration = 0

	// apply penalty
	var/penalizing = clamp(trajectory_penalty_applied, 0, pixels_remaining)
	pixels_remaining -= penalizing
	trajectory_penalty_applied -= penalizing

	// clamp to max distance
	pixels_remaining = min(pixels_remaining, range - distance_travelled)

	// move as many times as we need to
	//
	// * break if we're loc = null (by deletion or otherwise)
	// * break if we get paused
	while(pixels_remaining > 0)
		// check safety
		safety--
		if(safety <= 0)
			CRASH("ran out of safety! what happened?")

		// move
		var/pixels_moved = physics_step(pixels_remaining)
		distance_travelled += pixels_moved
		distance_travelled_this_iteration += pixels_moved
		pixels_remaining -= pixels_moved
		// we're being yanked, yield
		if(movable_flags & MOVABLE_IN_MOVED_YANK)
			spawn(0)
				physics_iteration(pixels_remaining, delta_time, distance_travelled_this_iteration)
			return
		// this is also a catch-all for deletion
		if(!loc || paused)
			break

	// penalize next one if we were kicked forwards forcefully too far
	trajectory_penalty_applied = max(0, -pixels_remaining)

	// if we don't have a loc anymore just bail
	if(!loc)
		return

	// if we're at max range
	if(distance_travelled >= range)
		// todo: egh
		legacy_on_range()
		if(QDELETED(src))
			return

	// process homing
	physics_tick_homing(delta_time)

	// perform animations
	// we assume at this point any deflections that should have happened, has happened,
	// so we just do a naive animate based on our current loc and pixel x/y
	//
	// todo: animation needs to take into account angle changes,
	//       but that's expensive as shit so uh lol
	//
	// the reason we use distance_travelled_this_iteration is so if something disappears
	// by forceMove or whatnot,
	// we won't have it bounce from its previous location to the new one as it's not going
	// to be accurate anymore
	//
	// so instead, as of right now, we backtrack via how much we know we moved.
	var/final_px = base_pixel_x + current_px - (WORLD_ICON_SIZE / 2)
	var/final_py = base_pixel_y + current_py - (WORLD_ICON_SIZE / 2)
	var/anim_dist = distance_travelled_this_iteration + additional_animation_length
	pixel_x = final_px - (anim_dist * sin(angle))
	pixel_y = final_py - (anim_dist * cos(angle))

	animate(
		src,
		delta_time,
		flags = ANIMATION_END_NOW,
		pixel_x = final_px,
		pixel_y = final_py,
	)

/**
 * based on but exactly http://www.cs.yorku.ca/~amana/research/grid.pdf
 *
 * move into the next tile, or the specified number of pixels,
 * whichever is less pixels moved
 *
 * this will modify our current_px/current_py as necessary
 *
 * @return pixels moved
 */
/obj/projectile/proc/physics_step(limit)
	// distance to move in our angle to get to next turf for horizontal and vertical
	var/d_next_horizontal = \
		(calculated_sdx? ((calculated_sdx > 0? (WORLD_ICON_SIZE + 0.5) - current_px : -current_px + 0.5) / calculated_dx) : INFINITY)
	var/d_next_vertical = \
		(calculated_sdy? ((calculated_sdy > 0? (WORLD_ICON_SIZE + 0.5) - current_py : -current_py + 0.5) / calculated_dy) : INFINITY)
	var/turf/move_to_target

	/**
	 * explanation on why current and next are done:
	 *
	 * projectiles track their pixel x/y on turf, not absolute pixel x/y from edge of map
	 * this is done to make it simpler to reason about, but is not necessarily the most simple
	 * or efficient way to do things.
	 *
	 * part of the problems with this approach is that Move() is not infallible. the projectile can be blocked.
	 * if we immediately set current pixel x/y, if the projectile is intercepted by a Bump, we now dont' know the 'real'
	 * position of the projectile because it's out of sync with where it should be
	 *
	 * now, things that require math operations on it don't know the actual location of the projectile until this proc
	 * rolls it back
	 *
	 * so instead, we never touch current px/py until the move is known to be successful, then we set it
	 * to the stored next px/py
	 *
	 * this way, things accessing can mutate our state freely without worrying about needing to handle rollbacks
	 *
	 * this entire system however adds overhead
	 * if we want to not have overhead, we'll need to rewrite hit processing and have it so moves are fully illegal to fail
	 * but doing that is literally not possible because anything can reject a move for any reason whatsoever
	 * and we cannot control that, so, instead, we make projectiles track in absolute pixel x/y coordinates from edge of map
	 *
	 * that way, we don't even need to care about where the .loc is, we just know where the projectile is supposed to be by
	 * knowing where it isn't, and by taking the change in its pixels the projectile controller can tell the projectile
	 * where to go-
	 *
	 * (all shitposting aside, this is for future work; it works right now and we have an API to do set angle, kick forwards, etc)
	 * (so i'm not going to touch this more because it's 4 AM and honestly this entire raycaster is already far less overhead)
	 * (than the old system of a 16-loop of brute forced 2 pixel increments)
	 */

	if(d_next_horizontal == d_next_vertical)
		// we're diagonal
		if(d_next_horizontal <= limit)
			move_to_target = locate(x + calculated_sdx, y + calculated_sdy, z)
			. = d_next_horizontal
			if(!move_to_target)
				// we hit the world edge and weren't transit; time to get deleted.
				if(hitscanning)
					finalize_hitscan_tracers(impact_effect = FALSE)
				qdel(src)
				return
			next_px = calculated_sdx > 0? 0.5 : (WORLD_ICON_SIZE + 0.5)
			next_py = calculated_sdy > 0? 0.5 : (WORLD_ICON_SIZE + 0.5)
	else if(d_next_horizontal < d_next_vertical)
		// closer is to move left/right
		if(d_next_horizontal <= limit)
			move_to_target = locate(x + calculated_sdx, y, z)
			. = d_next_horizontal
			if(!move_to_target)
				// we hit the world edge and weren't transit; time to get deleted.
				if(hitscanning)
					finalize_hitscan_tracers(impact_effect = FALSE)
				qdel(src)
				return
			next_px = calculated_sdx > 0? 0.5 : (WORLD_ICON_SIZE + 0.5)
			next_py = current_py + d_next_horizontal * calculated_dy
	else if(d_next_vertical < d_next_horizontal)
		// closer is to move up/down
		if(d_next_vertical <= limit)
			move_to_target = locate(x, y + calculated_sdy, z)
			. = d_next_vertical
			if(!move_to_target)
				// we hit the world edge and weren't transit; time to get deleted.
				if(hitscanning)
					finalize_hitscan_tracers(impact_effect = FALSE)
				qdel(src)
				return
			next_px = current_px + d_next_vertical * calculated_dx
			next_py = calculated_sdy > 0? 0.5 : (WORLD_ICON_SIZE + 0.5)

	// if we need to move
	if(move_to_target)
		var/atom/old_loc = loc
		trajectory_moving_to = move_to_target
		// mark next distance so impact processing can work
		next_distance = distance_travelled + .
		if(!Move(move_to_target) && ((loc != move_to_target) || !trajectory_moving_to))
			// if we don't successfully move, don't change anything, we didn't move.
			. = 0
			if(loc == old_loc)
				stack_trace("projectile failed to move, but is still on turf instead of deleted or relocated.")
				qdel(src) // bye
		else
			// only do these if we successfully move, or somehow end up in that turf anyways
			if(trajectory_kick_forwards)
				. += trajectory_kick_forwards
				trajectory_kick_forwards = 0
			current_px = next_px
			current_py = next_py
			#ifdef CF_PROJECTILE_RAYCAST_VISUALS
			new /atom/movable/render/projectile_raycast(move_to_target, current_px, current_py, "#77ff77")
			#endif
		trajectory_moving_to = null
	else
		// not moving to another tile, so, just move on current tile
		if(trajectory_kick_forwards)
			trajectory_kick_forwards = 0
			stack_trace("how did something kick us forwards when we didn't even move?")
		. = limit
		current_px += limit * calculated_dx
		current_py += limit * calculated_dy
		next_px = current_px
		next_py = current_py
		#ifdef CF_PROJECTILE_RAYCAST_VISUALS
		new /atom/movable/render/projectile_raycast(loc, current_px, current_py, "#ff3333")
		#endif

#ifdef CF_PROJECTILE_RAYCAST_VISUALS
GLOBAL_VAR_INIT(projectile_raycast_debug_visual_delay, 2 SECONDS)

/atom/movable/render/projectile_raycast
	plane = OBJ_PLANE
	icon = 'icons/system/color_32x32.dmi'
	icon_state = "white-pixel"

/**
 * px, py are absolute pixel coordinates on the tile, not pixel_x / pixel_y of this renderer!
 */
/atom/movable/render/projectile_raycast/Initialize(mapload, px, py, color)
	src.pixel_x = px - 1
	src.pixel_y = py - 1
	src.color = color
	. = ..()
	QDEL_IN(src, GLOB.projectile_raycast_debug_visual_delay)
#endif

/**
 * immediately, without processing, kicks us forward a number of pixels
 *
 * since we immediately cross over into a turf when entering,
 * things like mirrors/reflectors will immediately set angle
 *
 * it looks ugly and is pretty bad to just reflect off the edge of a turf so said things can
 * call this proc to kick us forwards by a bit
 */
/obj/projectile/proc/physics_kick_forwards(pixels)
	trajectory_kick_forwards += pixels
	next_px += pixels * calculated_dx
	next_py += pixels * calculated_dy

/**
 * only works during non-hitscan
 *
 * this is called once per tick
 * homing is smoother the higher fps the server / SSprojectiles runs at
 *
 * todo: this is somewhat mildly terrible
 * todo: this has absolutely no arc/animation support; this is bad
 */
/obj/projectile/proc/physics_tick_homing(delta_time)
	if(!homing)
		return FALSE
	// checks if they're 1. on a turf, 2. on our z
	// todo: should we add support for tracking something even if it leaves a turf?
	if(homing_target?.z != z)
		// bye bye!
		return FALSE
	// todo: this assumes single-tile objects. at some point, we should upgrade this to be unnecessarily expensive and always center-mass.
	var/dx = (homing_target.x - src.x) * WORLD_ICON_SIZE + (0 - current_px) + homing_offset_x
	var/dy = (homing_target.y - src.y) * WORLD_ICON_SIZE + (0 - current_py) + homing_offset_y
	// say it with me, arctan()
	// is CCW of east if (dx, dy)
	// and CW of north if (dy, dx)
	// where dx and dy is distance in x/y pixels from us to them.

	var/nudge_towards = closer_angle_difference(arctan(dy, dx))
	var/max_turn_speed = homing_turn_speed * delta_time

	set_angle(angle + clamp(nudge_towards, -max_turn_speed, max_turn_speed))

//* Physics - Querying *//

/**
 * predict what turf we'll be in after going forwards a certain amount of pixels
 *
 * doesn't actually sim; so this will go through walls/obstacles!
 *
 * * if we go out of bounds, we will return null; this doesn't level-wrap
 */
/obj/projectile/proc/physics_predicted_turf_after_iteration(pixels)
	// -1 at the end if 0, because:
	//
	// -32 is go back 1 tile and be at the 1st pixel (as 0 is going back)
	// 0 is go back 1 tile and be at the 32nd pixel.
	var/incremented_px = (current_px + pixels * calculated_dx) || - 1
	var/incremented_py = (current_py + pixels * calculated_dy) || - 1

	var/incremented_tx = floor(incremented_px / 32)
	var/incremented_ty = floor(incremented_py / 32)

	return locate(x + incremented_tx, y + incremented_ty, z)

/**
 * predict what turfs we'll hit, excluding the current turf, after going forwards
 * a certain amount of pixels
 *
 * doesn't actually sim; so this will go through walls/obstacles!
 */
/obj/projectile/proc/physics_predicted_turfs_during_iteration(pixels)
	return pixel_physics_raycast(loc, current_px, current_py, angle, pixels)
