//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR(belter_shuttle, /belter_shuttle, "Belter Shuttle")

/obj/shuttle_dock/ferry_pair/round_global/belter_shuttle
	ferry_init_kick_to_home = TRUE

/datum/shuttle_controller/ferry/round_global/belter_shuttle
	var/belter_rebuilding = FALSE

/datum/shuttle_controller/ferry/round_global/belter_shuttle
	#warn block movement if rebuilding

/datum/shuttle_controller/ferry/round_global/belter_shuttle/proc/belter_start_rebuild()
	if(belter_rebuilding)
		return
	belter_rebuilding = TRUE
	if(!is_at_home())
		transit_towards_home(0 SECONDS)
		if(!is_at_home())
			stack_trace("belter didn't go home immediately on rebuild start.")

/datum/shuttle_controller/ferry/round_global/belter_shuttle/proc/belter_stop_rebuild()
	if(!belter_rebuilding)
		return
	belter_rebuilding = FALSE
