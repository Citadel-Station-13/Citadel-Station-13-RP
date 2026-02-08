/mob/living/silicon/robot/process_spacemove(drifting, movement_dir, just_checking)
	// no support for just_checking yet
	if(module && !just_checking)
		for(var/obj/item/tank/jetpack/J in get_held_items())
			if(istype(J, /obj/item/tank/jetpack))
				if(J.allow_thrust(0.01))
					return TRUE

/mob/living/silicon/robot/legacy_movement_delay()
	. = ..()
	if(get_held_item_of_type(/obj/item/borg/combat/mobility))
		. -= 2

	if(get_restraining_bolt())	// Borgs with Restraining Bolts move slower.
		. += 1

// NEW: Use power while moving.
/mob/living/silicon/robot/self_move(turf/n, direct)
	if (!is_component_functioning("actuator"))
		return 0

	// TODO: this can't work like this when self_move can return FALSE, this should be on_self_move or something
	var/datum/robot_component/actuator/A = get_component("actuator")
	if (legacy_cell_use_power(A.active_usage))
		return ..()
