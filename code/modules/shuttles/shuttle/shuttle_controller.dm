//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Shuttle controller
 *
 * Acts like a TGUI module.
 */
/datum/shuttle_controller
	//* Intrinsics
	/// our host shuttle
	var/datum/shuttle/shuttle

	//* Blocking
	/// registration list for 'hostile environment' system, aka 'shuttle cannot launch right now'
	///
	/// * keys are datums
	/// * values are reasons
	/// * unlike shuttle hooks, these are always hard blockers that cannot be overridden.
	/// * therefore it's safe to use this for backend purposes like when a zone is regenerating for beltmining.
	///
	/// todo: some kind of /datum/tgui_descriptive_text or something idfk for better error messages
	var/list/blocked_from_moving
	#warn hook

	//* Docking - Control
	/// stored docking codes
	var/list/docking_codes
	/// dock UIDs we always have codes for
	var/list/docking_always_has_code_to_ids

	//* Docking - State
	/// current docking cycle
	var/docking_cycle = 0
	/// list of callbacks to invoke on end of docking cycle
	///
	/// * callbacks are invoked with (src, status: SHUTTLE_DOKCING_STATUS_*, state: SHUTTLE_DOCKING_STATE_*)
	/// * 'state' in the third argument is the state that we were interrupted from; so if state is DOCKING, this was an interrupted docking.
	var/list/datum/callback/docking_callbacks
	/// docking state
	var/docking_state = SHUTTLE_DOCKING_STATE_IDLE
	/// nicely request that we aren't interrupted
	/// ... so basically, does literally nothing other than stop players from doing it (not even admins)
	var/docking_no_interrupt = FALSE

	//* Manual Landing
	/// current manual landing dock
	var/obj/shuttle_dock/manual_dock
	/// /datum/shuttle_docker instances by user
	/// user is real user of a tgui interface / the client viewing it,
	/// *not* the actor-performer tuple.
	/// that's encoded on the shuttle_docker.
	var/list/datum/shuttle_docker/docker_by_user

	//* Transit
	/// in-progress transit
	var/datum/shuttle_transit_cycle/transit_cycle
	/// default transit time
	var/transit_time_default = 10 SECONDS

	//* UI
	/// tgui interface to load
	var/tgui_module

/datum/shuttle_controller/Destroy()
	abort_transit()
	return ..()

/datum/shuttle_controller/proc/initialize(datum/shuttle/shuttle)
	src.shuttle = shuttle
	return TRUE

//* Blocking API *//

/datum/shuttle_controller/proc/register_movement_block(datum/source, reason)
	LAZYSET(blocked_from_moving, source, reason)

/datum/shuttle_controller/proc/unregister_movement_block(datum/source)
	LAZYREMOVE(blocked_from_moving, source)

//* Docking - Control *//

/datum/shuttle_controller/proc/has_codes_for(obj/shuttle_dock/dock)
	if(dock.docking_code in docking_codes)
		return TRUE
	if(dock.dock_id in docking_always_has_code_to_ids)
		return TRUE
	return FALSE

//* Docking - Main *//

/**
 * * returns existing op id if already docking
 * * interrupts undocking automatically
 *
 * @params
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 *
 * @return op id
 */
/datum/shuttle_controller/proc/asynchronously_dock(datum/callback/on_finish, no_interrupt)
	#warn impl

/**
 * * returns existing op id if already undocking
 * * interrupts docking automatically
 *
 * @params
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 *
 * @return op id
 */
/datum/shuttle_controller/proc/asynchronously_undock(datum/callback/on_finish, no_interrupt)
	#warn impl

/**
 * immediately interrupt docking
 */
/datum/shuttle_controller/proc/interrupt_docking()
	#warn impl

/**
 * immediately interrupt docking
 */
/datum/shuttle_controller/proc/interrupt_undocking()
	#warn impl

/**
 * * returns existing op id if already docking
 * * interrupts undocking automatically
 *
 * @params
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 *
 * @return op id
 */
/datum/shuttle_controller/proc/synchronously_dock(no_interrupt)
	#warn impl

/**
 * * returns existing op id if already undocking
 * * interrupts docking automatically
 *
 * @params
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 *
 * @return op id
 */
