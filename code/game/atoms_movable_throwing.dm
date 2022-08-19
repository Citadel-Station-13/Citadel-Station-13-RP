//! Welcome to unoptimized hell. Enjoy your comsigs.

/**
 * throw_impacted()
 *
 * @return see [code/__DEFINES/dcs/signals/signals_atom/signals_atom_throwing.dm]; This returns COMPONENT_THROW_HIT flags!
 *
 * called when we're hit by something
 * @params
 * - AM - thrown atom that hit us
 * - TT - thrownthing datum.
 */
/atom/proc/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	return NONE

/**
 * throw_impact()
 *
 * @return see [code/__DEFINES/dcs/signals/signals_atom/signals_atom_throwing.dm]; This returns COMPONENT_THROW_HIT flags!
 *
 * called when we hit something
 * @params
 * - A - atom we hit
 * - TT - thrownthing datum
 */
/atom/movable/proc/throw_impact(atom/A, datum/thrownthing/TT)
	return NONE

/**
 * throw_landed()
 *
 * called when something lands on us
 * @params
 * - AM - atom that landed on us
 * - TT - thrownthing datum
 */
/atom/proc/throw_landed(atom/movable/AM, datum/thrownthing/TT)
	return NONE

/**
 * throw_land()
 *
 * called when we land on something
 * @params
 * - A - atom that we landed on
 * - TT - thrownthing datum
 */
/atom/proc/throw_land(atom/A, datum/thrownthing/TT)
	return NONE

/**
 * called when we are impacting something
 *
 * returns FALSE to signify not ending the throw.
 */
/atom/movable/proc/_throw_do_hit(atom/A, datum/thrownthing/TT)
	SHOULD_NOT_OVERRIDE(TRUE)
	set waitfor = FALSE

	. = SEND_SIGNAL(src, COMSIG_MOVABLE_THROW_IMPACT, A, TT)
	if(. & (COMPONENT_THROW_HIT_TERMINATE | COMPONENT_THROW_HIT_NEVERMIND))
		return
	. |= throw_impact(A, TT)
	if(. & (COMPONENT_THROW_HIT_TERMINATE | COMPONENT_THROW_HIT_NEVERMIND))
		return
	. |= SEND_SIGNAL(src, COMSIG_ATOM_THROW_IMPACTED, AM, TT)
	if(. & (COMPONENT_THROW_HIT_TERMINATE | COMPONENT_THROW_HIT_NEVERMIND))
		return
	. |= A.throw_impacted(src, TT)

/**
 * called on throw finalization
 */
/atom/movable/proc/_throw_finalize(atom/landed_on, datum/thrownthing/TT)
	if(!landed_on)		// if we somehow got nullspaced
		return

	. = SEND_SIGNAL(src, COMSIG_MOVABLE_THROW_LAND, landed_on, TT)
	if(. & (COMPONENT_THROW_LANDING_NEVERMIND | COMPONENT_THROW_LANDING_TERMINATE))
		return
	. |= throw_land(landed_on, TT)
	if(. & (COMPONENT_THROW_LANDING_NEVERMIND | COMPONENT_THROW_LANDING_TERMINATE))
		return
	. |= SEND_SIGNAL(src, COMSIG_MOVABLE_THROW_LANDED, landed_on, TT)
	if(. & (COMPONENT_THROW_LANDING_NEVERMIND | COMPONENT_THROW_LANDING_TERMINATE))
		return
	. |= landed_on.throw_landed(src, TT)

#warn impl - speed? how to implement that for damage balancing?
#warn impl - hitpush

/// Decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(speed)
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src)
				continue
			if(istype(A,/mob/living))
				if(A:lying)
					continue
				src.throw_impact(A,speed)
			if(isobj(A))
				if(!A.density || A.throwpass)
					continue
				// Special handling of windows, which are dense but block only from some directions
				if(istype(A, /obj/structure/window))
					var/obj/structure/window/W = A
					if (!W.is_fulltile() && !(turn(src.last_move_dir, 180) & A.dir))
						continue
				// Same thing for (closed) windoors, which have the same problem
				else if(istype(A, /obj/machinery/door/window) && !(turn(src.last_move_dir, 180) & A.dir))
					continue
				src.throw_impact(A,speed)

