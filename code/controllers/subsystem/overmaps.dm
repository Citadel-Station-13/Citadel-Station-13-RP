//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

SUBSYSTEM_DEF(overmaps)
	name = "Overmaps"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_OVERMAPS

	//* Overmaps *//

	/// overmap by id
	//  todo: recover
	var/static/list/datum/overmap/overmap_by_id = list()
	/// im so sorry bros dont hurt me please--
	/// (eventually we'll have proper bindings but for now, uh, this is how it is!)
	var/const/default_overmap_id = "main"

	//* Overmap Entities *//

	/// Initialize queue of callbacks
	var/list/datum/callback/entity_initialize_queue = list()

	//*                    Global Tuning                       *//
	//* Balance tuning goes in here; not sim                   *//
	//* Example: 'thrust mult' is balance, 'sim speed' is sim. *//
	/// applied to all ship thrust
	var/global_thrust_multiplier = 2

	//* Level System *//

	/// Z-level ownership lookup
	///
	/// * This is an indexed list of z-levels, with the entry being the owning /datum/overmap_location of a level, if any.
	/// * This is the owning locations of levels.
	/// * Non-owning locations aren't in here.
	/// * A level can only be owned by one location at a time.
	/// * Automatically managed by /datum/overmap_location registration
	/// * Attempting to lock a level already locked by another level is an immediate runtime error.
	///
	/// todo: should locations be registered in global list when 'active'?
	///       this would let us abstract handling away from entity entirely.
	///
	/// These axioms must be true at all times:
	/// * A level is locked (registered here) if it's enclosed by an overmaps entity.
	/// * A level is not locked if it's enclosed by no overmaps entity.
	/// * A level is locked / unlocked as a location is assigned / un-assigned from an entity.
	var/static/list/datum/overmap_location/location_enclosed_levels = list()
	/// Active overmap locations; ergo the ones with locks on [location_enclosed_levels].
	var/static/list/datum/overmap_location/active_overmap_locations = list()

/datum/controller/subsystem/overmaps/Initialize()
	// make overmaps //
	make_default_overmap()
	// initialize entities //
	for(var/datum/callback/callback in entity_initialize_queue)
		callback.Invoke()
	entity_initialize_queue = null
	// rebuild stuff //
	rebuild_helm_computers()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/overmaps/on_max_z_changed(old_z_count, new_z_count)
	..()
	ASSERT(old_z_count <= new_z_count)
	if(!islist(location_enclosed_levels))
		location_enclosed_levels = list()
	location_enclosed_levels.len = new_z_count

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

//* Overmap Entity *//

/**
 * Creates an entity with a given location.
 */
/datum/controller/subsystem/overmaps/proc/initialize_entity(datum/overmap_initializer/initializer, location_for_initializer)
	if(initialized)
		do_initialize_entity(initializer, location_for_initializer)
	else
		entity_initialize_queue += CALLBACK(src, PROC_REF(do_initialize_entity), initializer, location_for_initializer)

/datum/controller/subsystem/overmaps/proc/do_initialize_entity(datum/overmap_initializer/initializer, location_for_initializer)
	PRIVATE_PROC(TRUE)
	initializer.initialize(location_for_initializer)

/**
 * Gets entity owning a level.
 *
 * * Something on a space turf outside of a shuttle in a freeflight level has its level
 *   owned by the 'host' shuttle of that level.
 * * A landed shuttle has its level owned by, obviously, the entity owning that level.
 *
 * @params
 * * target - an /atom, or a z-index. atoms will be resolved to z-level.
 */
/datum/controller/subsystem/overmaps/proc/get_enclosing_overmap_entity(target) as /obj/overmap/entity
	if(isatom(target))
		target = (get_turf(target))?:z
	if(!target)
		return
	return location_enclosed_levels[target]?.entity

/**
 * Gets entity the atom is physically on.
 *
 * * Something on a space turf outside of a shuttle in a shuttle interdiction / freeflight level
 *   is on no entity, because it's.. physically not on an entity!
 * * A landed shuttle has its contents owned by itself.
 *
 * @params
 * * target - an /atom
 */
/datum/controller/subsystem/overmaps/proc/get_overmap_entity(atom/target) as /obj/overmap/entity
	if(!get_turf(target))
		return
	var/area/their_area = get_area(target)
	if(!their_area)
		CRASH("couldn't get area?")
	if(istype(their_area, /area/shuttle))
		var/area/shuttle/their_shuttle_area = their_area
		if(istype(their_shuttle_area.shuttle, /datum/shuttle/autodock/overmap))
			var/datum/shuttle/autodock/overmap/i_hate_legacy_systems = their_shuttle_area.shuttle
			return i_hate_legacy_systems.myship
	var/their_z = get_z(target)
	var/datum/overmap_location/level_location = location_enclosed_levels[their_z]
	if(!level_location)
		return
	return level_location.is_physically_level(their_z) ? level_location.entity : null

// todo: entity round-persistent-compatible GUID

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
