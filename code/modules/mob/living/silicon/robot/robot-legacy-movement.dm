/mob/living/silicon/robot/Process_Spacemove()
	// active robot modules are held items
	for(var/obj/item/tank/jetpack/J in inventory?.get_held_items())
		if(istype(J, /obj/item/tank/jetpack))
			if(J.allow_thrust(0.01))
				return TRUE
	return ..()

/mob/living/silicon/robot/legacy_movement_delay()
	. = ..()
	if(get_held_item_of_type(/obj/item/borg/combat/mobility))
		. -= 2

	if(get_restraining_bolt())	// Borgs with Restraining Bolts move slower.
		. += 1

// NEW: Use power while moving.
/mob/living/silicon/robot/SelfMove(turf/n, direct)
	if (!is_component_functioning("actuator"))
		return 0

	var/datum/robot_component/actuator/A = get_component("actuator")
	if (legacy_cell_use_power(A.active_usage))
		return ..()
