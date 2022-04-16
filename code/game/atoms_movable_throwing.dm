/atom/movable/proc/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	set waitfor = FALSE
	var/hitpush = TRUE
	var/impact_signal = SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
	if(impact_signal & COMPONENT_MOVABLE_IMPACT_FLIP_HITPUSH)
		hitpush = FALSE // hacky, tie this to something else or a proper workaround later

	if(!(impact_signal && (impact_signal & COMPONENT_MOVABLE_IMPACT_NEVERMIND))) // in case a signal interceptor broke or deleted the thing before we could process our hit
		return hit_atom.hitby(src, throwingdatum=throwingdatum, hitpush=hitpush)

/atom/movable/hitby(atom/movable/hitting_atom, skipcatch, hitpush = TRUE, blocked, datum/thrownthing/throwingdatum)
	if(!anchored && hitpush && (!throwingdatum || (throwingdatum.force >= (move_resist * MOVE_FORCE_PUSH_RATIO))))
		step(src, hitting_atom.dir)
	..()

/atom/movable/proc/safe_throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE)
	if((force < (move_resist * MOVE_FORCE_THROW_RATIO)) || (move_resist == INFINITY))
		return
	return throw_at(target, range, speed, thrower, spin, diagonals_first, callback, force, gentle)

///If this returns FALSE then callback will not be called.
/atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE, quickstart = TRUE)
	. = FALSE

	if(QDELETED(src))
		CRASH("Qdeleted thing being thrown around.")

	if (!target || speed <= 0)
		return

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_THROW, args) & COMPONENT_CANCEL_THROW)
		return

	if (pulledby)
		pulledby.stop_pulling()

	//They are moving! Wouldn't it be cool if we calculated their momentum and added it to the throw?
	if (thrower && thrower.last_move && thrower.client && thrower.client.move_delay >= world.time + world.tick_lag*2)
		var/user_momentum = thrower.cached_multiplicative_slowdown
		if (!user_momentum) //no movement_delay, this means they move once per byond tick, lets calculate from that instead.
			user_momentum = world.tick_lag

		user_momentum = 1 / user_momentum // convert from ds to the tiles per ds that throw_at uses.

		if (get_dir(thrower, target) & last_move)
			user_momentum = user_momentum //basically a noop, but needed
		else if (get_dir(target, thrower) & last_move)
			user_momentum = -user_momentum //we are moving away from the target, lets slowdown the throw accordingly
		else
			user_momentum = 0


		if (user_momentum)
			//first lets add that momentum to range.
			range *= (user_momentum / speed) + 1
			//then lets add it to speed
			speed += user_momentum
			if (speed <= 0)
				return//no throw speed, the user was moving too fast.

	. = TRUE // No failure conditions past this point.

	var/target_zone
	if(QDELETED(thrower))
		thrower = null //Let's not pass a qdeleting reference if any.
	else
		target_zone = thrower.zone_selected

	var/datum/thrownthing/thrown_thing = new(src, target, get_dir(src, target), range, speed, thrower, diagonals_first, force, gentle, callback, target_zone)

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)
	var/dx = (target.x > src.x) ? EAST : WEST
	var/dy = (target.y > src.y) ? NORTH : SOUTH

	if (dist_x == dist_y)
		thrown_thing.pure_diagonal = 1

	else if(dist_x <= dist_y)
		var/olddist_x = dist_x
		var/olddx = dx
		dist_x = dist_y
		dist_y = olddist_x
		dx = dy
		dy = olddx
	thrown_thing.dist_x = dist_x
	thrown_thing.dist_y = dist_y
	thrown_thing.dx = dx
	thrown_thing.dy = dy
	thrown_thing.diagonal_error = dist_x/2 - dist_y
	thrown_thing.start_time = world.time

	if(pulledby)
		pulledby.stop_pulling()
	if (quickstart && (throwing || SSthrowing.state == SS_RUNNING)) //Avoid stack overflow edgecases.
		quickstart = FALSE
	throwing = thrown_thing
	if(spin)
		SpinAnimation(5, 1)

	SEND_SIGNAL(src, COMSIG_MOVABLE_POST_THROW, thrown_thing, spin)
	SSthrowing.processing[src] = thrown_thing
	if (SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[src] = thrown_thing
	if (quickstart)
		thrown_thing.tick()

#warn parse below
#warn mob throwing stuff
/*

//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		if(M.buckled == src)
			return // Don't hit the thing we're buckled to.
		M.hitby(src,speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.last_move)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		src.throwing = 0
		var/turf/T = hit_atom
		T.hitby(src,speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(var/speed)
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src) continue
			if(istype(A,/mob/living))
				if(A:lying) continue
				src.throw_impact(A,speed)
			if(isobj(A))
				if(!A.density || A.throwpass)
					continue
				// Special handling of windows, which are dense but block only from some directions
				if(istype(A, /obj/structure/window))
					var/obj/structure/window/W = A
					if (!W.is_fulltile() && !(turn(src.last_move, 180) & A.dir))
						continue
				// Same thing for (closed) windoors, which have the same problem
				else if(istype(A, /obj/machinery/door/window) && !(turn(src.last_move, 180) & A.dir))
					continue
				src.throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range, speed, thrower)
	if(!target || !src)
		return 0
	if(target.z != src.z)
		return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target
	src.throwing = 1
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf
	src.pixel_z = 0
	if(usr)
		if(HULK in usr.mutations)
			src.throwing = 2 // really strong throw!

	var/dist_travelled = 0
	var/dist_since_sleep = 0
	var/area/a = get_area(src.loc)

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH

	var/error
	var/major_dir
	var/major_dist
	var/minor_dir
	var/minor_dist
	if(dist_x > dist_y)
		error = dist_x/2 - dist_y
		major_dir = dx
		major_dist = dist_x
		minor_dir = dy
		minor_dist = dist_y
	else
		error = dist_y/2 - dist_x
		major_dir = dy
		major_dist = dist_y
		minor_dir = dx
		minor_dist = dist_x

	while(src && target && src.throwing && istype(src.loc, /turf) \
		  && ((abs(target.x - src.x)+abs(target.y - src.y) > 0 && dist_travelled < range) \
		  	   || (a && a.has_gravity == 0) \
			   || istype(src.loc, /turf/space)))
		// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
		var/atom/step
		if(error >= 0)
			step = get_step(src, major_dir)
			error -= minor_dist
		else
			step = get_step(src, minor_dir)
			error += major_dist
		if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			break
		src.Move(step)
		hit_check(speed)
		dist_travelled++
		dist_since_sleep++
		if(dist_since_sleep >= speed)
			dist_since_sleep = 0
			sleep(1)
		a = get_area(src.loc)
		// and yet it moves
		if(src.does_spin)
			src.SpinAnimation(speed = 4, loops = 1)

	//done throwing, either because it hit something or it finished moving
	if(isobj(src)) src.throw_impact(get_turf(src),speed)
	src.throwing = 0
	src.thrower = null
	src.throw_source = null
	fall()
*/
