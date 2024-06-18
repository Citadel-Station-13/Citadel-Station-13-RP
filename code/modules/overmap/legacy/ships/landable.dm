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
	/// if we're on a shuttle level at all
	///
	/// * if we own one, this is going to also be the same level
	/// * we can share this level with others
	var/datum/map_level/freeflight/flight_level
	/// our status
	var/flight_status = OVERMAP_FLIGHT_STATUS_UNKNOWN

/obj/overmap/entity/visitable/ship/landable/proc/initialize_controller(datum/shuttle_controller/overmap/controller)
	controller.entity = src
	shuttle_controller = controller
	shuttle = controller.shuttle

/obj/overmap/entity/visitable/ship/landable/proc/get_flight_status()
	return flight_status

/obj/overmap/entity/visitable/ship/landable/proc/set_flight_status(status)
	status = OVERMAP_FLIGHT_STATUS_TRANSITING

/**
 * called when our shuttle starts a transit cycle
 */
/obj/overmap/entity/visitable/ship/landable/proc/on_shuttle_transit_cycle(datum/shuttle_transit_cycle/cycle)
	set_flight_status(OVERMAP_FLIGHT_STATUS_TRANSITING)

/**
 * called when our shuttle ends a transit cycle
 */
/obj/overmap/entity/visitable/ship/landable/proc/on_shuttle_transit_end(datum/shuttle_transit_cycle/cycle)
	on_shuttle_transit_to_level(cycle.target_dock)

	if(flight_level && cycle.target_dock?.z == flight_level.z_index)
		// we're flying to the same level, likely as a flyby or something
	else
		// we're going to a different level. tear it down.
		var/obj/overmap/entity/target_entity
		if(cycle.target_resolved)
			target_entity = get_overmap_entity(cycle.target_dock)
		SSovermaps.release_flight_level(flight_level, src, target_entity, cycle.target_dock?.z)

/obj/overmap/entity/visitable/ship/landable/proc/resolve_freeflight_for_transit(datum/shuttle_transit_cycle/cycle)
	switch(cycle.target_resolver_hint)
		if(SHUTTLE_LAZY_TARGET_HINT_MOVE_TO_FREEFLIGHT)
			// prefer current direction
			ensure_flight_level_exists(shuttle.anchor.dir)
			#warn set target vars to flight dock
		else
			. = FALSE
			CRASH("unexpected hint")

/obj/overmap/entity/visitable/ship/landable/proc/ensure_flight_level_exists(preferred_direction)
	// already have one? don't.
	if(flight_level)
		return
	// make one, with us as leader
	SSovermaps.assign_flight_level(src)
	// check dir
	if(isnull(preferred_direction))
		preferred_direction = shuttle.descriptor.preferred_orientation
	// make our dock
	var/height = shuttle.anchor.overall_height(preferred_direction)
	var/width = shuttle.anchor.overall_width(preferred_direction)
	flight_level.make_leader_dock(width, height, preferred_orientation)

#warn below

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
	var/datum/map_level/freeflight/flight_level
	if(istype(level, /datum/map_level/freeflight))
		// we're in someone's freeflight level
		flight_level = level


	#warn impl

#warn above

/obj/overmap/entity/visitable/ship/landable/get_landed_info()
	if(!!shuttle_controller.get_transit_stage())
		return "Maneuvering under secondary thrust."
	switch(flight_status)
		if(OVERMAP_FLIGHT_STATUS_FREEFLIGHT)
			return "In open space."
		if(OVERMAP_FLIGHT_STATUS_VISITING)
			var/obj/overmap/entity/visitable/location = loc
			if(istype(loc, /obj/overmap/entity/visitable/sector))
				return "Landed on \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			if(istype(loc, /obj/overmap/entity/visitable/ship))
				return "Docked with \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			return "Docked with an unknown object."

/obj/overmap/entity/visitable/ship/landable/can_burn()
	switch(flight_status)
		if(OVERMAP_FLIGHT_STATUS_FREEFLIGHT)
			return ..()
		else
			return FALSE

/obj/overmap/entity/visitable/ship/landable/burn()
	switch(flight_status)
		if(OVERMAP_FLIGHT_STATUS_FREEFLIGHT)
			return ..()
		else
			return FALSE

/obj/overmap/entity/visitable/ship/landable/check_ownership(obj/object)
	return get_overmap_entity(object) == src
