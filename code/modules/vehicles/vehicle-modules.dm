//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/proc/initialize_modules()
	var/list/keeping = list()
	var/list/making = list()
	for(var/obj/item/vehicle_module/module_path as anything in 1 to length(modules))
		if(istype(module_path))
			keeping += module_path
		else
			// anonymous types / pops are allowed, don't actually treat as a path
			making += module_path
	modules = keeping
	for(var/obj/item/vehicle_module/module_path as anything in making)
		var/obj/item/vehicle_module/created = new module_path
		if(!install_module(created, null, TRUE, TRUE))
			// if you're reading this, make sure you're not trying to overrule
			// things that cannot be overruled with 'force' parameter.
			//
			// we generally use those for stability concerns so admins/mappers are not allowed
			// to overrule it.
			stack_trace("failed to install initial module [created] ([maybe_path]).")
			qdel(created)

/**
 * Destroy all modules
 */
/obj/vehicle/proc/destroy_all_modules()
	QDEL_LAZYLIST(modules)

/obj/vehicle/proc/can_install_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force)
	var/count_for_slot = 0
	var/slot_in_question = v_module.module_slot
	var/dupe_type = v_module.disallow_duplicates_match_type || type
	for(var/obj/item/vehicle_module/other as anything in modules)
		if(v_module.disallow_duplicates)
			if(istype(other, dupe_type))
				if(!silent)
					actor?.chat_feedback(
						SPAN_WARNING("There's already a module similar to [v_module] on [src]."),
						target = src,
					)
				return FALSE
		if(other.module_slot == slot_in_question)
			count_for_slot++
	var/is_full = count_for_slot > module_slots?[slot_in_question]
	. = can_fit_module(v_module, actor, silent)
	. = force || v_module.fits_on_vehicle(src, ., is_full, actor, silent)
	if(!.)
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[v_module] cannot fit on [src]!"),
				target = src,
			)

/obj/vehicle/proc/can_fit_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent)
	if((module_classes_required && !(module_classes_required & other)))
		return FALSE
	else if(module_classes_forbidden & v_module)
		return FALSE
	return TRUE

/obj/vehicle/proc/user_install_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor)
	if(actor)
		if(actor.performer && actor.performer.is_in_inventory(v_module))
			if(!actor.performer.can_unequip(v_module, v_module.worn_slot))
				actor.chat_feedback(
					SPAN_WARNING("[v_module] is stuck to your hand!"),
					target = src,
				)
				return FALSE
	if(!install_modular_component(v_module, actor))
		return FALSE
	// todo: better sound
	playsound(src, 'sound/weapons/empty.ogg', 25, TRUE, -3)
	return TRUE

/obj/vehicle/proc/user_uninstall_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, put_in_hands)
	if(v_module.intrinsic)
		actor?.chat_feedback(
			SPAN_WARNING("[v_module] is not removable."),
			target = src,
		)
		return FALSE
	var/obj/item/uninstalled = uninstall_module(v_module, actor, new_loc = src)
	if(put_in_hands && actor?.performer)
		actor.performer.put_in_hands_or_drop(uninstalled)
	else
		var/atom/where_to_drop = drop_location()
		ASSERT(where_to_drop)
		uninstalled.forceMove(where_to_drop)
	// todo: better sound
	playsound(src, 'sound/weapons/empty.ogg', 25, TRUE, -3)
	return TRUE

/**
 * * Moves the module into us if it isn't already.
 */
/obj/vehicle/proc/install_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	ASSERT(!v_module.vehicle)

	if(!can_install_module(v_module, actor, silent, force))
		return FALSE

	vehicle_log_for_admins(actor, "module-install", list(
		"module" = "[v_module]",
		"module-type" = v_module.type,
	))

	if(!silent)
		if(actor?.performer && !(actor.performer.loc == src) && actor.performer.Reachability(src))
			actor?.visible_feedback(
				target = src,
				visible = SPAN_NOTICE("[actor.performer] installs [v_module] onto [src]."),
				range = MESSAGE_RANGE_CONSTRUCTION,
			)
		else
			visible_message(
				SPAN_NOTICE("[v_module] is hoisted and installed onto [src]."),
				range = MESSAGE_RANGE_CONSTRUCTION,
			)
	if(v_module.loc != src)
		v_module.forceMove(src)

	v_module.vehicle = src
	LAZYADD(modules, v_module)
	v_module.on_install(src, actor, silent)
	on_module_attached(src, actor, silent)

/**
 * * deletes the module if no location is provided to move it to
 * @return uninstalled item
 */
/obj/vehicle/proc/uninstall_module(obj/item/vehicle_module/v_module, datum/event_args/actor/actor, silent, force, atom/new_loc) as /obj/item
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	ASSERT(v_module.vehicle == src)

	vehicle_log_for_admins(actor, "component-remove", list(
		"component" = "[v_module]",
		"component-type" = v_module.type,
	))

	v_module.vehicle = null
	LAZYREMOVE(modules, v_module)
	v_module.on_uninstall(src, actor, silent)
	on_module_detached(src, actor, silent)

	if(!silent)
		if(actor?.performer && !(actor.performer.loc == src) && actor.performer.Reachability(src))
			actor?.visible_feedback(
				target = src,
				visible = SPAN_NOTICE("[actor.performer] pulls [v_module] off of [src]."),
				range = MESSAGE_RANGE_CONSTRUCTION,
			)
		else
			visible_message(
				SPAN_NOTICE("[v_module] drops out of [src] with a clunk."),
				range = MESSAGE_RANGE_CONSTRUCTION,
			)

	if(new_loc)
		v_module.forceMove(new_loc)
		. = v_module
	else
		qdel(v_module)
		. = null

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
