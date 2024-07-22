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

	/// raw worth of everything in pack
	///
	/// * if null, it will be autodetected.
	var/worth
	/// raw worth of non-deterministic parts of pack
	///
	/// * required for non-deterministic packs if you don't want to hard-set worth
	var/worth_additional

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
	/// * don't be fooled; this **is** a lazy list! this means it's null while empty.
	/// * a descriptor associated to amount
	/// * a list of list("descriptor" = ..., "amount" = number, "descriptor_hint" (optional), "container_hint" (optional)), associated to amount
	var/list/contains = list()
	/// contains some amount of these entity descriptor groups
	///
	/// * don't be fooled; this **is** a lazy list! this means it's null while empty.
	/// * this should be a list of lists with "entities", "amount" as keys
	/// * "entities" should be associated to a list of entities as per [contains]; the entity can be associated to a number for weight
	/// * "amount" should be associated to a random amount of them to spawn
	/// * amount will be distrbuted randomly as needed, evenly, across the entities.
	var/list/contains_some = list()
	/// a list of custom 'contains' lines that get printed to the manifest/interface
	///
	/// * don't be fooled; this **is** a lazy list! this means it's null while empty.
	var/list/contains_custom_text = list()

	// * For Lazy People *//

	/// amount contained
	var/lazy_gacha_amount = 1
	/// list of entities
	var/list/lazy_gacha_contained

	//* legacy *//
	/// if null, it will be auto-converted from worth
	var/legacy_cost
	var/legacy_contraband = FALSE
	/// literally just a flag so the subsystem picks it up
	var/legacy = FALSE

/**
 * **Always call this before using it!**
 */
/datum/supply_pack2/proc/initialize()
	populate()
	generate()
	compact()

/**
 * use this to manipulate our contents before generation.
 */
/datum/supply_pack2/proc/populate()
	return

/datum/supply_pack2/proc/generate()
	// resolve accesses
	for(var/i in 1 to length(container_access))
		var/key = container_access[i]
		if(ispath(key, /datum/access))
			var/datum/access/resolved_access = SSjob.access_path_lookup[key]
			container_access[i] = resolved_access.access_value
	// auto-detect worth
	if(isnull(worth))
		worth = detect_worth()
		if(!worth)
			stack_trace("pack [src] ([type]) failed to detect worth.")
	// legacy
	if(isnull(legacy_cost))
		legacy_cost = ceil(worth * 0.02)

/datum/supply_pack2/proc/compact()
	LAZYCLEARLIST(contains)
	LAZYCLEARLIST(contains_some)
	LAZYCLEARLIST(contains_custom_text)

/datum/supply_pack2/proc/detect_worth()
	. = 0

	// if non-deterministic, must need that
	if(length(contains_some) || length(contains_custom_text))
		if(isnull(worth_additional))
			. = INFINITY
			CRASH("attempted to generate worth on a non-deterministic crate (has contains_some or contains_custom_text); fix this.")
	// add worth additional
	. += worth_additional

	// container
	if(container_type)
		. += SSsupply.value_entity_via_descriptor(container_type)

	// deterministic contents
	for(var/descriptor as anything in contains)
		var/amount = contains[descriptor]
		var/worth
		if(islist(descriptor))
			var/list/descriptor_list = descriptor
			#warn impl
		else
			worth = SSsupply.value_entity_via_descriptor(descriptor)
		. += worth * amount

#warn instantiation
