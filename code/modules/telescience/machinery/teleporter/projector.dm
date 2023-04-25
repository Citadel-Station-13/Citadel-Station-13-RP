#warn circuit

/obj/machinery/bluespace_projector
	name = "bluespace field projector"
	desc = "A prototype field projector used to project a confinement field over a teleportation pad."

	/// linked capacitor
	var/obj/machinery/bluespace_capacitor/capacitor
	/// target pad
	var/obj/machinery/bluespace_pad/active_target
	/// linked consoles
	var/list/obj/machinery/computer/teleporter/consoles
	/// linked remotes
	var/list/obj/item/bluespace_remote/remotes

/obj/machinery/bluespace_projector/proc/draw(kilojoules)
	return capacitor?.use(kilojoules)

/obj/machinery/bluespace_projector/drain_energy(datum/actor, amount, flags)
	return draw(amount)

#warn teleport_projector
/obj/machinery/tele_projector
	name = "projector"
	desc = "A combination bluespace receiver-projector unit. Handles the busywork of locking onto nearby bluespace flare signals and projecting a readymade conduit for instantaneous matter transmission."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "station"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/tele_projector

	var/obj/machinery/tele_pad/pad
	var/engaged = FALSE

/obj/machinery/tele_projector/Initialize(mapload)
	. = ..()
	update_appearance()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/tele_projector/LateInitialize()
	. = ..()
	for(var/target_dir in GLOB.cardinal)
		var/obj/machinery/tele_pad/found_pad = locate() in get_step(src, target_dir)
		if(found_pad)
			setDir(get_dir(src, found_pad))
			break

/obj/machinery/tele_projector/update_icon()
	cut_overlays()
	if(engaged)
		update_use_power(USE_POWER_ACTIVE)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		add_overlay(I)
	else
		update_use_power(USE_POWER_IDLE)
		if(operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER
			add_overlay(I)

/obj/machinery/tele_projector/attackby(obj/item/W)
	attack_hand()

/obj/machinery/tele_projector/attack_ai()
	attack_hand()

/obj/machinery/tele_projector/attack_hand(mob/user, list/params)
	if(engaged)
		disengage()
	else
		engage()

/obj/machinery/tele_projector/proc/engage()
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

/obj/machinery/tele_projector/proc/disengage()
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
