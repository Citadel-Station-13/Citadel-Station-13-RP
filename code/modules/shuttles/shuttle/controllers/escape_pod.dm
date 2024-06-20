//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

// todo: all this should be in SSshuttles?

GLOBAL_LIST_EMPTY(escape_pod_controllers)

/proc/arm_escape_pods(list/z_indices)
	#warn impl

/proc/launch_escape_pods(list/z_indices)
	#warn impl

/datum/shuttle_controller/escape_pod
	tgui_module = "TGUIShuttleEscapePod"

	/// armed?
	var/armed = FALSE
	/// launched?
	var/launched = FALSE

/datum/shuttle_controller/escape_pod/proc/arm()
	if(!armed)
		return


/datum/shuttle_controller/escape_pod/proc/launch()
	arm()
	if(launched)
		return
	launched = TRUE

	// todo: better escape pod behavior
	// immediate move to transit as we wait for round-end.
	shuttle.prepare_transit()
	shuttle.dock(shuttle.transit_reservation.transit_dock, centered = TRUE)
