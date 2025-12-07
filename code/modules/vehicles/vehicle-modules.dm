//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/proc/initialize_modules()
	#warn impl

/**
 * Destroy all modules
 */
/obj/vehicle/proc/destroy_all_modules()
	QDEL_LAZYLIST(modules)

/obj/vehicle/proc/can_install_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force)
	if(v_module.disallow_duplicates)
		var/dupe_type = v_module.disallow_duplicates_match_type || type
		for(var/obj/item/vehicle_module/other as anything in modules)
			if(istype(other, dupe_type))
				if(!silent)
					actor?.chat_feedback(
						SPAN_WARNING("There's already a module similar to [v_module] on [src]."),
						target = src,
					)
				return FALSE
	var/is_full
	#warn is_full
	. = can_fit_module(v_module, actor, silent)
	return force || v_module.fits_on_vehicle(src, ., is_full, actor, silent)

/obj/vehicle/proc/can_fit_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent)
	return TRUE

/obj/vehicle/proc/user_install_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor)
	#warn impl

/obj/vehicle/proc/user_uninstall_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, put_in_hands)
	#warn impl

/obj/vehicle/proc/install_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	ASSERT(!(v_module in modules))
	ASSERT(!v_module.vehicle)
	v_module.vehicle = src
	LAZYADD(modules, v_module)
	v_module.on_install(src, actor, silent)
	on_module_attached(src, actor, silent)

/obj/vehicle/proc/uninstall_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force, atom/new_loc) as /obj/item/vehicle_module
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	ASSERT(v_module in modules)
	ASSERT(v_module.vehicle == src)
	v_module.vehicle = null
	LAZYREMOVE(modules, v_module)
	v_module.on_uninstall(src, actor, silent)
	on_module_detached(src, actor, silent)

/obj/vehicle/proc/on_module_attached(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	cached_module_weight += v_module.get_weight()
	ui_controller?.queue_update_module_refs()
	ui_controller?.queue_update_weight_data()

/obj/vehicle/proc/on_module_detached(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	cached_module_weight += v_module.get_weight()
	ui_controller?.queue_update_module_refs()
	ui_controller?.queue_update_weight_data()

/**
 * * Allowed to return nulls, including for the list itself
 * * Returned list will never be modified.
 */
/obj/vehicle/proc/query_repair_droid_modules_immutable() as /list
	return modules

/**
 * @return list of modules
 */
/obj/vehicle/proc/query_active_click_modules() as /list
	. = list()
	for(var/obj/item/vehicle_module/module as anything in modules)
		if(module.is_active_click_module())
			. += module

/**
 * @return TRUE for success, FALSE otherwise
 */
/obj/vehicle/proc/set_active_click_module(obj/item/vehicle_module/module, silent)
	if(module.vehicle == src)
		module_active_click = module
		return TRUE
	return FALSE

/**
 * @return new module or null
 */
/obj/vehicle/proc/cycle_active_click_modules(allow_deselect = TRUE, silent) as /obj/item/vehicle_module
	var/current_index = module_active_click ? modules.Find(module_active_click) : 0
	var/obj/item/vehicle_module/next
	for(var/i in current_index + 1 to length(modules))
		var/obj/item/vehicle_module/potential = modules[i]
		if(potential.is_active_click_module())
			next = potential
			break
	if(!next && !allow_deselect)
		for(var/i in 1 to current_index)
			var/obj/item/vehicle_module/potential = modules[i]
			if(potential.is_active_click_module())
				next = potential
				break
	module_active_click = next
	return next
