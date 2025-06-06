/obj/machinery/pda_multicaster
	name = "\improper PDA multicaster"
	desc = "This machine mirrors messages sent to it to specific departments."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "controller"
	density = 1
	anchored = 1
	circuit = /obj/item/circuitboard/telecomms/pda_multicaster
	use_power = USE_POWER_IDLE
	idle_power_usage = 750
	/// If we're currently active.
	var/on = TRUE
	/// If we /should/ be active or not.
	var/toggle = TRUE
	var/list/internal_PDAs = list() // Assoc list of PDAs inside of this, with the department name being the index,

/obj/machinery/pda_multicaster/Initialize(mapload, newdir)
	. = ..()
	internal_PDAs = list("command" = new /obj/item/pda/multicaster/command(src),
		"security" = new /obj/item/pda/multicaster/security(src),
		"engineering" = new /obj/item/pda/multicaster/engineering(src),
		"medical" = new /obj/item/pda/multicaster/medical(src),
		"research" = new /obj/item/pda/multicaster/research(src),
		"cargo" = new /obj/item/pda/multicaster/cargo(src),
		"civilian" = new /obj/item/pda/multicaster/civilian(src))

/obj/machinery/pda_multicaster/Destroy()
	for(var/atom/movable/AM in contents)
		qdel(AM)
	return ..()

/obj/machinery/pda_multicaster/update_icon_state()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-p"
	return ..()

/obj/machinery/pda_multicaster/attackby(obj/item/I, mob/user)
	if(I.is_screwdriver())
		default_deconstruction_screwdriver(user, I)
	else if(I.is_crowbar())
		default_deconstruction_crowbar(user, I)
	else
		..()

/obj/machinery/pda_multicaster/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/pda_multicaster/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	toggle_power(user)

/obj/machinery/pda_multicaster/proc/toggle_power(mob/user)
	toggle = !toggle
	visible_message("\the [user] turns \the [src] [toggle ? "on" : "off"].")
	update_power()
	if(!toggle)
		var/msg = "[usr.client.key] ([usr]) has turned [src] off, at [x],[y],[z]."
		message_admins(msg)
		log_game(msg)

/obj/machinery/pda_multicaster/proc/update_PDAs(turn_off)
	for(var/obj/item/pda/pda in contents)
		pda.toff = turn_off

/obj/machinery/pda_multicaster/proc/update_power()
	if(toggle)
		if(machine_stat & (BROKEN|NOPOWER|EMPED))
			on = FALSE
			update_PDAs(TRUE) // 1 being to turn off.
			idle_power_usage = 0
		else
			on = TRUE
			update_PDAs(FALSE)
			idle_power_usage = 750
	else
		on = FALSE
		update_PDAs(TRUE)
		idle_power_usage = 0
	update_icon()

/obj/machinery/pda_multicaster/process(delta_time)
	update_power()

/obj/machinery/pda_multicaster/emp_act(severity)
	if(!(machine_stat & EMPED))
		machine_stat |= EMPED
		var/duration = (300 * 10)/severity
		spawn(rand(duration - 20, duration + 20))
			machine_stat &= ~EMPED
	update_icon()
	..()
