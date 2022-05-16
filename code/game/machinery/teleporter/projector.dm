/obj/machinery/teleport/projector
	name = "projector"
	desc = "This machine is capable of projecting a miniature wormhole leading directly to its provided target."
	icon_state = "station"
	var/engaged = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/teleporter_station
	var/obj/machinery/teleport/pad/pad

/obj/machinery/teleport/projector/Initialize(mapload)
	. = ..()
	default_apply_parts()
	update_appearance()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/teleport/projector/LateInitialize()
	. = ..()
	for(var/target_dir in GLOB.cardinal)
		var/obj/machinery/teleport/pad/found_pad = locate() in get_step(src, target_dir)
		if(found_pad)
			setDir(get_dir(src, found_pad))
			break

/obj/machinery/teleport/projector/update_icon()
	overlays.Cut()
	if(engaged)
		update_use_power(USE_POWER_ACTIVE)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		overlays += I
	else
		update_use_power(USE_POWER_IDLE)
		if(operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER
			overlays += I

/obj/machinery/teleport/projector/attackby(var/obj/item/W)
	attack_hand()

/obj/machinery/teleport/projector/attack_ai()
	attack_hand()

/obj/machinery/teleport/projector/attack_hand()
	if(engaged)
		disengage()
	else
		engage()

/obj/machinery/teleport/projector/proc/engage()
	if(machine_stat & (BROKEN|NOPOWER))
		return

	engaged = TRUE
	update_appearance()
	if(pad)
		pad.update_icon()
		pad.update_use_power(USE_POWER_ACTIVE)
		update_use_power(USE_POWER_ACTIVE)
		use_power(5000)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_NOTICE("Teleporter engaged!"), 2)
	add_fingerprint(usr)
	return

/obj/machinery/teleport/projector/proc/disengage()
	if(machine_stat & (BROKEN|NOPOWER))
		return

	engaged = FALSE
	update_appearance()
	if(pad)
		pad.update_icon()
		pad.update_use_power(USE_POWER_IDLE)
		update_use_power(USE_POWER_IDLE)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_NOTICE("Teleporter disengaged!"), 2)
	add_fingerprint(usr)
	return

/atom/proc/laserhit(obj/L)
	return TRUE