/datum/shuttle_controller/proc/synchronously_undock(no_interrupt)
	#warn impl

/**
 * block on a docking op
 *
 * @params
 * * cycle - the operation id
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/block_on_docking(cycle)
	#warn impl

/**
 * block on an undocking op
 *
 * @params
 * * cycle - the operation id
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/block_on_undocking(cycle)
	#warn impl

/**
 * @params
 * * cycle - the operation id
 * * callback - what to call
 */
/datum/shuttle_controller/proc/on_docking(cycle, datum/callback/callback)
	#warn impl

/**
 * @params
 * * cycle - the operation id
 * * callback - what to call
 */
/datum/shuttle_controller/proc/on_undocking(cycle, datum/callback/callback)
	#warn impl

//* Docking - Manual Landmarks *//

/**
 * call to designate a manual landing position
 *
 * this is unchecked / has no safety checks.
 *
 * @return FALSE on failure
 */
/datum/shuttle_controller/proc/set_manual_landing(turf/lowerleft, orientation)
	if(!isnull(manual_dock))
		QDEL_NULL(manual_dock)
	#warn impl
	#warn interrupt in-progress moves

/**
 * returns a list of name-to-turf of valid jump points on a given zlevel
 */
/datum/shuttle_controller/proc/manual_landing_beacons(zlevel)
	#warn impl

/**
 * returns a list of valid name-to-zlevel-index for manual landing
 */
/datum/shuttle_controller/proc/manual_landing_levels()
	#warn impl

//* Movement - Transit *//

/**
 * default transit time for a dock
 */
/datum/shuttle_controller/proc/default_transit_time_for_dock(obj/shuttle_dock/dock)
	return transit_time_default

/**
 * start transiting towards a specific dock
 *
 * we will be immediately jumped into transit space on this call!
 * we will process immediate undocking events but we will not be able to be blocked.
 *
 * @params
 * * dock - dock to go to.
 * * time - time to spend in transit.
 * * align_with_port - the port to align with; overrides 'centered'
 * * centered - should we be centered on the dock's bounding box? if not, we move our anchor onto the dock directly.
 * * direction - the direction to use for centered landing.
 * * on_transit_callbacks - a callback or list of callbacks to register; if this proc fails they will NOT be called!
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/shuttle_controller/proc/transit_towards_dock(obj/shuttle_dock/dock, time = default_transit_time_for_dock(dock), obj/shuttle_port/align_with_port, centered, direction, list/datum/callback/on_transit_callbacks)
	if(isnull(direction))
		direction = shuttle.anchor.dir
	// abort existing transit
	var/redirected = FALSE
	if(is_in_transit())
		redirected = TRUE
		abort_transit(TRUE)
	// obtain exclusive lock on dock
	if(dock.inbound)
		return FALSE
	dock.inbound = src
	// jump into transit
	shuttle.move_to_transit()
	// set variables
	transit_target_dock = dock
	transit_target_centered_mode = centered
	transit_target_direction = direction
	transit_target_port = align_with_port

	if(islist(on_transit_callbacks))
	else if(!isnull(on_transit_callbacks))
		on_transit_callbacks = list(on_transit_callbacks)
	else
		on_transit_callbacks = list()
	transit_finish_callbacks = on_transit_callbacks.Copy()

	// register timers
	transit_timer_id = addtimer(CALLBACK(src, PROC_REF(finish_transit)), time, TIMER_STOPPABLE)
	transit_visual_timer_id = addtimer(CALLBACK(src, PROC_REF(make_transit_warning_visuals)), max(0, time - 4.9 SECONDS), TIMER_STOPPABLE)
	on_transit_begin(transit_target_dock, redirected)
	return TRUE

/**
 * @return FALSE if we're not in transit
 */
/datum/shuttle_controller/proc/register_transit_callback(datum/callback/cb)
	if(!is_in_transit())
		return FALSE
	transit_finish_callbacks += cb
	return TRUE

