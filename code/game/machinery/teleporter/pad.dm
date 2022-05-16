/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/machines/teleporter.dmi'
	density = TRUE
	anchored = TRUE
	var/lockeddown = FALSE

/obj/machinery/teleport/pad
	name = "teleporter pad"
	desc = "The teleporter pad handles all of the impossibly complex busywork required in instant matter transmission."
	icon_state = "pad"
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/teleporter_hub
	var/obj/machinery/computer/teleporter/com
	light_color = "#02d1c7"

/obj/machinery/teleport/pad/Initialize(mapload)
	. = ..()
	default_apply_parts()
	RefreshParts()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/teleport/pad/LateInitialize()
	. = ..()
	update_icon()

/obj/machinery/teleport/pad/update_icon()
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

/obj/machinery/teleport/pad/Bumped(M as mob|obj)
	if(com?.projector?.engaged)
		teleport(M)
		use_power_oneoff(5000)

/obj/machinery/teleport/pad/proc/teleport(atom/movable/M as mob|obj)
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

/obj/machinery/teleport/pad/Destroy()
	com = null
	return ..()