/**
 * initiates a full subsystem-ticked throw sequence
 * components can cancel this.
 *
 * @return a datum on success, null on failure.
 */
/atom/movable/proc/subsystem_throw(atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/datum/thrownthing)
	#warn uh oh

/**
 * emulates an immediate throw impact
 * must quickstart() either automatically or manually for this to work!
 * components can cancel this.
 *
 * @return a datum on success, null on failure.
 */
/atom/movable/proc/emulated_throw(atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/datum/thrownthing)
	#warn impl


/// If this returns FALSE then callback will not be called.
/atom/movable/proc/throw_at_old(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback)
	. = TRUE
	if(!target || speed <= 0 || QDELETED(src) || (target.z != src.z))
		return FALSE

	if(pulledby)
		pulledby.stop_pulling()

	var/datum/thrownthing/TT = new(src, target, range, speed, thrower, callback)
	throwing = TT

	pixel_z = 0
	if(spin && does_spin)
		SpinAnimation(4,1)

	SSthrowing.processing[src] = TT
	if(SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[src] = TT

#warn old above, new below, figure it out

/atom/movable/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked, datum/thrownthing/throwingdatum)
	if(!anchored && hitpush && (!throwingdatum || (throwingdatum.force >= (move_resist * MOVE_FORCE_PUSH_RATIO))))
		step(src, AM.dir)
	..()

/*
/atom/movable/proc/safe_throw_at(, mob/thrower, , datum/callback/callback, force = MOVE_FORCE_STRONG)
	if((force < (move_resist * MOVE_FORCE_THROW_RATIO)) || (move_resist == INFINITY))
		return
	return throw_at_old(target, range, speed, thrower, spin, diagonals_first, callback, force, gentle)
*/

///If this returns FALSE then callback will not be called.
/atom/movable/proc/throw_at_old(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE, quickstart = TRUE)
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
	if (thrower && thrower.last_move_dir && thrower.client && thrower.client.move_delay >= world.time + world.tick_lag*2)
		var/user_momentum = thrower.movement_delay() //cached_multiplicative_slowdown
		if (!user_momentum) //no movement_delay, this means they move once per byond tick, lets calculate from that instead.
			user_momentum = world.tick_lag

		user_momentum = 1 / user_momentum // convert from ds to the tiles per ds that throw_at_old uses.

		if (get_dir(thrower, target) & last_move_dir)
			user_momentum = user_momentum //basically a noop, but needed
		else if (get_dir(target, thrower) & last_move_dir)
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

	var/datum/thrownthing/TT = new(src, target, get_turf(target), get_dir(src, target), range, speed, thrower, diagonals_first, force, gentle, callback, target_zone)

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)
	var/dx = (target.x > src.x) ? EAST : WEST
	var/dy = (target.y > src.y) ? NORTH : SOUTH

	if (dist_x == dist_y)
		TT.pure_diagonal = 1

	else if(dist_x <= dist_y)
		var/olddist_x = dist_x
		var/olddx = dx
		dist_x = dist_y
		dist_y = olddist_x
		dx = dy
		dy = olddx
	TT.dist_x = dist_x
	TT.dist_y = dist_y
	TT.dx = dx
	TT.dy = dy
	TT.diagonal_error = dist_x/2 - dist_y
	TT.start_time = world.time

	if(pulledby)
		pulledby.stop_pulling()

	throwing = TT
	if(spin)
		SpinAnimation(5, 1)

	SEND_SIGNAL(src, COMSIG_MOVABLE_POST_THROW, TT, spin)
	SSthrowing.processing[src] = TT
	if (SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[src] = TT
	if (quickstart)
		TT.tick()
