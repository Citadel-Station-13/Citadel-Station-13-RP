//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

GLOBAL_LIST_INIT(supply_shuttle_forbidden_atom_typecache, cached_typecacheof(list(
	/obj/item/disk/nuclear,
	/obj/machinery/nuclearbomb,
	/obj/item/radio/beacon,
	/obj/item/perfect_tele_beacon,
	/mob/living,
)))

DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR(supply_shuttle, /supply_shuttle, "Supply Shuttle")

/datum/shuttle_controller/ferry/round_global/supply_shuttle
	transit_time_home = 2 MINUTES
	transit_time_away = 2 MINUTES

#warn make sure api didn't change for this proc
/datum/shuttle_controller/ferry/round_global/supply_shuttle/on_transit_begin(datum/shuttle_transit_cycle/cycle, redirected)
	..()
	// Set the supply shuttle displays to read out the ETA
	var/datum/signal/S = new()
	S.source = src
	S.data = list("command" = "supply")
	var/datum/radio_frequency/F = radio_controller.return_frequency(1435)
	F.post_signal(src, S)

/**
 * @return TRUE if forbiden atoms detected, FALSE otherwise
 */
/datum/shuttle_controller/ferry/round_global/supply_shuttle/proc/has_forbidden_atoms()
	for(var/turf/T as anything in shuttle.aabb_ordered_turfs_here())
		if(!shuttle.areas[T.loc])
			continue
		// TODO: this needs to be faster.
		var/list/forbidden = T.get_all_contents_filtered(GLOB.supply_shuttle_forbidden_atom_typecache)
		if(length(forbidden))
			return TRUE
	return FALSE

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
