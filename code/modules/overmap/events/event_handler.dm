GLOBAL_DATUM_INIT(overmap_event_handler, /singleton/overmap_event_handler, new)

/singleton/overmap_event_handler
	var/list/hazard_by_turf
	var/list/ship_events
	var/list/hazard_by_ship

/singleton/overmap_event_handler/New()
	..()
	hazard_by_turf = list()
	ship_events = list()

/singleton/overmap_event_handler/proc/start_hazard(var/obj/overmap/entity/visitable/ship/ship, var/obj/overmap/tiled/hazard/hazard)	// Make these accept both hazards or events
	if(!(ship in ship_events))
		ship_events += ship

	for(var/event_type in hazard.events)
		if(is_event_active(ship, event_type, hazard.difficulty))	// Event's already active, don't bother
			continue
		var/datum/event_meta/EM = new(hazard.difficulty, "Overmap event - [hazard.name]", event_type, add_to_queue = FALSE, is_one_shot = TRUE)
		var/datum/event/E = new event_type(EM)
		E.startWhen = 0
		E.endWhen = INFINITY
		// TODO - Leshana - Note: event.setup() is called before these are set!
		E.affecting_z = ship.get_z_indices() || list()
		E.victim = ship
		LAZYADD(ship_events[ship], E)

/singleton/overmap_event_handler/proc/stop_hazard(var/obj/overmap/entity/visitable/ship/ship, var/obj/overmap/tiled/hazard/hazard)
	for(var/event_type in hazard.events)
		var/datum/event/E = is_event_active(ship, event_type, hazard.difficulty)
		if(E)
			E.kill()
			LAZYREMOVE(ship_events[ship], E)

/singleton/overmap_event_handler/proc/is_event_active(var/ship, var/event_type, var/severity)
	if(!ship_events[ship])	return
	for(var/datum/event/E in ship_events[ship])
		if(E.type == event_type && E.severity == severity)
			return E

/singleton/overmap_event_handler/proc/on_turf_entered(var/turf/new_loc, var/obj/overmap/entity/visitable/ship/ship, var/old_loc)
	if(!istype(ship))
		return
	if(new_loc == old_loc)
		return

	for(var/obj/overmap/tiled/hazard/E in hazard_by_turf[new_loc])
		start_hazard(ship, E)

/singleton/overmap_event_handler/proc/on_turf_exited(var/turf/old_loc, var/obj/overmap/entity/visitable/ship/ship, var/new_loc)
	if(!istype(ship))
		return
	if(new_loc == old_loc)
		return

	for(var/obj/overmap/tiled/hazard/E in hazard_by_turf[old_loc])
		if(is_event_included(hazard_by_turf[new_loc], E))
			continue	// If new turf has the same event as well... keep it going!
		stop_hazard(ship, E)

/singleton/overmap_event_handler/proc/update_hazards(var/turf/T)	// Catch all updater
	if(!istype(T))
		return

	var/list/active_hazards = list()
	for(var/obj/overmap/tiled/hazard/E in T)
		if(is_event_included(active_hazards, E, TRUE))
			continue
		active_hazards += E

	if(!active_hazards.len)
		hazard_by_turf -= T
	else
		hazard_by_turf |= T
		hazard_by_turf[T] = active_hazards

	for(var/obj/overmap/entity/visitable/ship/ship in T)
		for(var/datum/event/E in ship_events[ship])
			if(is_event_in_turf(E, T))
				continue
			E.kill()
			LAZYREMOVE(ship_events[ship], E)

		for(var/obj/overmap/tiled/hazard/E in active_hazards)
			start_hazard(ship, E)

/singleton/overmap_event_handler/proc/is_event_in_turf(var/datum/event/E, var/turf/T)
	for(var/obj/overmap/tiled/hazard/hazard in hazard_by_turf[T])
		if((E in hazard.events) && E.severity == hazard.difficulty)
			return TRUE

/singleton/overmap_event_handler/proc/is_event_included(var/list/hazards, var/obj/overmap/tiled/hazard/E, var/equal_or_better)	// This proc is only used so it can break out of 2 loops cleanly
	for(var/obj/overmap/tiled/hazard/A in hazards)
		if(istype(A, E.type) || istype(E, A.type))
			if(same_entries(A.events, E.events))
				if(equal_or_better)
					if(A.difficulty >= E.difficulty)
						return TRUE
					else
						hazards -= A	// TODO - Improve this SPAGHETTI CODE! Done only when called from update_hazards. ~Leshana
				else
					if(A.difficulty == E.difficulty)
						return TRUE
