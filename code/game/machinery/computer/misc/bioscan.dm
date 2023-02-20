/obj/machinery/computer/bioscan
	name = "Bioscan Control Console"
	desc = "Used to pinpoint signatures, biological or otherwise, using a series of antennaes."
	icon_keyboard = "tech_key"

	/// network key
	var/network_key
	/// buffer - quite literally just holds a copy of generated ui data
	var/list/buffer
	/// last scan at
	var/last_scan
	/// scan cooldown
	var/scan_delay = 10 SECONDS

/obj/machinery/computer/bioscan/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BioscanConsole")
		ui.open()

/obj/machinery/computer/bioscan/ui_static_data(mob/user)
	. = ..()
	.["scan"] = buffer || list()

/obj/machinery/computer/bioscan/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["scan_ready"] = on_cooldown()
	.["network"] = network_key

/obj/machinery/computer/bioscan/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("scan")
			if(!network_key)
				visible_message(SPAN_WARNING("[icon2html(src)] flashes a message, \"No network set.\""))
			if(on_cooldown())
				visible_message(SPAN_WARNING("[icon2html(src)] flashes a message, \"Bioscan still on cooldown.\""))
			last_scan = world.time
			atom_say("Commencing signature scan and updating buffers...")
			scan()
			return TRUE
		if("set_network")
			var/what = params["network"] || null
			set_network(what)
			return TRUE

/obj/machinery/computer/bioscan/proc/on_cooldown()
	return (world.time - last_scan) <= scan_delay

/obj/machinery/computer/bioscan/proc/set_network(key)
	network_key = key
	void_scan()

/obj/machinery/computer/bioscan/proc/void_scan()
	buffer = list()
	send_tgui_data_immediate(data = list("scan" = list()))

/obj/machinery/computer/bioscan/proc/scan()
	var/list/new_data = list()
	#warn generate data

	buffer = new_data
	send_tgui_data_immediate(data = list("scan" = buffer))
