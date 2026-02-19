//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * tests all peripherals & components are linked
 *
 * * duplicate controllers are auto-tested this way, because two controllers
 *   will null out the controller on the network
 */
/datum/map_test/airlock_linkage_test

/datum/map_test/airlock_linkage_test/run_test(list/z_indices)
	for(var/obj/machinery/airlock_peripheral/peripheral in GLOB.machines)
		if(peripheral.controller)
			continue
		error_loc(get_turf(peripheral), peripheral, "no linked controller")
	for(var/obj/machinery/airlock_component/component in GLOB.machines)
		if(component.network.controller)
			continue
		error_loc(get_turf(component), component, "no linked controller")
