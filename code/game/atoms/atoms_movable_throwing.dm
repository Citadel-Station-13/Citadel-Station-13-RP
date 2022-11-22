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

/atom/movable/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	if(!anchored && (TT?.force >= (move_resist * MOVE_FORCE_PUSH_RATIO)) && !(TT.throw_flags & THROW_AT_OVERHAND))
		step(src, AM.dir)
	return ..()

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
 * usually defined on turfs but this might change in the future
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
 * usually called with turfs but this might change in the future
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

	// their opinion is checked first
	. |= SEND_SIGNAL(A, COMSIG_ATOM_THROW_IMPACTED, src, TT)
	if(. & (COMPONENT_THROW_HIT_TERMINATE | COMPONENT_THROW_HIT_NEVERMIND))
		return
	. |= A.throw_impacted(src, TT)
	if(. & (COMPONENT_THROW_HIT_TERMINATE | COMPONENT_THROW_HIT_NEVERMIND))
		return
	// then ours
	. = SEND_SIGNAL(src, COMSIG_MOVABLE_THROW_IMPACT, A, TT)
	if(. & (COMPONENT_THROW_HIT_TERMINATE | COMPONENT_THROW_HIT_NEVERMIND))
		return
	. |= throw_impact(A, TT)

/**
 * called on throw finalization
 */
/atom/movable/proc/_throw_finalize(atom/landed_on, datum/thrownthing/TT)
	SHOULD_NOT_OVERRIDE(TRUE)
	set waitfor = FALSE
	// their opinion is checked first
	. |= SEND_SIGNAL(landed_on, COMSIG_ATOM_THROW_LANDED, src, TT)
	if(. & (COMPONENT_THROW_LANDING_NEVERMIND | COMPONENT_THROW_LANDING_TERMINATE))
		return
	. |= landed_on.throw_landed(src, TT)
	if(. & (COMPONENT_THROW_LANDING_NEVERMIND | COMPONENT_THROW_LANDING_TERMINATE))
		return
	// then ours
	. = SEND_SIGNAL(src, COMSIG_MOVABLE_THROW_LAND, landed_on, TT)
	if(. & (COMPONENT_THROW_LANDING_NEVERMIND | COMPONENT_THROW_LANDING_TERMINATE))
		return
	. |= throw_land(landed_on, TT)

/**
 * initiates a full subsystem-ticked throw sequence
 * components can cancel this.
 *
 * range, speed defaults to sane defaults if not specified, usually calculated from throw force.
 *
 * @return a datum on success, null on failure.
 */
/atom/movable/proc/subsystem_throw(atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land, force = THROW_FORCE_DEFAULT)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/datum/thrownthing)

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_THROW, target, range, speed, flags, thrower, on_hit, on_land, FALSE) & COMPONENT_CANCEL_PRE_THROW)
		return FALSE

	var/datum/thrownthing/TT = _init_throw_datum(target, range, speed, flags, thrower, on_hit, on_land, force)
	if(!TT)
		return FALSE

	SEND_SIGNAL(src, COMSIG_MOVABLE_POST_THROW, target, range, speed, flags, thrower, on_hit, on_land, FALSE)

	pulling?.stop_pulling()
	stop_pulling()

	TT.start()

	if(!(flags & THROW_AT_DO_NOT_SPIN) && !(movable_flags & MOVABLE_NO_THROW_SPIN))
		SpinAnimation(5, 1)

	// virgocode shit here
	pixel_x = 0
	// end

	return TRUE

/**
 * emulates an immediate throw impact
 * must quickstart() either automatically or manually for this to work!
 * components can cancel this.
 *
 * @return a datum on success, null on failure.
 */
/atom/movable/proc/emulated_throw(atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land, force = THROW_FORCE_DEFAULT)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/datum/thrownthing)

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_THROW, target, range, speed, flags, thrower, on_hit, on_land, TRUE) & COMPONENT_CANCEL_PRE_THROW)
		return FALSE

	var/datum/thrownthing/TT = _init_throw_datum(target, range, speed, flags, thrower, on_hit, on_land, force)
	if(!TT)
		return FALSE

	SEND_SIGNAL(src, COMSIG_MOVABLE_POST_THROW, target, range, speed, flags, thrower, on_hit, on_land, TRUE)

	pulledby?.stop_pulling()
	stop_pulling()

	if(!(flags & THROW_AT_NO_AUTO_QUICKSTART))
		TT.quickstart()

	return TRUE

