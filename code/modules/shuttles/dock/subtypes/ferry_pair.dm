//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/shuttle_dock/ferry_pair
	// usually your ferries need to be aligned. usually.
	centered_landing_only = FALSE

	/// Are we the home or away dock in this pair? Used for controller init.
	var/ferry_init_is_home
	/// Typepath of the other dock to bind to. Used for controller init.
	var/ferry_init_bind_opposite_typepath
	/// When initializing shuttle, kick the shuttle to the other side if possible instead
	/// * Useful when you want a large pad on Centcom that can accomodate
	///   shuttles from many different stations.
	var/ferry_init_kick_to_home = FALSE

/obj/shuttle_dock/ferry_pair/proc/get_opposite_bind_dock() as /obj/shuttle_dock
	return SSshuttle.resolve_dock(ferry_init_bind_opposite_typepath)

/obj/shuttle_dock/ferry_pair/move_starting_shuttle_to_roundstart(datum/shuttle/loaded)
	if(!ferry_init_is_home && ferry_init_kick_to_home)
		var/obj/shuttle_dock/home = src.get_opposite_bind_dock()
		return home.move_starting_shuttle_to_roundstart(loaded)
	return ..()

/obj/shuttle_dock/ferry_pair/init_starting_shuttle_controller(datum/shuttle/shuttle)
	var/home_id
	var/away_id

	if(ferry_init_is_home)
		home_id = src.dock_id
		away_id = src.get_opposite_bind_dock()?.dock_id
	else
		home_id = src.get_opposite_bind_dock()?.dock_id
		away_id = src.dock_id

	if(!isnull(home_id) && !isnull(away_id))
		var/datum/shuttle_controller/ferry/controller = new(home_id, away_id)
		shuttle.bind_controller(controller)
		return controller
	else
		stack_trace("ferry pair dock missing home or away id for controller init.")
