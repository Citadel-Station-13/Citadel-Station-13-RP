
/mob/update_gravity()
	var/has_gravity = has_gravity()
	if(has_gravity != in_gravity)
		in_gravity = has_gravity
		if(has_gravity)
			on_in_gravity_gain()
		else
			on_in_gravity_lost()

	var/has_gravity_tethered = has_gravity || process_gravity_tethered()
	if(in_gravity_tethered != has_gravity_tethered)
		in_gravity_tethered = has_gravity_tethered
		if(has_gravity_tethered)
			on_in_gravity_tethered_gain()
		else
			on_in_gravity_tethered_lost()

/mob/proc/on_in_gravity_lost()
	update_movespeed()

/mob/proc/on_in_gravity_gain()
	update_movespeed()

/mob/proc/on_in_gravity_tethered_lost()
	update_floating()

/mob/proc/on_in_gravity_tethered_gain()
	update_floating()

/**
 * Checks if we're able to be tethered to anything rather than free-floating.
 */
/mob/proc/process_gravity_tethered()
	if(buckled)
		return TRUE
	if(anchored)
		return TRUE
	var/has_shoegrip
	// magboots & walls
	for(var/turf/potential in oview(1, src))
		if(potential.density)
			return TRUE
		if(istype(potential, /turf/space))
			continue
		// todo: check for ferromagnetic :troll:
		if(istype(potential, /turf/simulated/floor))
			if(isnull(has_shoegrip))
				has_shoegrip = Check_Shoegrip()
			else if(has_shoegrip)
				return TRUE
	return FALSE
