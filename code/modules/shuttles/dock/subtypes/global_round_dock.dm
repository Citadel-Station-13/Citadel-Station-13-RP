//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Declarations for global round docks.
 * * These are technically against 'server design' but like, the server's still unfortunately
 *   round based.
 */
DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR(escape_shuttle, /escape_shuttle, "Escape Shuttle")

DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR(supply_shuttle, /supply_shuttle, "Supply Shuttle")
#warn make sure api didn't change for these two procs
/obj/shuttle_dock/ferry_pair/round_global/supply_shuttle/home/on_shuttle_departed(datum/shuttle/shuttle, datum/event_args/shuttle/dock/departed/e_args)
	..()
	if(shuttle.controller != GLOB.global_ferry_supply_shuttle_controller)
		return
	SSsupply.buy()

/obj/shuttle_dock/ferry_pair/round_global/supply_shuttle/home/on_shuttle_landed(datum/shuttle/shuttle, datum/event_args/shuttle/dock/arrived/e_args)
	..()
	if(shuttle.controller != GLOB.global_ferry_supply_shuttle_controller)
		return
	SSsupply.sell()

DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR(belter_shuttle, /belter_shuttle, "Belter Shuttle")
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

/datum/shuttle_controller/ferry/round_global/belter_shuttle/proc/belter_stop_rebuild()
	if(!belter_rebuilding)
		return
	belter_rebuilding = FALSE
