//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

SUBSYSTEM_DEF(research)
	name = "Research"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_RESEARCH

	//? designs
	/// design lookup id = instance
	var/list/design_lookup

	//? designs - caches
	/// cached autolathe desgin ids
	var/list/autolathe_design_ids

/datum/controller/subsystem/research/Initialize()
	build_designs()
	return ..()

/datum/controller/subsystem/research/Recover()
	design_lookup = SSresearch.design_lookup
	autolathe_design_ids = SSresearch.autolathe_design_ids
	return ..()

/datum/controller/subsystem/research/proc/build_designs()
	design_lookup = list()
	autolathe_design_ids = list()
	for(var/datum/design/path as anything in subtypesof(/datum/design))
		if(initial(path.abstract_type) == path)
			continue
		path = new path
		if(design_lookup[path.id])
			qdel(path)
			continue
		if(!register_design(path))
			stack_trace("failed to register [path]")
			qdel(path)

/**
 * shove a design into lookup for the round
 *
 * you should know what you are doing before trying this
 * make sure you drop all references of the design from your end!
 */
/datum/controller/subsystem/research/proc/register_design(datum/design/registering)
	if(design_lookup[registering.id])
		return FALSE
	. = TRUE
	design_lookup[registering.id] = registering
	if((registering.lathe_type & LATHE_TYPE_AUTOLATHE) && (registering.design_unlock & DESIGN_UNLOCK_INTRINSIC))
		autolathe_design_ids += registering.id

/**
 * gets a design datum
 *
 * *do not* modify the datum returned!
 */
/datum/controller/subsystem/research/proc/fetch_design(datum/design/id_or_typepath)
	RETURN_TYPE(/datum/design)
	return design_lookup[ispath(id_or_typepath)? initial(id_or_typepath.id) : id_or_typepath]

/**
 * gets a list of design datums by id or typepath
 *
 * *do not* modify the datums returned!
 */
/datum/controller/subsystem/research/proc/fetch_designs(list/datum/design/id_or_typepaths)
	RETURN_TYPE(/list)
	. = list()
	var/datum/design/thing
	for(thing as anything in id_or_typepaths)
		thing = design_lookup[ispath(thing)? initial(thing.id) : thing]
		if(isnull(thing))
			continue
		. += thing
