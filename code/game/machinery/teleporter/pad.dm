/obj/machinery/tele_pad
	name = "teleporter pad"
	desc = "The teleporter pad handles all of the impossibly complex busywork required in instant matter transmission."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/tele_pad
	light_color = LIGHT_COLOR_BLUEGREEN
	var/obj/machinery/computer/teleporter/com

/obj/machinery/tele_pad/Initialize(mapload)
	. = ..()
	default_apply_parts()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/tele_pad/LateInitialize()
	. = ..()
	update_icon()

/obj/machinery/tele_pad/update_icon()
	overlays.Cut()
	if(com?.projector?.engaged)
		update_use_power(USE_POWER_ACTIVE)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		overlays += I
		set_light(0.4, 1.2, 4, 10)
	else
		set_light(0)
		update_use_power(USE_POWER_IDLE)
		if(operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER
			overlays += I

/obj/machinery/tele_pad/Bumped(M as mob|obj)
	if(com?.projector?.engaged)
		teleport(M)
		use_power_oneoff(5000)

/obj/machinery/tele_pad/proc/teleport(atom/movable/M as mob|obj)
	if(!com)
		return
	if(!com.locked)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_WARNING("Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix."))
		return
	do_teleport(M, com.locked)
	if(com.one_time_use) //Make one-time-use cards only usable one time!
		com.one_time_use = FALSE
		com.locked = null
		if(com.projector)
			com.projector.engaged = FALSE
		update_icon()
	return

/obj/machinery/tele_pad/Destroy()
	com = null
	return ..()
