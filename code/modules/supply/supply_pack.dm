//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * a holder for a pack of objects that can be ordered
 *
 * todo: rename to supply_pack
 */
/datum/supply_pack2
	/// name of pack
	var/name = "Supply Pack"
	/// arbitrary category to group under
	var/category = "Miscellaneous"

	/// flags
	var/supply_pack_flags = NONE

	/// raw worth of everything in container
	///
	/// * if null, it will be autodetected.
	var/worth

	//* Container *//

	/// type of the container
	var/container_type = /obj/structure/closet/crate/plastic
	/// override name of container
	var/container_name
	/// override desc of container
	var/container_desc

	/// set access of container
	var/list/container_access
	/// set req one access of container
	var/list/container_one_access

	//* Contents *//

	/// contains these entity descriptors
	///
	/// * a descriptor associated to amount
	/// * a list of list("descriptor" = ..., "amount" = number, "descriptor_hint" (optional), "container_hint" (optional)), associated to amount
	var/list/contains
	/// contains some amount of these entity descriptor groups
	///
	/// * this should be a list of lists with "entities", "amount" as keys
	/// * "entities" should be associated to a list of entities as per [contains]
	/// * "amount" should be associated to a random amount of them to spawn
	/// * amount will be distrbuted randomly as needed, evenly, across the entities.
	var/list/contains_some
	/// a list of custom 'contains' lines that get printed to the manifest/interface
	var/list/contains_custom_text

	#warn contains, contains_some_of

	//* legacy *//
	var/legacy_cost = 5
	var/legacy_contraband = FALSE

/datum/supply_pack2/New(name, category, worth, flags)
	if(!isnull(name))
		src.name = name
	if(!isnull(category))
		src.category = category
	if(!isnull(worth))
		src.worth = worth
	if(!isnull(flags))
		src.supply_pack_flags = flags

/**
 * **Always call this before using it!**
 */
/datum/supply_pack2/proc/initialize()
	generate()

/datum/supply_pack2/proc/generate()
	if(isnull(worth))
		worth = detect_worth()
		if(!worth)
			stack_trace("pack [src] ([type]) failed to detect worth.")

/datum/supply_pack2/proc/detect_worth()
	CRASH("abstract proc called")

// todo: instantiation

/**
 * standard supply pack
 *
 * has a list of things to spawn, and spawns it.
 */
/datum/supply_pack2/standard
	/// list of typepaths associated to count
	///
	/// * if, /datum/material, count is handled as stack amount
	/// * if, /obj/item/stack, count is handled as stack amount
	/// * if an instance, count will be number of times to clone it with clone(TRUE).
	var/list/contains = list()

/datum/supply_pack2/standard/New(name, worth, list/contains)
	if(!isnull(contains))
		src.contains = contains.Copy()
	..()

/datum/supply_pack2/standard/detect_worth()
	. = 0
	for(var/path in contains)
		var/amount = contains[path]
		. += SSsupply.estimate_worth_of_product(path) * amount
