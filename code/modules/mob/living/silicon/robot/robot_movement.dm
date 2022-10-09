/mob/living/silicon/robot/Process_Spaceslipping(var/prob_slip)
	if(module && module.no_slip)
		return 0
	..(prob_slip)

/mob/living/silicon/robot/Process_Spacemove()
	if(module)
		for(var/obj/item/tank/jetpack/J in module.modules)
			if(istype(J, /obj/item/tank/jetpack))
				if(J.allow_thrust(0.01))
					return TRUE
	return ..()

/mob/living/silicon/robot/movement_delay()
	. = speed
	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		. -= 2

	if(get_restraining_bolt())	// Borgs with Restraining Bolts move slower.
		. += 1

	. += CONFIG_GET(number/robot_delay)

	. = ..()

// NEW: Use power while moving.
/mob/living/silicon/robot/SelfMove(turf/n, direct)
	if (!is_component_functioning("actuator"))
		return 0

	var/datum/robot_component/actuator/A = get_component("actuator")
	if (cell_use_power(A.active_usage))
		return ..()
