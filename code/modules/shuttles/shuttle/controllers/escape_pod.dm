//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

// todo: all this should be in SSshuttles maybe?

GLOBAL_LIST_EMPTY(escape_pod_controllers)

/proc/arm_escape_pods(list/z_indices)
	. = 0
	for(var/datum/shuttle_controller/escape_pod/controller in GLOB.escape_pod_controllers)
		if(!(controller.get_current_z_index() in z_indices))
			continue
		controller.arm()
		++.

/proc/launch_escape_pods(list/z_indices)
	. = 0
	for(var/datum/shuttle_controller/escape_pod/controller in GLOB.escape_pod_controllers)
		if(!(controller.get_current_z_index() in z_indices))
			continue
		controller.launch()
		++.

/datum/shuttle_controller/escape_pod
	tgui_module = "TGUIShuttleEscapePod"

	/// armed?
	var/armed = FALSE
	/// launched?
	var/launched = FALSE

/datum/shuttle_controller/escape_pod/New(datum/shuttle/shuttle)
	..()
	GLOB.escape_pod_controllers += src

/datum/shuttle_controller/escape_pod/Destroy()
	GLOB.escape_pod_controllers -= src
	return ..()

/datum/shuttle_controller/escape_pod/proc/arm()
	if(!armed)
		return
	armed = TRUE

/datum/shuttle_controller/escape_pod/proc/launch()
	arm()
	if(launched)
		return
	launched = TRUE

	// todo: better escape pod behavior; this should start a proper transit cycle with no destination
	// immediate move to transit as we wait for round-end.
	shuttle.immediately_jump_to_transit()
