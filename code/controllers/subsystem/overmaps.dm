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
	/// legacy ship lookup
	//  TODO: obliterate this
	var/list/obj/overmap/entity/visitable/ship/legacy_ships = list()

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

	//* Freeflight *//

	/// did you know? shuttle flight levels are free!
	/// that means you can just take one!
	///
	/// * this is the list of currently unallocated/free'd up shuttle flight levels
	/// * we don't use zclear system so overmaps is even-more-decoupled from SSmapping.
	var/list/datum/map_level/freeflight/free_flight_levels = list()
	/// currently in-use shuttle flight levels
	var/list/datum/map_level/freeflight/used_flight_levels = list()

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
	if(!initialized || !SSatoms.initialized) // see ssatoms init.
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
		var/datum/shuttle/their_shuttle = their_shuttle_area.shuttle
		// TODO: better API?
		if(their_shuttle && istype(their_shuttle.controller, /datum/shuttle_controller/overmap))
			var/datum/shuttle_controller/overmap/overmap_controller = their_shuttle.controller
			return overmap_controller.entity
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

//* Flight Levels *//

/**
 * The core issue this is solving is BYOND zlevels.
 *
 * When shuttles fly, they don't really move. They move the space around them, their zlevel,
 * on a virtual map.
 *
 * Flight levels are what we call those; and all of this is solving the problem of what
 * we do with that level when one flight level intersects another, or an entity during landing
 *
 * How this is done before (baystation / vorestation):
 * 1. shuttles own an exclusive level
 * 2. shuttles can only access that exclusive level or another thing's level
 * 3. interdictions: shuttles 'visiting' other shuttles land on that shuttle's exclusive level
 * 4. because shuttles have exclusive permanent levels, shuttles cannot escape from interdictions
 *
 * How we do it now:
 *
 * We try our best to solve the issues of,
 *
 * * interdictions: shuttles should be able to escape from them as per gameplay.
 * * level recycling: we have a lot more shuttles than the shuttles in use. we want to recycle levels whenever possible.
 * * balance / PvP: disengagement is considered here in terms of what happens
 *
 * What we arrived at is thus these following axioms:
 *
 * * Shuttles must always have a flight level while in freeflight, not transit
 * * Shuttles must always teardown their flightlevel when permanently leaving freeflight, or hand it off to another
 * * Objects left behind with MOVABLE_NO_LOST_IN_SPACE will have their continuity preserved, but will not necessarily survive.
 * * Objects left behind without that flag are treated as we please, up to and including usually just deleting it.
 * * Turfs left behind are implementation-defined for how we treat it. Players shouldn't be putting turfs outside of shuttles anyways.
 *
 * Thus, the following specs determine what happens and when.
 *
 * * visiting --> freeflight: shuttle allocates a new flight level
 * * freeflight --> freeflight (interdiction): shuttle merges their flight level into the victim's
 * * freeflight --> visiting: freeflight level is torn down and merged. planets = skyfall, non-planets = put on zlevel edges if possible.
 *
 * Here's what happens during merges
 *
 * * freeflight --> freeflight: direct x/y preserving merge. blocked turfs get their contents kicked to nearby turfs via algorithm
 * * freeflight --> visiting (planet): skyfall on outdoors
 * * freeflight --> visiting (non-planet): put on nearby turf to shuttle as debris cloud
 */
#warn /datum/component/recursive_freeflight_permeance

/datum/controller/subsystem/overmaps/proc/assign_flight_level(obj/overmap/entity/visitable/ship/landable/leader)
	// make sure they don't already have one
	ASSERT(!leader.flight_level)
	// get a free level or allocate a new one
	var/datum/map_level/freeflight/assigning
	if(length(free_flight_levels))
		assigning = free_flight_levels[free_flight_levels.len]
		free_flight_levels.len--
	else
		var/datum/map_level/freeflight/creating = new
		SSmapping.load_level(creating)
		assigning = creating
	// mark as used
	used_flight_levels += assigning
	// assign them their level
	leader.flight_level = assigning
	// done
	return TRUE

