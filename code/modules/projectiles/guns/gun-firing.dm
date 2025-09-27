//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Auto Handling *//

/**
 * @return clickchain flags
 */
/obj/item/gun/proc/handle_clickchain_fire(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/mob/resolved_firer = clickchain.performer
	var/resolved_angle = clickchain.resolve_click_angle()
	var/resolved_firing_flags = NONE
	if(resolved_firer.Reachability(clickchain.target))
		resolved_firing_flags |= GUN_FIRING_POINT_BLANK
	start_firing_cycle_async(
		resolved_firer,
		resolved_angle,
		resolved_firing_flags,
		firemode,
		clickchain.target,
		clickchain,
		clickchain.click_params_tile_px,
		clickchain.click_params_tile_py,
		clickchain.legacy_get_target_zone(),
	)
	return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

//* Firing Cycle *//

/**
 * async proc to start a firing cycle
 *
 * * firer is where the will actually come out of.
 * * if firer is a turf, projectile is centered on turf
 * * if firer is a mob, we use its calculations for that depending on how we're held
 * * if firer is ourselves, projectile comes out of us. this is implementation defined.
 *
 * todo: return firing cycle datum
 */
/obj/item/gun/proc/start_firing_cycle_async(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor, tile_pixel_x, tile_pixel_y, target_zone) as /datum/gun_firing_cycle
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	// todo: return firing cycle datum; this tramples return values by the way
	ASYNC
		start_firing_cycle(firer, angle, firing_flags, firemode, target, actor, tile_pixel_x, tile_pixel_y, target_zone)

/**
 * starts, and blocks on a firing cycle
 *
 * * firer is where the will actually come out of.
 * * if firer is a turf, projectile is centered on turf
 * * if firer is a mob, we use its calculations for that depending on how we're held
 * * if firer is ourselves, projectile comes out of us. this is implementation defined.
 *
 * @return firing cycle datum
 */
/obj/item/gun/proc/start_firing_cycle(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor, tile_pixel_x, tile_pixel_y, target_zone) as /datum/gun_firing_cycle
	SHOULD_CALL_PARENT(TRUE)

	// firing cycle ongoing: silently fail
	if(firing_cycle)
		return

	// on cooldown: loudly fail
	if(world.time < next_fire_cycle)
		if(max(last_cooldown_message, last_fire) + 0.75 SECONDS < world.time)
			actor?.chat_feedback(
				SPAN_WARNING("[src] is not ready to fire again!"),
				target = src,
			)
			last_cooldown_message = world.time
		return

	//! LEGACY
	if(actor && !special_check(actor?.performer))
		return
	//! END

	return firing_cycle(firer, angle, firing_flags, firemode, target, actor, tile_pixel_x, tile_pixel_y, target_zone)

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
	SHOULD_CALL_PARENT(TRUE)

/**
 * Hook for firing cycle end
 */
/obj/item/gun/proc/on_firing_cycle_end(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	update_icon()
	if(cycle.firing_actor)
		if(one_handed_penalty)
			if(!(item_flags & ITEM_MULTIHAND_WIELDED))
				switch(one_handed_penalty)
					if(1 to 15)
						if(prob(50))
							cycle.firing_actor.chat_feedback(
								SPAN_WARNING("Your aim wavers slightly."),
								target = src,
							)
					if(16 to 30)
						cycle.firing_actor.chat_feedback(
							SPAN_WARNING("Your aim wavers as you fire [src] with just one hand."),
							target = src,
						)
					if(31 to 45)
						cycle.firing_actor.chat_feedback(
							SPAN_WARNING("You have trouble keeping [src] on target with just one hand."),
							target = src,
						)
					if(46 to INFINITY)
						cycle.firing_actor.chat_feedback(
							SPAN_WARNING("You have struggle to keep [src] on target with just one hand!"),
							target = src,
						)

/**
 * called exactly once at the start of a firing cycle to start it
 *
 * @params
 * * firer - the thing physically firing us; whether a turret, a gun, a person, or anything else.
 *   this is where the projectile will originate regardles of where the gun actually is!
 * * angle - the angle to fire in.
 * * firing_flags - (optional) GUN_FIRING_* flags
 * * firemode - (optional) the /datum/firemode we are firing on
 * * target - (optional) what we're firing at
 * * actor - (optional) the person who initiated the firing
 *
 * @return the gun firing cycle made and used
 */
/obj/item/gun/proc/firing_cycle(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor, tile_pixel_x, tile_pixel_y, target_zone) as /datum/gun_firing_cycle
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE) // only base of /start_firing_cycle is allowed to call us

	/**
	 * As a word of warning, any proc called in this proc must be SHOULD_NOT_SLEEP.
	 * If this is ever violated bad things may happen and things may explode.
	 */

	/**
	 * As another word of warning, a runtime error in this proc is very bad,
	 * as the firing cycle is logged at the end.
	 */

	if(isnull(firemode))
		firemode = src.firemode
		ASSERT(firemode)

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
	our_cycle.original_tile_pixel_x = tile_pixel_x
	our_cycle.original_tile_pixel_y = tile_pixel_y
	our_cycle.original_target_zone = target_zone
	our_cycle.cycle_cooldown = firemode.cycle_cooldown
	our_cycle.base_dispersion_adjust = firemode.projectile_base_dispersion
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
	SEND_SIGNAL(firer, COMSIG_MOB_WEAPON_FIRE_ATTEMPT)

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
		SEND_SIGNAL(src, COMSIG_GUN_FIRING_PREFIRE, our_cycle)
		// did they abort?
		if(our_cycle.next_firing_fail_result)
			our_cycle.finish_iteration(our_cycle.next_firing_fail_result)
		// else fire
		else
			our_cycle.finish_iteration(fire(our_cycle))
		SEND_SIGNAL(src, COMSIG_GUN_FIRING_POSTFIRE, our_cycle)
		// post-fire
		if(!post_fire(our_cycle))
			break
		// reset variables
		// continue if needed
		if(iteration != our_cycle.firing_iterations)
			sleep(our_cycle.firing_delay)
			if(firing_cycle != our_cycle)
				our_cycle.last_interrupted = TRUE
				break

	// send end hooks
	on_firing_cycle_end(our_cycle)
	SEND_SIGNAL(src, COMSIG_GUN_FIRING_CYCLE_END, our_cycle)
	// log
	log_gun_firing_cycle(src, firer, our_cycle, actor)
	// set delay
	next_fire_cycle = world.time + max(0, our_cycle.cycle_cooldown * our_cycle.overall_cooldown_multiply + our_cycle.overall_cooldown_adjust)
	// clear
	firing_cycle = null

	return our_cycle

//* Firing *//

/**
 * Called to fire a single time.
 *
 * @return GUN_FIRED_* result enum
 */
/obj/item/gun/proc/fire(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	//! LEGACY
	if(ismob(cycle.firing_atom))
		var/mob/mob_firer = cycle.firing_atom
		mob_firer.break_cloak()
	//! END

	// todo: do we really need to newtonian move always? some guns shouldn't?
	if(ismovable(cycle.firing_atom))
		var/atom/movable/movable_firer = cycle.firing_atom
		movable_firer.newtonian_move(turn(angle2dir(cycle.original_angle), 180))

	// todo: muzzle flash implementation

	last_fire = world.time
	return GUN_FIRED_SUCCESS

/**
 * Called to handle post fire
 *
 * @return FALSE to abort firing cycle
 */
/obj/item/gun/proc/post_fire(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	switch(cycle.last_firing_result)
		if(GUN_FIRED_SUCCESS)
			if(cycle.cycle_iterations_fired == 1)
				post_first_successful_fire(cycle)
			return post_live_fire(cycle)
		if(GUN_FIRED_FAIL_EMPTY, GUN_FIRED_FAIL_INERT)
			return post_empty_fire(cycle)
		else
			return FALSE

//* Firing - Default Handlers (Overridable) *//

/**
 * Called after the first successful fire of a cycle.
 */
/obj/item/gun/proc/post_first_successful_fire(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	cycle.firing_actor?.visible_feedback(
		range = silenced ? MESSAGE_RANGE_COMBAT_SILENCED : MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_DANGER("[cycle.firing_actor.performer] fires [src][cycle.firing_flags & GUN_FIRING_POINT_BLANK ? " point blank at [cycle.original_target]" : ""][cycle.firing_flags & GUN_FIRING_BY_REFLEX ? " by reflex" : ""]!"),
		audible = SPAN_WARNING("You hear a [fire_sound_text]"),
		otherwise_self = SPAN_WARNING("You fire [src][cycle.firing_flags & GUN_FIRING_POINT_BLANK ? " point blank at [cycle.original_target]" : ""][cycle.firing_flags & GUN_FIRING_BY_REFLEX ? " by reflex" : ""]!"),
	)

/**
 * Called on successful firing
 *
 * todo: actor / event_args support from cycle
 *
 * @return FALSE to abort firing cycle.
 */
/obj/item/gun/proc/post_live_fire(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	var/mob/legacy_user = get_worn_mob()
	if(legacy_user)
		if(recoil)
			spawn()
				shake_camera(legacy_user, recoil + 1, recoil)
	return TRUE

/**
 * Called if someone tries to fire us without live ammo in the chamber (or chamber-equivalent)
 *
 * todo: actor / event_args support from cycle
 *
 * @return FALSE to abort firing cycle.
 */
/obj/item/gun/proc/post_empty_fire(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	if(!(cycle.firing_flags & GUN_FIRING_NO_CLICK_EMPTY))
		// default click empty
		default_click_empty(cycle)
	return FALSE

// todo: actor / event_args support from cycle
/obj/item/gun/proc/default_click_empty(datum/gun_firing_cycle/cycle)
	var/mob/holding_us = get_worn_mob()
	if(holding_us)
		holding_us.visible_message(SPAN_WARNING("*click click*"), SPAN_WARNING("*click*"))
	else if(isturf(loc))
		visible_message(SPAN_WARNING("*click click*"), SPAN_WARNING("*click*"))
	playsound(src, 'sound/weapons/empty.ogg', 75, TRUE)
