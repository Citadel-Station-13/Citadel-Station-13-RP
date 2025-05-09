// TODO: put into SSspatial_effects
/**
 * Legacy EMP pulses
 *
 * Ranges are starting at 1 for 1x1, so 0 = don't affect.
 */
/proc/empulse(turf/epicenter, first_range, second_range, third_range, fourth_range, log = TRUE, message_admins = FALSE)
	if(!epicenter)
		return

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(message_admins)
		message_admins("EMP with size ([first_range], [second_range], [third_range], [fourth_range]) in area [epicenter.loc.name] ")
	log_game("EMP with size ([first_range], [second_range], [third_range], [fourth_range]) in area [epicenter.loc.name] ")

	if(first_range > 1)
		var/obj/effect/overlay/pulse = new /obj/effect/overlay(epicenter)
		pulse.icon = 'icons/effects/effects.dmi'
		pulse.icon_state = "emppulse"
		pulse.name = "emp pulse"
		pulse.anchored = 1
		spawn(20)
			qdel(pulse)

	// expand ranges
	if(first_range > second_range)
		second_range = first_range
	if(second_range > third_range)
		third_range = second_range
	if(third_range > fourth_range)
		fourth_range = third_range

	// this is dumb but whatever
	for(var/mob/M in range(fourth_range - 1, epicenter))
		SEND_SOUND(M, sound('sound/effects/EMPulse.ogg'))

	for(var/atom/T in range(fourth_range - 1, epicenter))
		var/distance = get_dist(epicenter, T)
		if(distance < 0)
			distance = 0
		//Worst effects, really hurts
		if(distance < first_range)
			T.emp_act(1)
		//Slightly less painful
		else if(distance < second_range)
			T.emp_act(2)
		//Even less slightly less painful
		else if(distance < third_range)
			T.emp_act(3)
		//This should be more or less harmless
		else if(distance < fourth_range)
			T.emp_act(4)
	return 1
