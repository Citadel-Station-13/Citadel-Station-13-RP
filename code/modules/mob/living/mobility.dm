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
			if(G.stat >= GRAB_AGGRESSIVE)
				blocked |= MOBILITY_CAN_MOVE | MOBILITY_CAN_USE | MOBILITY_CAN_HOLD | MOBILITY_CAN_PICKUP | MOBILITY_CAN_STORAGE | MOBILITY_CAN_UI

	. = ..()

	if(!(mobility_flags & MOBILITY_CAN_HOLD))
		drop_all_held_items()
	if(!(mobility_flags & MOBILITY_CAN_PULL))
		stop_pulling()

#warn impl

/**
 * immediately sets whether or not we're prone.
 * does not check mobility flags.
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

/mob/living/proc/resist_a_rest(instant = FALSE)
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_STAND))
		return //nah

	#warn impl

/mob/living/proc/_resist_a_rest()
	#warn impl

/mob/living/proc/set_intentionally_resting(value, instant)
	#warn impl

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
