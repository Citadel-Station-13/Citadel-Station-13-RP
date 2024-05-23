/datum/shuttle_controller/escape_pod
	tgui_module = "TGUIShuttleEscapePod"

/datum/shuttle_controller/escape_pod/proc/launch()
	// todo: better escape pod behavior
	// immediate move to transit as we wait for round-end.
	shuttle.move_to_transit()
