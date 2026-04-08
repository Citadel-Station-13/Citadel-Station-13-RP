//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

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
