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
	set_density(!resting)
	mobility_flags = (mobility_flags & ~(MOBILITY_IS_STANDING)) | (value? MOBILITY_IS_STANDING : NONE)
	SEND_SIGNAL(src, COMSIG_MOB_ON_SET_RESTING, value)
	update_lying()
	update_water()

/**
 * immediately toggles resting
 * does not check mobility flags.
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

/mob/living/proc/_resist_a_rest()
	PRIVATE_PROC(TRUE)
	getting_up = TRUE
	#warn impl
	getting_up = FALSE

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
	// allow buckled override
	var/overriding = buckled?.buckle_lying()
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

	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")
	toggle_intentionally_resting()
