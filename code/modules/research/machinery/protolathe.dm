/**
 * Protolathe
 */
/obj/machinery/lathe/r_n_d/protolathe
	name = "Protolathe"
	icon = 'icons/obj/machines/fabricators/protolathe.dmi'
	icon_state = "protolathe"
	base_icon_state = "protolathe"
	atom_flags = OPENCONTAINER
	circuit = /obj/item/circuitboard/protolathe
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000
	has_interface = TRUE
	lathe_type = LATHE_TYPE_AUTOLATHE | LATHE_TYPE_PROTOLATHE

/obj/machinery/lathe/r_n_d/protolathe/update_icon_state()
	. = ..()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]-off"
	else
		icon_state = base_icon_state

/obj/machinery/lathe/r_n_d/protolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_lathe = null
			linked_console = null
	else
		return ..()
