/obj/machinery/igniter
	name = "igniter"
	desc = "It's useful for igniting flammable items."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "igniter1"
	var/id = null
	var/on = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/igniter/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/igniter/attack_hand(mob/user)
	if(..())
		return

	use_power(50)
	on = !(on)
	icon_state = text("igniter[]", on)

/obj/machinery/igniter/process(delta_time)	//ugh why is this even in process()?
	if(on && !(machine_stat & NOPOWER))
		var/turf/location = src.loc
		if(isturf(location))
			location.hotspot_expose(1000,500,1)
	return TRUE

/obj/machinery/igniter/Initialize(mapload)
	. = ..()
	icon_state = "igniter[on]"

/obj/machinery/igniter/power_change()
	..()
	if(!(machine_stat & NOPOWER))
		icon_state = "igniter[on]"
	else
		icon_state = "igniter0"

// Wall mounted remote-control igniter.

/obj/machinery/sparker
	name = "Mounted igniter"
	desc = "A wall-mounted ignition device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "migniter"
	var/id = null
	var/disable = FALSE
	var/last_spark = 0
	var/base_state = "migniter"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/sparker/power_change()
	..()
	if(!(machine_stat & NOPOWER) && disable == 0)

		icon_state = "[base_state]"
//		sd_SetLuminosity(2)
	else
		icon_state = "[base_state]-p"
//		sd_SetLuminosity(0)

/obj/machinery/sparker/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		add_fingerprint(user)
		disable = !disable
		playsound(src, W.tool_sound, 50, 1)
		if(disable)
			user.visible_message( \
				SPAN_WARNING("[user] has disabled \the [src]!"), \
				SPAN_WARNING("You disable the connection to \the [src]."))
			icon_state = "[base_state]-d"
		if(!disable)
			user.visible_message( \
				SPAN_WARNING("[user] has reconnected \the [src]!"), \
				SPAN_WARNING("You fix the connection to \the [src]."))
			if(powered())
				icon_state = "[base_state]"
			else
				icon_state = "[base_state]-p"
	else
		..()

/obj/machinery/sparker/attack_ai()
	if(anchored)
		return ignite()
	else
		return

/obj/machinery/sparker/proc/ignite()
	if(!(powered()))
		return

	if((disable) || (last_spark && world.time < last_spark + 50))
		return

	flick("[base_state]-spark", src)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(2, 1, src)
	s.start()
	last_spark = world.time
	use_power(1000)
	var/turf/location = src.loc
	if(isturf(location))
		location.hotspot_expose(1000,500,1)
	return TRUE

/obj/machinery/sparker/emp_act(severity)
	if(machine_stat & (BROKEN|NOPOWER))
		..(severity)
		return
	ignite()
	..(severity)

/obj/machinery/button/ignition
	name = "ignition switch"
	desc = "A remote control switch for a mounted igniter."

/obj/machinery/button/ignition/attack_hand(mob/user)

	if(..())
		return

	use_power(5)

	active = TRUE
	icon_state = "launcheract"

	for(var/obj/machinery/sparker/M in GLOB.machines)
		if(M.id == id)
			spawn(0)
				M.ignite()

	for(var/obj/machinery/igniter/M in GLOB.machines)
		if(M.id == id)
			use_power(50)
			M.on = !(M.on)
			M.icon_state = text("igniter[]", M.on)

	sleep(50)

	icon_state = "launcherbtt"
	active = FALSE

	return