/**
 * called when a shuttle leaves their flight level
 *
 * we make a best estimate of where to send things on the level based on
 *
 * 1. who the leader is
 * 2. who is left on the level
 * 3. where the leaving shuttle is going
 *
 * @params
 * * level - the level now orphaned
 * * leaving - the shuttle who left
 * * moving_into - (optional) the overmap entity the leader is going into
 * * moving_to_level - (optional) the zlevel index the leader is goign to
 * * hand_off_to - (optional) forcefully set which entity to hand this off to. this doesn't need to be set, we can autodetect
 */
/datum/controller/subsystem/overmaps/proc/release_flight_level(
	datum/map_level/freeflight/level,
	obj/overmap/entity/visitable/ship/leaving,
	obj/overmap/entity/moving_into,
	moving_to_level,
	obj/overmap/entity/visitable/ship/hand_off_to,
)
	#warn stuff

/**
 * called when the last shuttle leaves a flight level
 */
/datum/controller/subsystem/overmaps/proc/dispose_flight_level(datum/map_level/freeflight/level, obj/overmap/entity/visitable/ship/landable/leaving, obj/overmap/entity/going_into)
	#warn impl
	clear_flight_level(level, leaving)

/**
 * internal proc: merges a flight level into another
 *
 * called by clear_flight_level
 *
 * * we don't move turfs or anything; non shuttle turfs are just left behind
 */
/datum/controller/subsystem/overmaps/proc/merge_flight_level_contents(datum/map_level/freeflight/disposing, datum/map_level/freeflight/merging_into, list/atom/movable/movables)

// todo: SSzclear when?
/**
 * internal proc: clears a flight level
 *
 * @params
 * * level - the level to clear
 * * handler - what to do with atoms
 * * live_handler - what to do with atoms to not destroy; called with (list/atom/movable/movables)
 * * dead_handler - what to do with atoms to destroy; called with (list/atom/movable/movables)
 */
/datum/controller/subsystem/overmaps/proc/clear_flight_level(datum/map_level/freeflight/level, datum/callback/live_handler, datum/callback/dead_handler)
	PRIVATE_PROC(TRUE)

	ASSERT(level.loaded)
	ASSERT(level.z_index)

	var/list/turf/clearing_turfs = Z_TURFS(level.z_index)
	var/list/atom/movable/clearing_movables = list()
	var/area/move_to_area = unique_area_of_type(/area/space)
	var/deleted = 0
	var/cycles_so_far = 0
	var/clean = FALSE

	do
		// no check tick on this one
		for(var/turf/T as anything in clearing_turfs)
			for(var/atom/movable/AM as anything in T)
				if(AM.atom_flags & (ATOM_ABSTRACT))
					continue
				clearing_movables += AM

		clean = !length(clearing_turfs)
		if(clean)
			continue

		// yes check tick on this one
		for(var/atom/movable/AM as anything in clearing_movables)
			// WELCOME TO HELL: this is how we handle atoms
			var/yeet_them_out_of_the_sky = AM.movable_flags & MOVABLE_NO_LOST_IN_SPACE
			if(!yeet_them_out_of_the_sky)
				if(isliving(AM))
					var/mob/living/victim = AM
					// if they have a mind, they're probably relevant
					if(victim.mind)
						yeet_them_out_of_the_sky = TRUE
					else if(victim.ckey)
						stack_trace("victim [victim] with ckey [victim.ckey] but no mind ([victim.type])")
						yeet_them_out_of_the_sky  = TRUE
			if(!yeet_them_out_of_the_sky)
				// Bye Bye!
				qdel(AM)
				continue
			#warn yuh YEET
			#warn deal with shuttle interdiction

	while(!clean && cycles_so_far <= 5)

	if(cycles_so_far >= 5)
		stack_trace("aborted clearing level due to taking more than 5 cycles to do so.")

	// finished, finalize
	move_to_area.take_turfs(clearing_turfs)
	// deal with turfs
	var/level_baseturf = level.base_turf
	if(!ispath(level_baseturf, /turf))
		level_baseturf = world.turf
	for(var/turf/T as anything in clearing_turfs)
		CHECK_TICK
		if(istype(T, level_baseturf))
			continue
		T.ChangeTurf(level_baseturf, level_baseturf)
	return deleted
