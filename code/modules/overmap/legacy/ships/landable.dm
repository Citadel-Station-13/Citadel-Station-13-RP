// These come with shuttle functionality. Need to be assigned a (unique) shuttle datum name.
// Mapping location doesn't matter, so long as on a map loaded at the same time as the shuttle areas.
// Multiz shuttles currently not supported. Non-autodock shuttles currently not supported.

/obj/overmap/entity/visitable/ship/landable
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	/// our shuttle
	var/datum/shuttle/shuttle
	/// our shuttle controller
	var/datum/shuttle_controller/overmap/shuttle_controller
	/// our shuttle level, if any
	///
	/// * this is if we are owning a flight level
	var/datum/map_level/shuttle/owned_level

/obj/overmap/entity/visitable/ship/landable

/**
 * checks if we're free-flighting
 *
 * if not, we're probably, but not provably, landed
 *
 * todo: use a get_flight_status() unified proc for overmap entities with enums
 */
/obj/overmap/entity/visitable/ship/landable/proc/is_in_freeflight()
	#warn impl

/**
 * checks if we've landed
 *
 * if not, we're probably, but not provably, in freeflight
 *
 * todo: use a get_flight_status() unified proc for overmap entities with enums
 */
/obj/overmap/entity/visitable/ship/landable/proc/is_landed()
	#warn impl

/**
 * called when our shuttle enters a certain zlevel
 */
#warn hook
/obj/overmap/entity/visitable/ship/landable/proc/on_shuttle_transit_to_level(z)
	var/obj/overmap/entity/currently_inside
	var/obj/overmap/entity/going_into = get_overmap_entity(z)

	// we have to detect this from our state because by the time this proc is called the shuttle has already moved
	if(istype(loc, /obj/overmap/entity))
		currently_inside = loc

	var/datum/map_level/level = SSmapping.ordered_levels[z]
	var/datum/map_level/shuttle/flight_level
	if(istype(level, /datum/map_level/shuttle))
		// we're in someone's freeflight level
		flight_level = level


	#warn impl

/**
 * called to hand off our level to another shuttle in it
 *
 * @params
 * * hand_to - the new leading entity. if null, one is randomly and heuristically chosen.
 */
/obj/overmap/entity/visitable/ship/landable/proc/dangerously_hand_off_flight_level(obj/overmap/entity/visitable/ship/landable/hand_to)
	#warn impl

/**
 * called if we're the last to leave a level and it should be disposed
 */
/obj/overmap/entity/visitable/ship/landable/proc/dangerously_dispose_flight_level()
	#warn impl

/**
 * Only call right before we jump to it. We don't want flight levels floating around.
 */
/obj/overmap/entity/visitable/ship/landable/proc/ensure_flight_level_exists()
	. = FALSE
	ASSERT(isnull(owned_level))
	SSovermaps.assign_flight_level(src)
	ASSERT(!isnull(owned_level))

#warn below

// We autobuild our z levels.
/obj/overmap/entity/visitable/ship/landable/find_z_levels()
	src.landmark = new(null, shuttle) // Create in nullspace since we lazy-create overmap z
	add_landmark(landmark, shuttle)

/obj/overmap/entity/visitable/ship/landable/proc/setup_overmap_location()
	if(LAZYLEN(map_z))
		return // We're already set up!
	var/datum/map_level/transit/creating = new
	creating.name = "Transit - [src]"
	var/datum/map_level/loaded = SSmapping.allocate_level(creating)
	map_z += loaded.z_index

	var/turf/center_loc = locate(round(world.maxx/2), round(world.maxy/2), loaded.z_index)
	landmark.forceMove(center_loc)

	var/visitor_dir = fore_dir
	for(var/landmark_name in list("FORE", "PORT", "AFT", "STARBOARD"))
		var/turf/visitor_turf = get_ranged_target_turf(center_loc, visitor_dir, round(min(world.maxx/4, world.maxy/4)))
		var/obj/effect/shuttle_landmark/visiting_shuttle/visitor_landmark = new (visitor_turf, landmark, landmark_name)
		add_landmark(visitor_landmark)
		visitor_dir = turn(visitor_dir, 90)

	register_z_levels()
	testing("Setup overmap location for \"[name]\" containing Z [english_list(map_z)]")

/obj/overmap/entity/visitable/ship/landable/populate_sector_objects()
	..()
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(istype(shuttle_datum,/datum/shuttle/autodock/overmap))
		var/datum/shuttle/autodock/overmap/oms = shuttle_datum
		oms.myship = src
	GLOB.shuttle_pre_move_event.register(shuttle_datum, src, PROC_REF(pre_shuttle_jump))
	GLOB.shuttle_moved_event.register(shuttle_datum, src, PROC_REF(on_shuttle_jump))
	on_landing(landmark, shuttle_datum.current_location) // We "land" at round start to properly place ourselves on the overmap.

//
// More ship procs
//

/obj/overmap/entity/visitable/ship/landable/proc/pre_shuttle_jump(datum/shuttle/given_shuttle, obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(given_shuttle != SSshuttle.shuttles[shuttle])
		return
	if(into == landmark)
		setup_overmap_location() // They're coming boys, better actually exist!
		GLOB.shuttle_pre_move_event.unregister(SSshuttle.shuttles[shuttle], src)

/obj/overmap/entity/visitable/ship/landable/proc/on_shuttle_jump(datum/shuttle/given_shuttle, obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(given_shuttle != SSshuttle.shuttles[shuttle])
		return
	var/datum/shuttle/autodock/auto = given_shuttle
	if(into == auto.landmark_transition)
		status = SHIP_STATUS_TRANSIT
		on_takeoff(from, into)
		return
	if(into == landmark)
		status = SHIP_STATUS_OVERMAP
		on_takeoff(from, into)
		return
	status = SHIP_STATUS_LANDED
	on_landing(from, into)

/obj/overmap/entity/visitable/ship/landable/proc/on_landing(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	var/obj/overmap/entity/visitable/target = get_overmap_entity(get_z(into))
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(into.landmark_tag == shuttle_datum.motherdock) // If our motherdock is a landable ship, it won't be found properly here so we need to find it manually.
		for(var/obj/overmap/entity/visitable/ship/landable/landable in SSovermaps.ships)
			if(landable.shuttle == shuttle_datum.mothershuttle)
				target = landable
				break
	if(!target || target == src)
		return
	forceMove(target)
	halt()

/obj/overmap/entity/visitable/ship/landable/proc/on_takeoff(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(!isturf(loc))
		forceMove(get_turf(loc))
		unhalt()

#warn above

/obj/overmap/entity/visitable/ship/landable/get_landed_info()
	if(!!shuttle_controller.get_transit_stage())
		return "Maneuvering under secondary thrust."
	if(is_in_freeflight())
		return "In open space."
	if(is_landed())
		var/obj/overmap/entity/visitable/location = loc
		if(istype(loc, /obj/overmap/entity/visitable/sector))
			return "Landed on \the [location.name]. Use secondary thrust to get clear before activating primary engines."
		if(istype(loc, /obj/overmap/entity/visitable/ship))
			return "Docked with \the [location.name]. Use secondary thrust to get clear before activating primary engines."
		return "Docked with an unknown object."

/obj/overmap/entity/visitable/ship/landable/can_burn()
	return is_in_freeflight() && ..()

/obj/overmap/entity/visitable/ship/landable/burn()
	return is_in_freeflight() && ..()

/obj/overmap/entity/visitable/ship/landable/check_ownership(obj/object)
	return get_overmap_entity(object) == src
