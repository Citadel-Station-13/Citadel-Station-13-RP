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
			distribute_packs += pack
		else if(istype(pack, /datum/map_starting_gear/role))
			LAZYINITLIST(role_packs_by_tag[pack.role_tag])
			role_packs_by_tag[pack.role_tag] += pack

	#warn impl

/**
 * injects starting gear and equipment into maps.
 */
/datum/map_injection/starting_gear

/datum/map_injection/starting_gear/New(list/datum/map_starting_gear/packs)
	packs = collate_map_starting_gear_packs(packs)

/datum/map_injection/starting_gear/injection(datum/dmm_context/context)
	return ..()

#warn impl all

/**
 * used to inject a specific set of gear into the map
 */
/datum/map_starting_gear/distribute
	/// list of typepaths associated to amounts
	///
	/// special handling:
	/// * /datum/material = amount
	/// * /obj/item/stack = amount
	var/list/gear = list()


/**
 * used to inject x roles of y gear into the map
 */
/datum/map_starting_gear/role
	/// role tag to spawn at
	var/role_tag
	/// list of typepaths associated to amounts
	///
	/// special handling:
	/// * /datum/material = amount
	/// * /obj/item/stack = amount
	var/list/gear = list()
	/// copies to spawn
	///
	/// * multiple sets of role starting gear with the same tag but different slot amounts is undefined behavior
	/// * null = fill the role tag
	/// * more than supported = overflow to other slots if possible
	var/slots

