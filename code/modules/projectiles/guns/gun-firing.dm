//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Auto Handling *//

/**
 * @return clickchain flags
 */
/obj/item/gun/proc/handle_clickchain_fire(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/mob/resolved_firer = clickchain.performer
	var/resolved_angle = clickchain.resolve_click_angle_from_performer()
	var/resolved_firing_flags = NONE
	if(resolved_firer.Reachability(clickchain.target))
		resolved_firing_flags |= GUN_FIRING_POINT_BLANK
	start_firing_cycle_async(resolved_firer, resolved_angle, resolved_firing_flags, legacy_get_firemode(), clickchain.target, clickchain)
	return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	#warn handle pointblank
	#warn impl

//* Firing Cycle *//

/**
 * async proc to start a firing cycle
 *
 * * firer is where the will actually come out of.
 * * if firer is a turf, projectile is centered on turf
 * * if firer is a mob, we use its calculations for that depending on how we're held
 * * if firer is ourselves, projectile comes out of us. this is implementation defined.
 *
 * @return firing cycle datum
 */
/obj/item/gun/proc/start_firing_cycle_async(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor) as /datum/gun_firing_cycle
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
 *
 * * firer is where the will actually come out of.
 * * if firer is a turf, projectile is centered on turf
 * * if firer is a mob, we use its calculations for that depending on how we're held
 * * if firer is ourselves, projectile comes out of us. this is implementation defined.
 */
/obj/item/gun/proc/start_firing_cycle(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor) as /datum/gun_firing_cycle
	SHOULD_CALL_PARENT(TRUE)
	#warn check next fire time / delays; silently fail if there's a cycle ongoing or right after, and give a message if there isn't
	// if(world.time < next_fire_time)
	// 	if (world.time % 3) //to prevent spam
	// 		to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")

	//! LEGACY
	if(!special_check(actor?.performer))
		return
	//! END

	return firing_cycle(firer, angle, firing_flags, firemode, target, actor)

/**
 * interrupts a given firing cycle ID; if none is provided, we interrupt any active firing cycle.
 */
/obj/item/gun/proc/interrupt_firing_cycle(cycle_id)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(cycle_id && firing_cycle?.cycle_notch != cycle_id)
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
	update_icon()

/**
 * called exactly once at the start of a firing cycle to start it
 *
 * @params
 * * firer - the thing physically firing us; whether a turret or a person.
 *   this is where the projectile will originate regardles of where the gun actually is!
 * * angle - the angle to fire in.
 * * firing_flags - (optional) GUN_FIRING_* flags
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
	#warn logging
	#warn default firemode

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
	// send start hooks
	on_firing_cycle_start(our_cycle)
	SEND_SIGNAL(src, COMSIG_GUN_FIRING_CYCLE_START, our_cycle)

	var/safety = 50
	var/iteration = 0
	while(iteration < our_cycle.firing_iterations)
		// loop guard
		--safety
		if(safety <= 0)
			CRASH("safety ran out during firing cycle")
		// increment iteration; track it locally too, just in case
		++iteration
		our_cycle.cycle_iterations_fired = iteration
		// fire signal
		SEND_SIGNAL(src, COMSIG_GUN_FIRING_CYCLE_ITERATION_PREFIRE, our_cycle)
		// fire
		our_cycle.last_firing_result = fire(our_cycle)
		our_cycle.cycle_iterations_fired++
		// post-fire
		if(!post_fire(our_cycle))
			break
		// reset variables
		our_cycle.next_dispersion_adjust = our_cycle.next_angle_adjust = null
		// continue if needed
		if(iteration != our_cycle.firing_iterations)
			sleep(our_cycle.firing_delay)
			if(firing_cycle != our_cycle)
				our_cycle.last_interrupted = TRUE
				break

	// send end hooks
	on_firing_cycle_end(our_cycle)
	SEND_SIGNAL(src, COMSIG_GUN_FIRING_CYCLE_END, our_cycle)

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
			return post_live_fire(cycle)
		if(GUN_FIRED_FAIL_EMPTY, GUN_FIRED_FAIL_INERT)
			return post_empty_fire(cycle)
		else
			return FALSE

//* Firing - Default Handlers (Overridable) *//

/**
 * Called on successful firing
 *
 * @return FALSE to abort firing cycle.
 */
/obj/item/gun/proc/post_live_fire(datum/gun_firing_cycle/cycle)
	return TRUE

/**
 * Called if someone tries to fire us without live ammo in the chamber (or chamber-equivalent)
 *
 * @return FALSE to abort firing cycle.
 */
/obj/item/gun/proc/post_empty_fire(datum/gun_firing_cycle/cycle)
	if(!(cycle.firing_flags & GUN_FIRING_NO_CLICK_EMPTY))
		// default click empty
		default_click_empty(cycle)
	return FALSE

// todo: actor / event_args support
/obj/item/gun/proc/default_click_empty(datum/gun_firing_cycle/cycle)
	var/mob/holding_us = get_worn_mob()
	if(holding_us)
		holding_us.visible_message(SPAN_WARNING("*click click*"), SPAN_WARNING("*click*"))
	else if(isturf(loc))
		visible_message(SPAN_WARNING("*click click*"), SPAN_WARNING("*click*"))
	playsound(src, 'sound/weapons/empty.ogg', 75, TRUE)
