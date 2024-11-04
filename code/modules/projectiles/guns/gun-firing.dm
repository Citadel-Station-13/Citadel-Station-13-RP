//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Firing Cycle *//

/**
 * async proc to start a firing cycle
 *
 * @return firing cycle datum
 */
/obj/item/gun/proc/async_firing_cycle(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor) as /datum/gun_firing_cycle
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	// invoke async; when it returns, our firing_cycle will still be set
	INVOKE_ASYNC(PROC_REF(firing_cycle), firer, angle, firing_flags, firemode, target, actor)
	// check to make sure it's always set
	ASSERT(firing_cycle)
	// return it; beware that it can be mutated in the firing cycle.
	return firing_cycle

/**
 * starts, and blocks on a firing cycle
 */
/obj/item/gun/proc/blocking_firing_cycle(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor) as /datum/gun_firing_cycle
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	return firing_cycle(firer, angle, firing_flags, firemode, target, actor)

/**
 * interrupts a given firing cycle ID; if none is provided, we interrupt any active firing cycle.
 */
/obj/item/gun/proc/interrupt_firing_cycle(cycle_id)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(cycle_id && firing_cycle?.notch != cycle_id)
		return
	firing_cycle = null

/**
 * Hook for firing cycle start
 */
/obj/item/gun/proc/on_firing_cycle_start(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Hook for firing cycle end
 */
/obj/item/gun/proc/on_firing_cycle_end(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * called exactly once at the start of a firing cycle to start it
 *
 * @params
 * * firer - the thing physically firing us; whether a turret or a person.
 *   this is where the projectile will originate, not the physical location of the gun.
 * * angle - the angle to fire in.
 * * firing_flags - GUN_FIRING_* flags
 * * firemode - (optional) the /datum/firemode we are firing on
 * * target - (optional) what we're firing at
 * * actor - (optional) the person who initiated the firing
 *
 * @return the gun firing cycle made and used
 */
/obj/item/gun/proc/firing_cycle(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor) as /datum/gun_firing_cycle
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE) // only base of /start_firing_cycle is allowed to call us

	/**
	 * As a word of warning, any proc called in this proc must be SHOULD_NOT_SLEEP.
	 * If this is ever violated bad things may happen and things may explode.
	 */

	// create cycle
	var/datum/gun_firing_cycle/our_cycle = new
	our_cycle.firing_flags = firing_flags
	our_cycle.original_angle = angle
	our_cycle.original_target = target
	our_cycle.firemode = firemode
	our_cycle.firing_actor = actor
	our_cycle.firing_atom = firer
	our_cycle.firing_iterations = firemode.burst_amount
	our_cycle.firing_delay = firemode.burst_delay
	// cycle notch
	our_cycle.cycle_notch = ++firing_cycle_next
	if(firing_cycle_next >= SHORT_REAL_LIMIT)
		firing_cycle_next = -(SHORT_REAL_LIMIT - 1)
	// record start
	our_cycle.cycle_start_time = world.time
	// begin
	firing_cycle = our_cycle
	on_firing_cycle_start(our_cycle)

	var/safety = 50
	var/iteration = 0
	while(iteration < our_cycle.firing_iterations)
		++iteration
		--safety
		if(safety <= 0)
			CRASH("safety ran out during firing cycle")
		our_cycle.last_firing_result = fire(cycle)
		if(!post_fire(cycle))
			break
		if(iteration != iterations)
			sleep(iteration_delay)
			if(firing_cycle != our_cycle)
				our_cycle.last_interrupted = TRUE
				break

	on_firing_cycle_end(our_cycle)
	return our_cycle

//* Firing *//

/**
 * Called to handle post fire
 *
 * @return FALSE to abort firing cycle
 */
/obj/item/gun/proc/post_fire(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	switch(cycle.last_firing_result)
		if(GUN_FIRED_SUCCESS)
			cycle.cycle_iterations_fired++
			return TRUE
		if(GUN_FIRED_FAIL_EMPTY, GUN_FIRED_FAIL_INERT)
			return post_empty_fire(cycle)
		else
			return FALSE

//* Firing - Default Handlers (Overridable) *//

/**
 * Called if someone tries to fire us without live ammo in the chamber (or chamber-equivalent)
 *
 * @return FALSE to abort firing cycle.
 */
/obj/item/gun/proc/post_empty_fire(datum/gun_firing_cycle/cycle)
	if(!(firing_flags & GUN_FIRING_NO_CLICK_EMPTY))
		// default click empty
		default_click_empty(cycle)
	return FALSE

// todo: actor / event_args support
/obj/item/gun/proc/default_click_empty(datum/gun_firing_cycle/cycle)
	var/mob/holding_us = worn_mob()
	if(holding_us)
		holding_us.visible_message(SPAN_WARNING("*click click*"), SPAN_WARNING("*click*"))
	else if(isturf(loc))
		visible_message(SPAN_WARNING("*click click*"), SPAN_WARNING("*click*"))
	playsound(src, 'sound/weapons/empty.ogg', 75, TRUE)
