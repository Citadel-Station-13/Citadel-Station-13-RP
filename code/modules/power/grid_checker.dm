/obj/machinery/power/grid_checker
	name = "grid checker"
	desc = "A machine that reacts to unstable conditions in the powernet, by safely shutting everything down.  Probably better \
	than the alternative."
	icon_state = "gridchecker_on"
	circuit = /obj/item/circuitboard/grid_checker
	density = 1
	anchored = 1
	var/power_failing = FALSE // Turns to TRUE when the grid check event is fired by the Game Master, or perhaps a cheeky antag.
	// Wire stuff below.
	var/datum/wires/grid_checker/wires
	var/wire_locked_out = FALSE
	var/wire_allow_manual_1 = FALSE
	var/wire_allow_manual_2 = FALSE
	var/wire_allow_manual_3 = FALSE
	var/opened = FALSE

/obj/machinery/power/grid_checker/Initialize(mapload, newdir)
	. = ..()
	update_icon()
	wires = new(src)
	component_parts = list()
	component_parts += new /obj/item/stock_parts/capacitor(src)
	component_parts += new /obj/item/stock_parts/capacitor(src)
	component_parts += new /obj/item/stock_parts/capacitor(src)
	component_parts += new /obj/item/stack/cable_coil(src, 10)
	RefreshParts()

/obj/machinery/power/grid_checker/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/power/grid_checker/update_icon()
	if(power_failing)
		icon_state = "gridchecker_off"
		set_light(2, 2, "#F86060")
	else
		icon_state = "gridchecker_on"
		set_light(2, 2, "#A8B0F8")

/obj/machinery/power/grid_checker/attackby(obj/item/W, mob/user)
	if(!user)
		return
	if(W.is_screwdriver())
		default_deconstruction_screwdriver(user, W)
		opened = !opened
	else if(W.is_crowbar())
		default_deconstruction_crowbar(user, W)
	else if(istype(W, /obj/item/multitool) || W.is_wirecutter())
		attack_hand(user)

/obj/machinery/power/grid_checker/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(!user)
		return
	add_fingerprint(user)
	interact(user)

/obj/machinery/power/grid_checker/interact(mob/user)
	if(!user)
		return

	if(opened)
		wires.Interact(user)

	return nano_ui_interact(user)

/obj/machinery/power/grid_checker/proc/power_failure(var/announce = TRUE)
	if(announce)
		command_announcement.Announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, \
		the colony's power will be shut off for an indeterminate duration while the powernet monitor restarts automatically, or \
		when Engineering can manually resolve the issue.",
		"Critical Power Failure",
		new_sound = 'sound/AI/poweroff.ogg')
	power_failing = TRUE

	var/list/datum/hosts = connection?.network?.get_hosts()

	for(var/obj/machinery/power/terminal/T in hosts) // APCs that are "downstream" of the powernet.
		if(istype(T.master, /obj/machinery/apc))
			var/obj/machinery/apc/A = T.master
			if(A.is_critical)
				continue
			// todo: start_grid_check()
			A.do_grid_check()

	for(var/obj/machinery/power/smes/smes in hosts) // These are "upstream"
		smes.do_grid_check()

	update_icon()

	spawn(rand(4 MINUTES, 10 MINUTES) )
		if(power_failing) // Check to see if engineering didn't beat us to it.
			end_power_failure(TRUE)

/obj/machinery/power/grid_checker/proc/end_power_failure(var/announce = TRUE)
	if(announce)
		command_announcement.Announce("Power has been restored to [station_name()]. We apologize for the inconvenience.",
		"Power Systems Nominal",
		new_sound = 'sound/AI/poweron.ogg')
	power_failing = FALSE
	update_icon()

	var/list/datum/hosts = connection?.network?.get_hosts()

	for(var/obj/machinery/power/terminal/T in hosts)
		if(istype(T.master, /obj/machinery/apc))
			var/obj/machinery/apc/A = T.master
			if(A.is_critical)
				continue
			// todo: reset_grid_check()
			A.error_check_until = null

	for(var/obj/machinery/power/smes/smes in hosts) // These are "upstream"
		smes.grid_check = FALSE
