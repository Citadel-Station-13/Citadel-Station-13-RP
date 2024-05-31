// These come with shuttle functionality. Need to be assigned a (unique) shuttle datum name.
// Mapping location doesn't matter, so long as on a map loaded at the same time as the shuttle areas.
// Multiz shuttles currently not supported. Non-autodock shuttles currently not supported.

/obj/overmap/entity/visitable/ship/landable
	/// our shuttle
	var/datum/shuttle/shuttle
	/// our shuttle level, if any
	var/datum/map_level/shuttle/flight_level
	///

/obj/overmap/entity/visitable/ship/landable
	var/shuttle                                         // Name of associated shuttle. Must be autodock.
	var/obj/effect/shuttle_landmark/ship/landmark       // Record our open space landmark for easy reference.
	var/status = SHIP_STATUS_LANDED
	icon_state = "shuttle"
	moving_state = "shuttle_moving"

/obj/overmap/entity/visitable/ship/landable/Destroy()
	GLOB.shuttle_pre_move_event.unregister(SSshuttle.shuttles[shuttle], src)
	GLOB.shuttle_moved_event.unregister(SSshuttle.shuttles[shuttle], src)
	return ..()

/obj/overmap/entity/visitable/ship/landable/can_burn()
	if(status != SHIP_STATUS_OVERMAP)
		return 0
	return ..()

/obj/overmap/entity/visitable/ship/landable/burn()
	if(status != SHIP_STATUS_OVERMAP)
		return 0
	return ..()

/obj/overmap/entity/visitable/ship/landable/check_ownership(obj/object)
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(!shuttle_datum)
		return
	var/list/areas = shuttle_datum.find_childfree_areas()
	if(get_area(object) in areas)
		return 1

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

/obj/overmap/entity/visitable/ship/landable/get_areas()
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(!shuttle_datum)
		return list()
	return shuttle_datum.find_childfree_areas()

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

/obj/overmap/entity/visitable/ship/landable/get_landed_info()
	switch(status)
		if(SHIP_STATUS_LANDED)
			var/obj/overmap/entity/visitable/location = loc
			if(istype(loc, /obj/overmap/entity/visitable/sector))
				return "Landed on \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			if(istype(loc, /obj/overmap/entity/visitable/ship))
				return "Docked with \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			return "Docked with an unknown object."
		if(SHIP_STATUS_TRANSIT)
			return "Maneuvering under secondary thrust."
		if(SHIP_STATUS_OVERMAP)
			return "In open space."
