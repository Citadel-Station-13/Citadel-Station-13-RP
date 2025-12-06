//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * @return amount drawn
 */
/obj/vehicle/proc/draw_module_power_oneoff(obj/item/vehicle_module/module, joules)
	return 0

// TODO: register_module_power

/**
 * @return amount drawn
 */
/obj/vehicle/proc/draw_component_power_oneoff(obj/item/vehicle_component/component, joules)
	return 0

// TODO: register_component_power

/**
 * @return amount drawn
 */
/obj/vehicle/proc/draw_sourced_power_oneoff(source, name, joules)
	return 0

// TODO: register_sourced_power

/obj/vehicle/inducer_scan(obj/item/inducer/I, list/things_to_induce, inducer_flags)
	// yeah nah no inducers
	return
