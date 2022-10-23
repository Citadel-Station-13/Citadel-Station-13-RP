/obj/machinery/exonet_node
	name = "exonet node"
	desc = null // Gets written in New()
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "exonet_node"
	idle_power_usage = 2500
	density = TRUE
	var/on = TRUE
	var/toggle = TRUE

	var/allow_external_PDAs = TRUE
	var/allow_external_communicators = TRUE
	var/allow_external_newscasters = TRUE

	var/opened = FALSE
	///Gets written to by exonet's send_message() function.
	var/list/logs = list()

	circuit = /obj/item/circuitboard/telecomms/exonet_node

// Proc: Initialize()
// Parameters: None
// Description: Adds components to the machine for deconstruction. Also refreshes the descrition.
/obj/machinery/exonet_node/map/Initialize(mapload, newdir)
	. = ..()

	default_apply_parts()
	desc = "This machine is one of many, many nodes inside [GLOB.using_map.starsys_name]'s section of the Exonet, connecting the \
	[GLOB.using_map.station_short] to the rest of the system, at least electronically."
	update_desc()

// Proc: update_icon()
// Parameters: None
// Description: Self explanatory.
/obj/machinery/exonet_node/update_icon()
	if(on)
		if(!allow_external_PDAs && !allow_external_communicators && !allow_external_newscasters)
			icon_state = "[initial(icon_state)]_idle"
		else
			icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

// Proc: update_power()
// Parameters: None
// Description: Sets the device on/off and adjusts power draw based on stat and toggle variables.
/obj/machinery/exonet_node/proc/update_power()
	if(toggle)
		if(machine_stat & (BROKEN|NOPOWER|EMPED))
			on = 0
			idle_power_usage = 0
		else
			on = 1
			idle_power_usage = 2500
	else
		on = 0
		idle_power_usage = 0
	update_icon()

// Proc: emp_act()
// Parameters: 1 (severity - how strong the EMP is, with lower numbers being stronger)
// Description: Shuts off the machine for awhile if an EMP hits it.  Ion anomalies also call this to turn it off.
/obj/machinery/exonet_node/emp_act(severity)
	if(!(machine_stat & EMPED))
		machine_stat |= EMPED
		var/duration = (300 * 10)/severity
		spawn(rand(duration - 20, duration + 20))
			machine_stat &= ~EMPED
	update_icon()
	..()

// Proc: process()
// Parameters: None
// Description: Calls the procs below every tick.
/obj/machinery/exonet_node/process(delta_time)
	update_power()

// Proc: attackby()
// Parameters: 2 (I - the item being whacked against the machine, user - the person doing the whacking)
// Description: Handles deconstruction.
/obj/machinery/exonet_node/attackby(obj/item/I, mob/user)
	if(I.is_screwdriver())
		default_deconstruction_screwdriver(user, I)
	else if(I.is_crowbar())
		default_deconstruction_crowbar(user, I)
	else
		..()

// Proc: attack_ai()
// Parameters: 1 (user - the AI clicking on the machine)
// Description: Redirects to attack_hand()
/obj/machinery/exonet_node/attack_ai(mob/user)
	attack_hand(user)

// Proc: attack_hand()
// Parameters: 1 (user - the person clicking on the machine)
// Description: Opens the TGUI interface with ui_interact()
/obj/machinery/exonet_node/attack_hand(mob/user)
	ui_interact(user)

// Proc: ui_interact()
// Parameters: 2 (user - person interacting with the UI, ui - the UI itself, in a refresh)
// Description: Handles opening the TGUI interface
/obj/machinery/exonet_node/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ExonetNode", src)
		ui.open()

// Proc: ui_data()
// Parameters: 1 (user - the person using the interface)
// Description: Allows the user to turn the machine on or off, or open or close certain 'ports' for things like external PDA messages, newscasters, etc.
/obj/machinery/exonet_node/ui_data(mob/user)
	// this is the data which will be sent to the ui
	var/list/data = list()

	data["on"] = toggle ? 1 : 0
	data["allowPDAs"] = allow_external_PDAs
	data["allowCommunicators"] = allow_external_communicators
	data["allowNewscasters"] = allow_external_newscasters
	data["logs"] = logs

	return data

// Proc: ui_act()
// Parameters: 2 (standard ui_act arguments)
// Description: Responds to button presses on the TGUI interface.
/obj/machinery/exonet_node/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("toggle_power")
			. = TRUE
			toggle = !toggle
			update_power()
			if(!toggle)
				var/msg = "[usr.client.key] ([usr]) has turned [src] off, at [x],[y],[z]."
				message_admins(msg)
				log_game(msg)

		if("toggle_PDA_port")
			. = TRUE
			allow_external_PDAs = !allow_external_PDAs

		if("toggle_communicator_port")
			. = TRUE
			allow_external_communicators = !allow_external_communicators
			if(!allow_external_communicators)
				var/msg = "[usr.client.key] ([usr]) has turned [src]'s communicator port off, at [x],[y],[z]."
				message_admins(msg)
				log_game(msg)

		if("toggle_newscaster_port")
			. = TRUE
			allow_external_newscasters = !allow_external_newscasters
			if(!allow_external_newscasters)
				var/msg = "[usr.client.key] ([usr]) has turned [src]'s newscaster port off, at [x],[y],[z]."
				message_admins(msg)
				log_game(msg)

	update_icon()
	add_fingerprint(usr)

// Proc: get_exonet_node()
// Parameters: None
// Description: Helper proc to get a reference to an Exonet node.
/proc/get_exonet_node(atom/host)
	for(var/obj/machinery/exonet_node/E in GLOB.machines)
		if(E.on && (!host || can_telecomm(host, E)))
			return E

// Proc: write_log()
// Parameters: 4 (origin_address - Where the message is from, target_address - Where the message is going, data_type - Instructions on how to interpet content,
// 		content - The actual message.
// Description: This writes to the logs list, so that people can see what people are doing on the Exonet ingame.  Note that this is not an admin logging function.
// 		Communicators are already logged seperately.
/obj/machinery/exonet_node/proc/write_log(var/origin_address, var/target_address, var/data_type, var/content)
	//var/timestamp = time2text(station_time_in_ds, "hh:mm:ss")
	var/timestamp = "[stationdate2text()] [stationtime2text()]"
	var/msg = "[timestamp] | FROM [origin_address] TO [target_address] | TYPE: [data_type] | CONTENT: [content]"
	logs.Add(msg)
