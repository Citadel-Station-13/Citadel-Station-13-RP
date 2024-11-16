/obj/machinery/status_display/supply_display
	name = "supply display"
	current_mode = STATUS_DISPLAY_MESSAGE
	text_color = "#ff9900"
	header_text_color = "#fff743"

/obj/machinery/status_display/supply/process()
	if(machine_stat & NOPOWER)
		// No power, no processing.
		update_appearance()
		return PROCESS_KILL

	var/line1 = "CARGO"
	var/line2
	if(!SSsupply.shuttle)
		// Might be missing in our first update on initialize before shuttles
		// have loaded. Cross our fingers that it will soon return.
		line1 = "shutl"
		line2 = "not in service"
	else if(SSsupply.shuttle.has_arrive_time())
		line2 = get_supply_shuttle_timer()
	else if (SSsupply.shuttle.is_launching())
		if(SSsupply.shuttle.at_station())
			line2 = "Launch"
		else
			line2 = "ETA"
	else
		if(SSsupply.shuttle.at_station())
			line2 = "Docked"
		else
			line1 = ""
			line2 = ""

	set_messages(line1, line2)

/obj/machinery/status_display/supply_display/receive_signal(datum/signal/signal)
	// we do not care about whatever signal got sent to us as we only do supply shuttle
	// and friendc only gets set in receive_signal
	return

