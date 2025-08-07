//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * a holder for a pack of objects that can be ordered
 *
 * todo: rename to supply_pack
 */
/datum/supply_pack
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
	/// * a list of list("entity" = ..., "amount" = number, "entity_hint" (optional), "container_hint" (optional)), associated to amount
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
/datum/supply_pack/proc/initialize()
	populate()
	generate()
	compact()

/**
 * use this to manipulate our contents before generation.
 */
/datum/supply_pack/proc/populate()
	return

/datum/supply_pack/proc/generate()
	// resolve accesses
	for(var/i in 1 to length(container_access))
		var/key = container_access[i]
		if(ispath(key, /datum/access))
			var/datum/access/resolved_access = SSjob.access_path_lookup[key]
			container_access[i] = resolved_access.access_value
	for(var/i in 1 to length(container_one_access))
		var/key = container_one_access[i]
		if(ispath(key, /datum/access))
			var/datum/access/resolved_access = SSjob.access_path_lookup[key]
			container_one_access[i] = resolved_access.access_value
	// auto-detect worth
	if(isnull(worth))
		worth = detect_worth()
		if(!worth)
			stack_trace("pack [src] ([type]) failed to detect worth.")
	// autoset container name
	if(isnull(container_name))
		container_name = name
	// gacha
	if(length(lazy_gacha_contained) && lazy_gacha_amount)
		contains_some[++contains_some.len] = list(
			"entities" = lazy_gacha_contained,
			"amount" = lazy_gacha_amount,
		)
		lazy_gacha_contained = null
	// legacy
	if(isnull(legacy_cost))
		legacy_cost = ceil(worth * 0.06)

/datum/supply_pack/proc/compact()
	if(!length(contains))
		contains = null
	if(!length(contains_some))
		contains_some = null
	if(!length(contains_custom_text))
		contains_custom_text = null

/datum/supply_pack/proc/detect_worth()
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
		var/amount = contains[descriptor] || 1
		var/worth
		if(islist(descriptor))
			var/list/descriptor_list = descriptor
			worth = SSsupply.value_entity_via_descriptor(
				descriptor_list["entity"],
				descriptor_list["amount"],
				descriptor_list["entity_hint"],
				descriptor_list["container_hint"],
			)
		else
			worth = SSsupply.value_entity_via_descriptor(descriptor, amount)
		. += worth

/**
 * todo: return list of entities?
 * 
 * @return container spawned, or null (which can also mean we don't use a container for some reason)
 */
/datum/supply_pack/proc/instantiate_pack_at(atom/where)
	. = instantiate_container(where)
	instantiate_contents(.)

/datum/supply_pack/proc/instantiate_container(atom/where)
	RETURN_TYPE(/atom/movable)

	if(!container_type)
		return

	var/atom/movable/container = new container_type(where)
	. = container

	container.name = container_name
	container.desc = container_desc

	if(isobj(container))
		var/obj/obj_container = container
		if(container_access)
			//  todo: getter / setter for req-accesses, enforced cached & deduped lists
			obj_container.req_access = container_access.Copy()
		if(container_one_access)
			//  todo: getter / setter for req-accesses, enforced cached & deduped lists
			obj_container.req_one_access = container_one_access.Copy()

/**
 * todo: return list of entities?
 */
/datum/supply_pack/proc/instantiate_contents(atom/where)
	var/list/descriptors_to_spawn = resolve_contents_descriptors()
	for(var/descriptor in descriptors_to_spawn)
		var/amount = descriptors_to_spawn[descriptor] || 1
		SSsupply.instantiate_entity_via_descriptor(descriptor, amount, null, null, where)

/**
 * @return list of descriptor associated to amount
 */
/datum/supply_pack/proc/resolve_contents_descriptors()
	. = contains? contains.Copy() : list()

	if(length(contains_some))
		for(var/list/entry as anything in contains_some)
			var/list/entities = entry["entities"]
			var/amount = entry["amount"]

			// this is basically an inlined pickweight()

			var/total_weight = 0
			for(var/key in entities)
				total_weight += entities[key] || 1

			if(total_weight == length(entities))
				for(var/i in 1 to amount)
					.[pick(entities)] += 1
			else
				for(var/i in 1 to amount)
					var/chosen = rand(1, total_weight)
					var/remaining = chosen
					for(var/j in 1 to length(entities))
						var/entity = entities[j]
						var/weight = entities[entity]
						remaining -= weight
						if(remaining <= 0)
							.[entity] += 1

//* LEGACY CRAP *//

/**
 * generates our HTML manifest as a **list**
 *
 * argument is provided for container incase you want to modify based on what actually spawned
 */
/datum/supply_pack/proc/get_html_manifest(atom/movable/container)
	RETURN_TYPE(/list)
	var/list/lines = list()
	lines += "Contents:<br>"
	lines += "<ul>"
	var/list/assembled = list()
	var/truncated = FALSE
	for(var/atom/movable/thing in container)
		assembled["[thing]"] += 1
		if(length(assembled) > 100)
			truncated = TRUE
			break
	for(var/i in 1 to length(assembled))
		var/key = assembled[i]
		var/value = assembled[key]
		assembled[i] = "<li>[value > 1? "[value] [key](s)" : "[key]"]</li>"
	lines += assembled
	if(truncated)
		lines += "<li>... (truncated)</li>"
	lines += "</ul>"
	return lines

/datum/supply_pack/proc/nanoui_manifest_list()
	. = list()
	for(var/descriptor in contains)
		var/amount = contains[descriptor]
		var/described = SSsupply.describe_entity_via_descriptor(descriptor, amount)
		. += described
	for(var/list/gacha_list as anything in contains_some)
		var/list/entities = gacha_list["entities"]
		for(var/entity in entities)
			var/described = SSsupply.describe_entity_via_descriptor(entity)
			. += described

/datum/supply_pack/proc/nanoui_is_random()
	return !!length(contains_some)
