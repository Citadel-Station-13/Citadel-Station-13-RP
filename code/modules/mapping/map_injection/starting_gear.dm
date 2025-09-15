//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * collates starting gear datums for efficiency
 * used in middleware / injection model
 */
/proc/collate_map_starting_gear_packs(list/datum/map_starting_gear/packs)
	var/list/datum/map_starting_gear/distribute/distribute_packs = list()
	var/list/datum/map_starting_gear/role/role_packs_by_tag = list()

	. = list()

	// gather
	for(var/datum/map_starting_gear/pack in packs)
		if(istype(pack, /datum/map_starting_gear/distribute))
			var/datum/map_starting_gear/distribute/distribute_pack = pack
			distribute_packs += distribute_pack
		else if(istype(pack, /datum/map_starting_gear/role))
			var/datum/map_starting_gear/role/role_pack = pack
			LAZYINITLIST(role_packs_by_tag[role_pack.role_tag])
			role_packs_by_tag[role_pack.role_tag] += pack

	// collate role packs
	if(length(role_packs_by_tag))
		for(var/role in role_packs_by_tag)
			var/list/datum/map_starting_gear/role/role_packs = role_packs_by_tag[role]
			// make one for the role
			var/datum/map_starting_gear/role/collated = new
			collated.role_tag = role
			// gather all packs of that role
			for(var/datum/map_starting_gear/role/gather in role_packs)
				// slots: undefined behavior right now is get the highest max() of all slots
				if(!isnull(gather.slots))
					collated.slots = max(collated.slots, gather.slots)
				// values: numerical add
				merge_assoc_list_add_values_inplace(collated.gear, gather.gear)

	// collate distribute packs
	if(length(distribute_packs))
		// yeah we don't have a way to do this yet
		. += distribute_packs

/**
 * injects starting gear and equipment into maps.
 */
/datum/map_injection/starting_gear
	var/list/datum/map_starting_gear/gear_packs

/datum/map_injection/starting_gear/New(list/datum/map_starting_gear/packs)
	packs = collate_map_starting_gear_packs(packs)
	src.gear_packs = packs

/datum/map_injection/starting_gear/injection(datum/dmm_context/context)
	for(var/datum/map_starting_gear/pack as anything in gear_packs)
		pack.inject(context)
	return ..()

/datum/map_starting_gear

/datum/map_starting_gear/proc/inject(datum/dmm_context/context)
	CRASH("abstract proc called")

/**
 * used to inject a specific set of gear into the map
 */
/datum/map_starting_gear/distribute
	/// list of typepaths associated to amounts
	///
	/// special handling:
	/// * /datum/prototype/material = amount
	/// * /obj/item/stack = amount
	var/list/gear = list()
	/// gear tags to target
	///
	/// * most important to least
	var/list/gear_tags = list()
	/// usage tags to target
	///
	/// * most important to least
	var/list/usage_tags = list()

/datum/map_starting_gear/distribute/inject(datum/dmm_context/context)
	// todo: logging if ran out of room

	// find markers
	var/list/obj/map_helper/gear_marker/use_markers = list()
	var/current_matching_weight = 0

	for(var/obj/map_helper/gear_marker/distributed/potential_marker in context.distributed_gear_markers)
		var/match_weight = 0
		var/gear_match = FALSE
		var/usage_match = FALSE
		for(var/tag in gear_tags)
			if(potential_marker.gear_tags[tag])
				match_weight += global.distributed_gear_marker_gear_weights[tag] || 1
				gear_match = TRUE
		for(var/tag in usage_tags)
			if(potential_marker.usage_tags[tag])
				match_weight += global.distributed_gear_marker_usage_weights[tag] || 1
				usage_match = TRUE
		if(!usage_match && !potential_marker.use_can_be_overflow)
			continue
		if(!gear_match && !potential_marker.gear_can_be_overflow)
			continue
		if(match_weight == current_matching_weight)
			use_markers += potential_marker
		else if(match_weight > current_matching_weight)
			use_markers = list(potential_marker)
			current_matching_weight = match_weight
		else
			CRASH("what?")

	if(!length(use_markers))
		return

	// distribute amongst markers

	var/divisor = length(use_markers)
	var/list/divided_paths = list()
	var/list/fill_paths = list()

	for(var/typepath in gear)
		// no splitting stacks
		if(ispath(typepath, /datum/prototype/material) || ispath(typepath, /obj/item/stack))
			fill_paths[typepath] = gear[typepath]
			continue
		// cleanly split
		var/amount = gear[typepath]
		var/remainder = amount % divisor
		var/amount_per = round(amount / divisor)
		fill_paths[typepath] = remainder
		divided_paths[typepath] = amount_per

	// inject

	for(var/obj/map_helper/gear_marker/distributed/using_marker in use_markers)
		using_marker.inject(divided_paths)
	use_markers[1].inject(fill_paths)

/**
 * used to inject x roles of y gear into the map
 *
 * * does not support non-/item's right now. This is becuase we have no code to prevent density stacking.
 * * nor do we have code to not make dense objects spawn in things like lockers.
 */
/datum/map_starting_gear/role
	/// role tag to spawn at
	var/role_tag
	/// allow overflowing to other role tags?
	var/role_allow_overflow = FALSE
	/// list of typepaths associated to amounts
	///
	/// special handling:
	/// * /datum/prototype/material = amount
	/// * /obj/item/stack = amount
	var/list/gear = list()
	/// copies to spawn
	///
	/// * multiple sets of role starting gear with the same tag but different slot amounts is undefined behavior
	/// * null = fill the role tag
	/// * more than supported = overflow to other slots if possible
	var/slots

/datum/map_starting_gear/role/inject(datum/dmm_context/context)
	// todo: logging if ran out of room
	// 1. attempt to find proper role
	var/list/obj/map_helper/gear_marker/role/role_markers = context.role_markers_by_tag[role_tag]
	// if found
	if(length(role_markers))
		// fill as needed
		var/wanted_number = isnull(slots)? length(role_markers) : slots
		if(wanted_number < role_markers)
			// pick/choose
			role_markers = pick_n_from_list(role_markers, wanted_number)
		// spawn at
		for(var/obj/map_helper/gear_marker/role/marker in role_markers)
			marker.inject(gear)

	if(!role_allow_overflow)
		return

	// 2. wasn't found. are there overflows?
	// for overflows we must assert that we have N slots because otherwise we might fill everything
	ASSERT(isnum(slots) && slots > 0)
	var/list/obj/map_helper/gear_marker/role/overflow_markers = list()
	var/needed = slots
	for(var/role in context.role_markers_by_tag)
		for(var/obj/map_helper/gear_marker/role/potential_marker in context.role_markers_by_tag[role])
			if(!potential_marker.role_allow_overflow)
				continue
			needed--
			overflow_markers += potential_marker
			if(!needed)
				break
	// spawn at those
	for(var/obj/map_helper/gear_marker/role/marker in overflow_markers)
		marker.inject(gear)
