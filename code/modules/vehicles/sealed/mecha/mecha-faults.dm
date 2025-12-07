//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/proc/fault_process(dt)
	for(var/datum/mecha_fault/path as anything in mecha_fault_stacks)
		var/datum/mecha_fault/instance = GLOB.mecha_faults[path]
		instance.tick(src, mecha_fault_stacks[path], dt)

/obj/vehicle/sealed/mecha/proc/fault_add(datum/mecha_fault/path, stacks, limit)
	LAZYINITLIST(mecha_fault_stacks)
	#warn impl
	var/datum/vehicle_ui_controller/mecha/casted_controller = ui_controller
	casted_controller?.queue_update_ui_faults()

/obj/vehicle/sealed/mecha/proc/fault_remove(datum/mecha_fault/path, stacks = INFINITY)
	var/datum/vehicle_ui_controller/mecha/casted_controller = ui_controller
	#warn impl
	casted_controller?.queue_update_ui_faults()

/**
 * @return stacks
 */
/obj/vehicle/sealed/mecha/proc/fault_check(datum/mecha_fault/path)
	return mecha_fault_stacks?[path]
