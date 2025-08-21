//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * re-implementation of virgo's PAT module
 * TODO: mechanic to restrain this to certain accesses (shouldn't work on offmaps)
 * TODO: mechanic to disable this via networks / station mainframe
 * TODO: for now this only works on doors but this can be expanded, maybe.
 * TODO: intelligent screentips system should support this when that's made
 */
/obj/item/access_tunneler
	name = "access tunneler"
	desc = "Used by medical staff aboard some facilities to override access locks in times of need \
	with pre-encoded keys. This will alert the security team when used. "

	/// starting cell type
	var/starting_cell_type

	/// charge cost for overrides in kj
	var/energy_cost = 100 // 50 cell units
	/// charge cost for things in active cache
	var/energy_cost_active = 10 // 5 cell units

	/// allow door-likes
	var/allow_doors = TRUE

	/// atom ref associated to expiration; recently overridden entities will not use more power
	/// * lazy list
	var/list/active_cache
	/// memory span
	var/active_cache_time = 1 MINUTES

	/// override delay
	var/override_delay = 6 SECONDS
	/// override delay on things in active cache
	var/override_delay_active = 1 SECONDS

/obj/item/access_tunneler/Initialize(mapload)
	. = ..()
	init_cell_slot_easy_tool(starting_cell_type, TRUE, FALSE)

/obj/item/access_tunneler/Destroy()
	active_cache = null
	return ..()

/obj/item/access_tunneler/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("Overridden devices will be stored in an internal cache for [round(active_cache_time * 0.1, 0.1)] seconds, allowing them to be re-entered with less delay and power use.")

#warn impl

/obj/item/access_tunneler/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	// we check down below but let's type filter anyways
	if(allow_doors && istype(target, /obj/machinery/door))
		access_override(target, clickchain)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/access_tunneler/proc/access_override(atom/target, datum/event_args/actor/actor, silent, suppressed)
	if(istype(target, /obj/machinery/door))
		return access_override_door(target, actor, silent)
	// TODO: probably emit a message if it's a machine instead of silently ignoring it
	return FALSE

/obj/item/access_tunneler/proc/access_override_door(obj/machinery/door/door, datum/event_args/actor/actor, silent, suppressed)
	if(!door.can_open())
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[door]'s interface rejects the request. It might be locked or non-functional."),
				target = src,
			)
		return FALSE
	if(!standard_access_override(door, actor, silent))
		return FALSE
	door.open()
	return TRUE

/obj/item/access_tunneler/proc/standard_access_override(atom/target, datum/event_args/actor/actor, silent, suppressed, delay)
	if(isnull(delay))
		delay = override_delay
	// technically vulnerable to ref collision but what are the chances?
	var/target_ref = REF(target)
	// prune cache before reading
	// entries are always latest at the bottom
	if(active_cache)
		var/first_valid_entry
		for(first_valid_entry in 1 to length(active_cache))
			var/cache_ref = active_cache[i]
			var/cache_time = active_cache[cache_ref]
			if(cache_time >= world.time - active_cache_time)
				break
		if(first_valid_entry != 1)
			active_cache.Cut(1, first_valid_entry)
	var/is_cached = active_cache?[target_ref]
	if(is_cached)
		suppressed = TRUE
		delay = override_delay_active
	if(delay)
		#warn feedback
	if(!do_after(actor.performer, delay, target, NONE, MOBILITY_CAN_USE))
		return FALSE
	if(delay)
	else
		#warn feedback
	if(!active_cache)
		active_cache = list()
	if(is_cached)
		// elevate by removing, so it's always at the end
		active_cache -= target_ref
	active_cache[REF(target)] = world.time
	on_access_override(target, actor, silent, suppressed)
	return TRUE

/obj/item/access_tunneler/proc/on_access_override(atom/target, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!suppressed)
		var/username = FindNameFromID(actor.performer) || "Unknown"
		var/area/target_area = get_area(target)
		// TODO: describe more...
		var/message = "[username] has overridden [target] [target_area ? "in [target_area.get_display_name()]" : ""] with \the [src]."
		GLOB.global_announcer.autosay(message, "Security Subsystem", "Command")
		GLOB.global_announcer.autosay(message, "Security Subsystem", "Security")
	if(!silent)
		actor?.chat_feedback(
			SPAN_NOTICE("You connect [src] to [target], overriding its authentication mechanisms."),
			target = target,
		)

/obj/item/access_tunneler/proc/has_energy_for(atom/target)

/obj/item/access_tunneler/proc/use_energy(amount)

/obj/item/access_tunneler/with_cell
	starting_cell_type = /obj/item/cell/device

#warn impl
