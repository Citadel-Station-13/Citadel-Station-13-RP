//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_OVERMAPS

	/// overmap by id
	//  todo: recover
	var/static/list/datum/overmap/overmap_by_id = list()

	/// im so sorry bros dont hurt me please--
	/// (eventually we'll have proper bindings but for now, uh, this is how it is!)
	var/const/default_overmap_id = "main"

	//* Global Tuning *//

	/// applied to all ship thrust
	var/global_thrust_multiplier = 2

/datum/controller/subsystem/overmaps/Initialize()
	make_default_overmap()
	rebuild_helm_computers()
	return SS_INIT_SUCCESS

// the last vestige of legacy code in the overmaps subsystem
// this tells helm computers to update their sectors
// this is needed when a new sector is added.
/datum/controller/subsystem/overmaps/proc/rebuild_helm_computers()
	for(var/obj/machinery/computer/ship/helm/H in GLOB.machines)
		H.get_known_sectors()

// queues a rebuild_helm_computers(), as it's very expensive to run.
/datum/controller/subsystem/overmaps/proc/queue_helm_computer_rebuild()
	if(!initialized)
		return
	addtimer(CALLBACK(src, PROC_REF(rebuild_helm_computers)), 0, TIMER_UNIQUE)

//* Overmap Management *//

/**
 * i don't know what to put here
 * this isn't a good long-term proc but for now it's fine
 */
/datum/controller/subsystem/overmaps/proc/get_or_load_default_overmap()
	if(overmap_by_id[default_overmap_id])
		return overmap_by_id[default_overmap_id]
	make_default_overmap()
	return overmap_by_id[default_overmap_id]


/datum/controller/subsystem/overmaps/proc/make_default_overmap()
	if(overmap_by_id[default_overmap_id])
		return
	var/datum/map/station/map_datum = SSmapping.loaded_station
	if(!map_datum.use_overmap)
		return
	var/datum/overmap_template/legacy_default/using_default_template = new(map_datum.overmap_size, map_datum.overmap_size, event_clouds = map_datum.overmap_event_areas)
	create_overmap_from_template(using_default_template, default_overmap_id)

/datum/controller/subsystem/overmaps/proc/create_overmap_from_template(datum/overmap_template/templatelike, use_id)
	if(ispath(templatelike))
		templatelike = new templatelike
	// make sure template is valid
	ASSERT(istype(templatelike))
	// get template into another var
	var/datum/overmap_template/template = templatelike
	// get id or generate
	var/id = use_id || generate_overmap_id()
	ASSERT(!overmap_by_id[id])
	// make overmap
	var/datum/overmap/creating = new(id, template)
	// instantiation
	creating.initialize()
	// done
	return creating

/datum/controller/subsystem/overmaps/proc/generate_overmap_id()
	var/potential
	var/safety = 1000
	do
		if(safety-- <= 0)
			CRASH("failed to generate overmap id - too many loops")
		potential = "[SSmapping.round_global_descriptor && "[SSmapping.round_global_descriptor]-"][copytext(md5("[rand(1, 1000000)]"), 1, 5)]"
	while(overmap_by_id[potential])
	return potential