/datum/shuttle_controller/proc/make_transit_warning_visuals()
	var/list/motion = shuttle.anchor.calculate_resultant_motion_from_docking(
		transit_target_dock,
		align_with_port = transit_target_port,
		centered = transit_target_centered_mode,
		direction = transit_target_direction,
	)
	// todo: can we like, make something that isn't an /obj? maybe a turf overlay? maybe vis contents?
	transit_warning_visuals = list()
	// todo: leave holes where the shuttle's geometry isn't so this isn't just an AABB bounding box of visuals.
	for(var/turf/turf as anything in shuttle.anchor.aabb_ordered_turfs_at(motion, motion[4]))
		var/obj/effect/temporary_effect/shuttle_landing/landing_effect = new(turf)
		transit_warning_visuals += landing_effect

/datum/shuttle_controller/proc/finish_transit()
	ASSERT(transit_target_dock)

	. = shuttle.dock(
		transit_target_dock,
		align_with_port = transit_target_port,
		centered = transit_target_centered_mode,
		direction = transit_target_direction,
	)
	if(!.)
		for(var/datum/callback/callback in transit_finish_callbacks)
			callback.Invoke(src, transit_target_dock, SHUTTLE_TRANSIT_STATUS_BLOCKED)
	else
		for(var/datum/callback/callback in transit_finish_callbacks)
			callback.Invoke(src, transit_target_dock, SHUTTLE_TRANSIT_STATUS_SUCCESS)

	on_transit_success(transit_target_dock)
	cleanup_transit()

/**
 * stops transiting towards the current dock
 *
 * **we will be orphaned in transit space upon this call.**
 */
/datum/shuttle_controller/proc/abort_transit(redirected)
	if(!is_in_transit())
		return FALSE
	for(var/datum/callback/callback in transit_finish_callbacks)
		callback.Invoke(src, transit_target_dock, SHUTTLE_TRANSIT_STATUS_ABORTED)
	on_transit_abort(transit_target_dock, redirected)
	cleanup_transit()
	return TRUE

/datum/shuttle_controller/proc/cleanup_transit()
	transit_target_dock = null
	transit_target_centered_mode = null
	transit_target_direction = null
	transit_target_port = null
	transit_finish_callbacks = null
	if(transit_timer_id)
		deltimer(transit_timer_id)
	if(transit_visual_timer_id)
		deltimer(transit_visual_timer_id)
	for(var/obj/effect/temporary_effect/shuttle_landing/visual as anything in transit_warning_visuals)
		if(QDELETED(visual))
			continue
		qdel(visual)
	transit_warning_visuals = null

/**
 * checks if we're in transit towards a dock
 * not if the shuttle is in transit space, but if **we**, the controller, have a transit queued.
 */
/datum/shuttle_controller/proc/is_in_transit()
	return !isnull(transit_timer_id)

/**
 * gets world.time time (so, deciseconds) left in transit
 *
 * negative values can be returned if we're overdue, somehow!
 */
/datum/shuttle_controller/proc/transit_time_left()
	if(isnull(transit_timer_id))
		return
	return transit_arrival_time - world.time

/**
 * called on transit begint
 *
 * @params
 * * dock - the dock we were going to
 * * redirected - this is from us getting another transit_towards_dock while transiting
 */
/datum/shuttle_controller/proc/on_transit_begin(obj/shuttle_dock/dock, redirected)
	return

/**
 * called on transit fail / abort
 *
 * @params
 * * dock - the dock we were going to
 * * redirected - this is from us getting another transit_towards_dock while transiting
 */
/datum/shuttle_controller/proc/on_transit_abort(obj/shuttle_dock/dock, redirected)
	return

/**
 * called on transit success
 *
 * @params
 * * dock - the dock we were going to
 */
/datum/shuttle_controller/proc/on_transit_success(obj/shuttle_dock/dock)
	return

//* Interface *//

/datum/shuttle_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/shuttle_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["$src"] = REF(src)
	.["$tgui"] = tgui_module

/datum/shuttle_controller/proc/tgui_act(action, list/params, authorization)
	#warn impl

/datum/shuttle_controller/proc/tgui_push(list/data)
	// this is just a wrapper so we can change it later if need be
	return push_ui_data(data = data)

/datum/shuttle_controller/proc/push_ui_location()
	return
