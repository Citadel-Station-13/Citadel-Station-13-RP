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
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/tele_pad/LateInitialize()
	. = ..()
	update_icon()

/obj/machinery/tele_pad/update_icon()
	cut_overlays()
	if(com?.projector?.engaged)
		set_use_power(USE_POWER_ACTIVE)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER_MAIN
		add_overlay(I)
	else
		set_use_power(USE_POWER_IDLE)
		if(operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER_MAIN
			add_overlay(I)

/obj/machinery/tele_pad/Bumped(atom/movable/M)
	. = ..()
	if(M.atom_flags & ATOM_ABSTRACT)
		return
	if(M.anchored)
		return
	if(istype(M, /obj/effect))
		return
	if(com?.projector?.engaged)
		teleport(M)
		use_burst_power(5000)

/obj/machinery/tele_pad/proc/teleport(atom/movable/M as mob|obj)
	if(!com)
		return
	if(!com.locked)
		return
	if(!com.projector.consume_charge(M))
		audible_message(SPAN_BOLDWARNING("[src] buzzes harshly, \"Power reserves insufficent for teleport. Lighten mass load or await recharge.\""))
		playsound(src.loc, 'sound/machines/apc_nopower.ogg', 50, 0)
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
