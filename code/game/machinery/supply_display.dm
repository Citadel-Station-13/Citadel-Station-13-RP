/obj/machinery/status_display/supply_display
	ignore_friendc = TRUE

/obj/machinery/status_display/supply_display/update()
	if(!..() && mode == STATUS_DISPLAY_CUSTOM)
		message1 = "CARGO"
		message2 = ""

		var/datum/shuttle_controller/ferry/cargo/controller = GLOB.legacy_cargo_shuttle_controller
		if(!controller)
			message2 = "Error"
		else if(controller.!!get_transit_stage())
			message2 = get_supply_shuttle_timer()
			if(length(message2) > CHARS_PER_LINE)
				message2 = "Error"
		else if(controller.get_transit_stage() == SHUTTLE_TRANSIT_STAGE_TAKEOFF)
			if(controller.is_at_away())
				message2 = "Launch"
			else
				message2 = "ETA"
		else
			if(controller.is_at_away())
				message2 = "Docked"
			else
				message1 = ""
		update_display(message1, message2)
		return TRUE
	return FALSE

/obj/machinery/status_display/supply_display/receive_signal(datum/signal/signal)
	if(signal.data["command"] == "supply")
		mode = STATUS_DISPLAY_CUSTOM
	else
		..(signal)