/atom/movable/proc/_init_throw_datum(atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land, force, emulated)
	if(throwing)
		CRASH("already throwing")
	var/calculated_speed = isnull(speed)? ((movable_flags & MOVABLE_NO_THROW_SPEED_SCALING)? (throw_speed) : (throw_speed * (force > throw_resist? (force / throw_resist) ** (throw_speed_scaling_exponential * 0.1) : 1 / (throw_resist / force) ** (throw_speed_scaling_exponential * 0.1)))) : speed
	if(!calculated_speed)
		CRASH("bad speed: [calculated_speed]")

	if(isnull(range))
		range = isnull(force)? (force / throw_resist) * throw_range : throw_range

	var/zone
	if(!(flags & THROW_AT_NO_USER_MODIFIERS) && !emulated && isliving(thrower))
		var/mob/living/L = thrower
		// user momentum
		var/user_speed = L.movement_delay()
		// 1 decisecond of margin
		if(L.last_move_dir && (L.last_move_time >= (world.time - user_speed + 1)))
			user_speed = max(user_speed, world.tick_lag)
			// convert to tiles per **decisecond**
			user_speed = 1/user_speed
			//? todo: better estimation?
			var/d = get_dir(src, target)
			if(L.last_move_dir & d)
			else if(L.last_move_dir & turn(d, 180))
				user_speed = -user_speed
			else
				user_speed = 0
			if(user_speed)
				range *= (user_speed / calculated_speed) + 1
				calculated_speed += user_speed
			if(calculated_speed <= 0)
				return
		// user zones
		if(L.zone_sel)	// incase simplemob
			zone = L.zone_sel.selecting

	var/datum/thrownthing/TT
	if(emulated)
		TT = new /datum/thrownthing/emulated(src, target, range, calculated_speed, flags, thrower, on_hit, on_land, force)
	else
		TT = new /datum/thrownthing(src, target, range, calculated_speed, flags, thrower, on_hit, on_land, force)
	. = throwing = TT

	if(zone)
		TT.target_zone = zone

	SEND_SIGNAL(src, COMSIG_MOVABLE_INIT_THROW, target, range, calculated_speed, flags, thrower, on_hit, on_land, emulated)

/**
 * throws us at something
 * we must be on a turf
 *
 * @params
 * - target - target atom
 * - range - how far to throw (not absolute)
 * - speed - throw speed overriding throw force
 * - flags - throw flags
 * - thrower - who threw us
 * - on_hit - callback to call on hit. doesn't go off if we don't hit.
 * - on_land - callback to call on land. doesn't go off if we don't land.
 * - force - throw movement force, scales speed to this if not overridden
 */
/atom/movable/proc/throw_at(atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land, force = THROW_FORCE_DEFAULT)
	if(!isturf(loc))
		return FALSE

	if(!(flags & THROW_AT_FORCE) && !can_throw_at(target, range, speed, flags, thrower, force))
		return FALSE

	if(QDELETED(src))
		. = FALSE
		CRASH("qdeleted thing being thrown around.")

	if(!target)
		return FALSE

	return subsystem_throw(target, range, speed, flags, thrower, on_hit, on_land, force)

/atom/movable/proc/can_throw_at(atom/target, range, speed, flags, atom/thrower, force = THROW_FORCE_DEFAULT)
	if(throw_resist >= MOVE_RESIST_ABSOLUTE)
		return FALSE
	var/effective_force = force
	if(flags & THROW_AT_OVERHAND)
		effective_force *= OVERHAND_THROW_FORCE_REDUCTION_FACTOR
	if(effective_force < throw_resist * MOVE_FORCE_THROW_RATIO)
		return FALSE
	return TRUE

// wrapper to be replaced
/atom/movable/proc/throw_at_old(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback)
	return throw_at(target, range, speed, flags, thrower, callback, null, null)

/atom/movable/proc/overhand_throw_delay(mob/user)
	return 1 SECONDS
