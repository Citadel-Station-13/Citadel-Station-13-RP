//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/proc/fault_process(dt)
	for(var/datum/mecha_fault/path as anything in mecha_fault_stacks)
		if(!path.requires_ticking)
			continue
		var/datum/mecha_fault/instance = GLOB.mecha_faults[path]
		instance.tick(src, mecha_fault_stacks[path], dt)

/**
 * * May be fed path or instance.
 */
/obj/vehicle/sealed/mecha/proc/fault_add(datum/mecha_fault/resolve, stacks, limit)
	if(stacks <= 0)
		return
	if(!mecha_fault_stacks)
		mecha_fault_stacks = list()
	var/datum/mecha_fault/resolved = istype(resolve) ? resolve : GLOB.mecha_faults[resolve]
	var/old_stacks = mecha_fault_stacks?[resolve.type]
	var/new_stacks = max(0, old_stacks + stacks)
	mecha_fault_stacks[resolve.type] = new_stacks
	if(!old_stacks)
		resolved.on_apply(src)
	resolved.on_stack_change(src, old_stacks, new_stacks)
	var/datum/vehicle_ui_controller/mecha/casted_controller = ui_controller
	casted_controller?.queue_update_ui_faults()

/**
 * * May be fed path or instance.
 */
/obj/vehicle/sealed/mecha/proc/fault_remove(datum/mecha_fault/resolve, stacks = INFINITY)
	if(stacks <= 0)
		return
	var/old_stacks = mecha_fault_stacks?[resolve.type]
	if(!old_stacks)
		return
	var/datum/mecha_fault/resolved = istype(resolve) ? resolve : GLOB.mecha_faults[resolve]
	var/new_stacks = max(0, old_stacks - stacks)
	resolved.on_stack_change(src, old_stacks, new_stacks)
	if(!new_stacks)
		resolved.on_remove(src)
		mecha_fault_stacks -= resolve.type
		if(!length(mecha_fault_stacks))
			mecha_fault_stacks = null
	else
		mecha_fault_stacks[resolve.type] = new_stacks
	var/datum/vehicle_ui_controller/mecha/casted_controller = ui_controller
	casted_controller?.queue_update_ui_faults()

/**
 * * May be fed path or instance.
 * @return stacks
 */
/obj/vehicle/sealed/mecha/proc/fault_check(datum/mecha_fault/resolve)
	return mecha_fault_stacks?[resolve.type]
