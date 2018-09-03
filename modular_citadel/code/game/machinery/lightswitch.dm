/obj/machinery/light_switch
	var/slow_turning_on = FALSE
	var/forceful_toggle = FALSE
	var/check_time = 0 // A time at which another mob check will occure.

/obj/machinery/light_switch/process()
	if(check_time < world.time && !(round(world.time) % 10 SECONDS)) // Each 10 seconds it checks if anyone is in the area, but also whether the light wasn't switched on recently.
		if(area.are_living_present())
			if(!on)
				spawn(0)
					if(!on)
						dramatic_turning()
						set_on(TRUE)
			else
				check_time = world.time + 10 MINUTES
		else
			set_on(FALSE, FALSE)

/obj/machinery/light_switch/attack_hand(mob/user)
	forceful_toggle = TRUE
	set_on(!on)

/obj/machinery/light_switch/proc/dramatic_turning()
	if(slow_turning_on) // Sanity check. So nothing can force this thing to run twice simultaneously.
		return

	slow_turning_on = TRUE

	for(var/obj/machinery/light/L in area)
		L.seton(L.has_power())
		if(prob(50))
			L.flicker(rand(1, 3))
		sleep(10)

		if(forceful_toggle)
			forceful_toggle = FALSE
			return

	slow_turning_on = FALSE

/obj/machinery/light_switch/proc/set_on(on_ = TRUE, play_sound = TRUE)
	on = on_

	area.lightswitch = on_
	area.updateicon()
	if(play_sound)
		playsound(src, 'sound/machines/button.ogg', 100, 1, 0)

	for(var/obj/machinery/light_switch/L in area)
		L.on = on_
		L.update_icon()

	if(on_)
		check_time = world.time + 10 MINUTES

	area.power_change()

/obj/machinery/light_switch/attack_hand(mob/user)
	forceful_toggle = TRUE
	set_on(!on)
