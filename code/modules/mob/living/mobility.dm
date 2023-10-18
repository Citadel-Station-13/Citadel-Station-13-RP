/mob/living/update_mobility(blocked, forced)
	// this proc looks mildly heretical and pyramid of doomy
	// for micro-optimization purposes.
	if(!IS_CONSCIOUS(src))
		blocked |= MOBILITY_FLAGS_REAL | MOBILITY_IS_CONSCIOUS
	else
		if(restrained())
			blocked |= MOBILITY_CAN_USE | MOBILITY_CAN_PICKUP | MOBILITY_CAN_HOLD | MOBILITY_CAN_PULL | MOBILITY_CAN_STORAGE | MOBILITY_CAN_UI
			if(pulledby || buckled)
				blocked |= MOBILITY_CAN_MOVE
		for(var/obj/item/grab/G as anything in grabbed_by)
			if(G.state >= GRAB_AGGRESSIVE)
				blocked |= MOBILITY_CAN_MOVE | MOBILITY_CAN_USE | MOBILITY_CAN_HOLD | MOBILITY_CAN_PICKUP | MOBILITY_CAN_STORAGE | MOBILITY_CAN_UI
	if(resting)
		blocked |= MOBILITY_IS_STANDING

	. = ..()

	if(!(mobility_flags & MOBILITY_CAN_HOLD))
		drop_all_held_items()
	if(!(mobility_flags & MOBILITY_CAN_PULL))
		stop_pulling()
	if(!(mobility_flags & MOBILITY_CAN_STAND))
		set_resting(TRUE)

/**
 * immediately sets whether or not we're prone.
 * does not check mobility flags.
 * does not set other mobility flags or update mobility.
 */
/mob/living/proc/set_resting(value)
	if(resting == value)
		return
	resting = value
	if(resting)
		add_movespeed_modifier(/datum/movespeed_modifier/mob_crawling)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/mob_crawling)
	set_density(!resting)
	if(value)
		mobility_flags &= ~(MOBILITY_IS_STANDING)
	else
		mobility_flags |= MOBILITY_IS_STANDING
	SEND_SIGNAL(src, COMSIG_MOB_ON_SET_RESTING, value)
	update_lying()
	update_water()

/**
 * immediately toggles resting
 * does not check, or update mobility flags.
 */
/mob/living/proc/toggle_resting()
	set_resting(!resting)

/**
 * starts to resist up from a resting state
 *
 * @return TRUE / FALSE based on if we started a new resist operation.
 */
/mob/living/proc/resist_a_rest(instant = FALSE)
	if(!resting) // already up
		return FALSE
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_STAND))
		return FALSE // nah
	if(getting_up)
		return FALSE // already doing so
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living, _resist_a_rest), instant)
	return TRUE

/mob/living/proc/_resist_a_rest(instant)
	PRIVATE_PROC(TRUE)
	getting_up = TRUE
	getting_up_loc = loc
	getting_up_penalized = world.time
	getting_up_original = get_up_delay()
	if(isturf(loc) && !instant)
		visible_message(
			SPAN_NOTICE("[src] starts to get up off the ground."),
			SPAN_NOTICE("You start pushing yourself off the ground."),
		)
	else
		innate_feedback(SPAN_NOTICE("You start pushing yourself off the ground."))
	if(instant || do_self(src, getting_up_original, flags = DO_AFTER_IGNORE_ACTIVE_ITEM | DO_AFTER_IGNORE_MOVEMENT, mobility_flags = MOBILITY_CAN_RESIST, additional_checks = CALLBACK(src, PROC_REF(_resisting_a_rest))))
		if(isturf(loc))
			visible_message(
				SPAN_NOTICE("[src] gets up from the ground."),
				SPAN_NOTICE("You get up."),
			)
		else
			innate_feedback(SPAN_NOTICE("You get up."))
		set_resting(FALSE)
	else
		if(isturf(loc))
			visible_message(
				SPAN_NOTICE("[src] falls back down."),
				SPAN_NOTICE("You fall back down."),
			)
		else
			innate_feedback(SPAN_NOTICE("You get up."))
	getting_up = FALSE

/mob/living/proc/get_up_delay()
	// todo: redo
	return 5 + (1 - clamp(health / getMaxHealth(), 0, 1)) * 33 + min(halloss, 100) * 0.33

#define PENALIZE_FACTOR 0.5

/mob/living/proc/_resisting_a_rest(list/do_after_args)
	var/current_delay = get_up_delay()
	if(current_delay != getting_up_original)
		do_after_args[DO_AFTER_ARG_DELAY] += current_delay - getting_up_original
		getting_up_original = current_delay
	if(getting_up_loc != loc)
		var/penalizing = world.time - getting_up_penalized
		getting_up_penalized = world.time
		getting_up_loc = loc
		// penalize up to 1.5 seconds retroactively
		do_after_args[DO_AFTER_ARG_DELAY] += min(1.5 SECONDS, penalizing) * PENALIZE_FACTOR
	return TRUE

#undef PENALIZE_FACTOR

/mob/living/proc/auto_resist_rest()
	if(resting_intentionally || !resting)
		return
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_STAND))
		return
	resist_a_rest()

/mob/living/proc/set_intentionally_resting(value, instant)
	resting_intentionally = value
	if(resting_intentionally && !resting)
		set_resting(TRUE)
	else if(!resting_intentionally && resting)
		resist_a_rest(instant)

/mob/living/proc/toggle_intentionally_resting(instant)
	set_intentionally_resting(!resting_intentionally, instant)

/**
 * sets our lying value to the correct value,
 * updates icons if necessary,
 * and updates mobility if necessary.
 */
/mob/living/proc/update_lying()
	var/wanted = 0
	// check if we're standing
	if(IS_PRONE(src))
		// fall onto side if not already down
		if(!lying)
			switch(dir)
				if(NORTH, SOUTH)
					wanted = pick(90, -90)
				if(EAST)
					wanted = 90
				if(WEST)
					wanted = -90
		else
			wanted = lying
	// allow buckled override
	var/overriding = buckled?.buckle_lying(src)
	if(!isnull(overriding))
		wanted = overriding
	// check if we need to update
	if(wanted == lying)
		return
	var/old = lying
	lying = wanted
	SEND_SIGNAL(src, COMSIG_MOB_ON_UPDATE_LYING, old, lying)
	update_transform()

/mob/proc/cannot_stand()
	return incapacitated(INCAPACITATION_KNOCKDOWN)

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	to_chat(src, "<span class='notice'>You are now [resting_intentionally ? "attempting to stay upright." : "resting intentionally."]</span>")
	toggle_intentionally_resting()
