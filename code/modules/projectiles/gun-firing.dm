//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Firing Cycle *//

/**
 * async proc to start a firing cycle
 *
 * @return firing cycle ID
 */
/obj/item/gun/proc/start_firing_cycle(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	/**
	 * it's important we invoke async, **not** spawn(0)
	 *
	 * this is so debugging and other systems that care about call stack
	 * still attribute the call to the user until it sleeps for the first time
	 *
	 * just because we support async doesn't mean we actually want it
	 * to be async unless it needs to be; there's no reason to do so
	 * (and if something weird is going on we do want the initial proc to be attributed to the caller)
	 */
	#warn impl

/**
 * returns a given firing cycle ID; if none is provided, we interrupt any active firing cycle.
 */
/obj/item/gun/proc/interrupt_firing_cycle(cycle_id)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	firing_cycle = firing_cycle + 1

/**
 * Hook for firing cycle start
 */
/obj/item/gun/proc/on_firing_cycle_start(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Hook for firing cycle end
 */
/obj/item/gun/proc/on_firing_cycle_end(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor, iterations_fired, last_firing_result)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * called exactly once at the start of a firing cycle to start it
 *
 * @params
 * * cycle_id - the cycle id to use; this is provided by start_firing_cycle
 * * firer - the thing physically firing us; whether a turret or a person
 * * angle - the angle to fire in.
 * * firing_flags - GUN_FIRING_* flags
 * * firemode - the /datum/firemode we are firing on
 * * target - (optional) what we're firing at
 * * actor - (optional) the person who initiated the firing
 */
/obj/item/gun/proc/firing_cycle(cycle_id, atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE) // only base of /start_firing_cycle is allowed to call us

	/**
	 * As a word of warning, any proc called in this proc must be SHOULD_NOT_SLEEP.
	 * If this is ever violated bad things may happen and things may explode.
	 */

	firing_cycle = cycle_id

	var/interrupted = FALSE

	on_firing_cycle_start(firer, angle, firing_flags, firemode, target, actor)

	var/iterations
	var/iteration_delay

	#warn impl stuff

	for(var/iteration in 1 to iterations)
		var/result = fire(firer, angle, firing_flags, firemode, iteration, target, actor)
		if(!post_fire(firer, angle, firing_flags, firemode, iteration, result, target, actor))
			break
		if(iteration != iterations)
			sleep(iteration_delay)
			if(firing_cycle != cycle_id)
				interrupted = TRUE
				break

	on_firing_cycle_end(firer, angle, firing_flags, firemode, iteration, target, actor)

//* Firing *//

/**
 * called to perform a single firing operation
 *
 * @params
 * * firer - the thing physically firing us; whether a turret or a person
 * * angle - the angle to fire in.
 * * firing_flags - GUN_FIRING_* flags
 * * firemode - the /datum/firemode we are firing on
 * * iteration - burst iteration; for single-firing, this is always 1.
 * * target - (optional) what we're firing at
 * * actor - (optional) the person who initiated the firing
 */
/obj/item/gun/proc/fire(atom/firer, angle, firing_flags, datum/firemode/firemode, iteration, atom/target, datum/event_args/actor/actor)
	SHOULD_NOT_SLEEP(TRUE)
	#warn impl; check unmount

/**
 * Called to handle post fire
 *
 * @return FALSE to abort firing cycle
 */
/obj/item/gun/proc/post_fire(atom/firer, angle, firing_flags, datum/firemode/firemode, iteration, firing_result, atom/target, datum/event_args/actor/actor)
	SHOULD_NOT_SLEEP(TRUE)
	switch(firing_result)
		if(GUN_FIRED_SUCCESS)
			return TRUE
		if(GUN_FIRED_FAIL_EMPTY, GUN_FIRED_FAIL_INERT)
			post_empty_fire(firing_flags, actor, target)
		else
			return FALSE

//* Firing - Default Handlers (Overridable) *//

/**
 * Called if someone tries to fire us without live ammo in the chamber (or chamber-equivalent)
 *
 * @params
 * * firing_flags - our firing flags
 * * actor - (optional) the actor tuple describing who's firing us, if any.
 * * target - (optional) what we were being fired at
 */
/obj/item/gun/proc/post_empty_fire(firing_flags, datum/event_args/actor/actor, atom/target)
	if(!(firing_flags & GUN_FIRING_NO_CLICK_EMPTY))
		// default click empty
		default_click_empty()
	#warn impl

// todo: actor / event_args support
/obj/item/gun/proc/default_click_empty()
	var/mob/holding_us = worn_mob()
	if(holding_us)
		holding_us.visible_message(SPAN_WARNING("*click click*"), SPAN_WARNING("*click*"))
	else if(isturf(loc))
		visible_message(SPAN_WARNING("*click click*"), SPAN_WARNING("*click*"))
	playsound(src, 'sound/weapons/empty.ogg', 75, TRUE)
