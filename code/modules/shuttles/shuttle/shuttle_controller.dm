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
	//  todo: docking is currently on a spinlock system. should we put it on SSshuttles instead?
	var/docking_cycle = 0
	/// list of callbacks to invoke on end of docking cycle
	///
	/// * callbacks are invoked with (src, status: SHUTTLE_DOKCING_STATUS_*, state: SHUTTLE_DOCKING_STATE_*)
	/// * 'state' in the third argument is the state that we were interrupted from; so if state is DOCKING, this was an interrupted docking.
	/// * 'state' will either be DOCKING, or UNDOCKING; never UNKNOWN, DOCKED, or UNDOCKED
	var/list/datum/callback/docking_callbacks
	/// docking state
	var/docking_state = SHUTTLE_DOCKING_STATE_UNKNOWN
	/// nicely request that we aren't interrupted
	/// ... so basically, does literally nothing other than stop players from doing it (not even admins)
	var/docking_no_interrupt = FALSE
	/// ongoing docking event
	var/datum/event_args/shuttle/dock/docking_event

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
 * * on_finish - a callback or a list of callbacks to call when the docking / undocking cycle ends
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 * * timeout - don't let the op take longer than this
 *
 * @return op id
 */
/datum/shuttle_controller/proc/asynchronously_dock(datum/callback/on_finish, no_interrupt, timeout)
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_DOCKING)
			on_docking(on_finish, docking_cycle)
			return docking_cycle
	. = docking_cycle
	INVOKE_ASYNC(src, PROC_REF(synchronously_dock), no_interrupt, on_finish, timeout)
	// we assume that the interruption / beginning of a new cycle will only increment by 1.
	if(. != docking_cycle - 1)
		stack_trace("unexpected behavior - docking cycle incremented by more than 1. a core assumption made when writing this code was violated.")
	. = docking_cycle

/**
 * * returns existing op id if already undocking
 * * interrupts docking automatically
 *
 * @params
 * * on_finish - a callback or a list of callbacks to call when the docking / undocking cycle ends
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 * * timeout - don't let the op take longer than this
 *
 * @return op id
 */
/datum/shuttle_controller/proc/asynchronously_undock(datum/callback/on_finish, no_interrupt, timeout)
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_UNDOCKING)
			on_docking(on_finish, docking_cycle)
			return docking_cycle
	. = docking_cycle
	INVOKE_ASYNC(src, PROC_REF(synchronously_undock), no_interrupt, on_finish, timeout)
	// we assume that the interruption / beginning of a new cycle will only increment by 1.
	if(. != docking_cycle - 1)
		stack_trace("unexpected behavior - docking cycle incremented by more than 1. a core assumption made when writing this code was violated.")
	. = docking_cycle

/**
 * immediately interrupt docking
 */
/datum/shuttle_controller/proc/interrupt_docking()
	if(docking_state != SHUTTLE_DOCKING_STATE_DOCKING)
		return
	++docking_cycle

/**
 * immediately interrupt docking
 */
/datum/shuttle_controller/proc/interrupt_undocking()
	if(docking_state != SHUTTLE_DOCKING_STATE_UNDOCKING)
		return
	++docking_cycle

/**
 * * returns existing op id if already docking
 * * interrupts undocking automatically
 *
 * @params
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 * * initial_callbacks - initial list of callbacks to invoke on finish. can be a single callback or a list.
 * * timeout - max time allowed.
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/synchronously_dock(no_interrupt, list/datum/callback/initial_callbacks, timeout = 60 SECONDS)
	// we should only increase cycle by 1
	#warn impl

/**
 * * returns existing op id if already undocking
 * * interrupts docking automatically	// wait for cycle to end or for us to not be in a docking state

 *
 * @params
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 * * initial_callbacks - initial list of callbacks to invoke on finish. can be a single callback or a list.
 * * timeout - max time allowed.
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/synchronously_undock(no_interrupt, list/datum/callback/initial_callbacks, timeout = 60 SECONDS)
	// we should only increase cycle by 1
	#warn impl

/**
 * block on a docking op
 *
 * * if cycle isn't present, we will immediately succeed if docking passes
 * * if cycle isn't present, we will immediately fail if we are not either docking or docked
 * * if cycle is present, we will return STATUS_EXPIRED if it passed, as we cannot know if the original cycle is the reason for success / fail.
 *
 * note: we can only return STATUS_SUCCESS, STATUS_FAILE, and STATUS_EXPIRED.
 *       ABORTED, TIMEOUT, and INVALID will never be fired from this because
 *       we don't have the information embedded in our variables.
 *
 * @params
 * * cycle - the operation id
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/block_on_docking(cycle)
	// ensure right cycle if there is one set
	if(cycle && (docking_cycle != cycle))
		return SHUTTLE_DOCKING_STATUS_EXPIRED
	// if already docked, succeed. if not docked or dockign, fail.
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_DOCKED)
			return SHUTTLE_DOCKING_STATUS_SUCCESS
		if(SHUTTLE_DOCKING_STATE_DOCKING)
		else
			return SHUTTLE_DOCKING_STATUS_FAILED
	// wait for cycle to end or for us to not be in a docking state
	while((!cycle || (docking_cycle == cycle)) && (docking_state == SHUTTLE_DOCKING_STATE_DOCKING))
		stoplag(1)
	// if cycle is wrong, exit
	if(cycle && (docking_cycle != cycle))
		return SHUTTLE_DOCKING_STATUS_EXPIRED
	// ensure we are docked
	return docking_state == SHUTTLE_DOCKING_STATE_DOCKING? SHUTTLE_DOCKING_STATUS_SUCCESS : SHUTTLE_DOCKING_STATUS_FAILED

/**
 * block on an undocking op
 *
 * * if cycle isn't present, we will immediately succeed if undocking passes
 * * if cycle isn't present, we will immediately fail if we are not either undocking or undocked
 * * if cycle is present, we will return STATUS_EXPIRED if it passed, as we cannot know if the original cycle is the reason for success / fail.
 *
 * note: we can only return STATUS_SUCCESS, STATUS_FAILE, and STATUS_EXPIRED.
 *       ABORTED, TIMEOUT, and INVALID will never be fired from this because
 *       we don't have the information embedded in our variables.
 *
 * @params
 * * cycle - the operation id
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/block_on_undocking(cycle)
	// ensure right cycle if there is one set
	if(cycle && (docking_cycle != cycle))
		return SHUTTLE_DOCKING_STATUS_EXPIRED
	// if already docked, succeed. if not docked or dockign, fail.
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_DOCKED)
			return SHUTTLE_DOCKING_STATUS_SUCCESS
		if(SHUTTLE_DOCKING_STATE_DOCKING)
		else
			return SHUTTLE_DOCKING_STATUS_FAILED
	// wait for cycle to end or for us to not be in a docking state
	while((!cycle || (docking_cycle == cycle)) && (docking_state == SHUTTLE_DOCKING_STATE_DOCKING))
		stoplag(1)
	// if cycle is wrong, exit
	if(cycle && (docking_cycle != cycle))
		return SHUTTLE_DOCKING_STATUS_EXPIRED
	// ensure we are docked
	return docking_state == SHUTTLE_DOCKING_STATE_DOCKING? SHUTTLE_DOCKING_STATUS_SUCCESS : SHUTTLE_DOCKING_STATUS_FAILED

/**
 * register a callback to fire on docking completion
 *
 * * if cycle isn't present, we will immediately succeed if docking passes
 * * if cycle isn't present, we will immediately fail if we are not either docking or docked
 * * if cycle is present, we will return STATUS_EXPIRED if it passed, as we cannot know if the original cycle is the reason for success / fail.
 * * otherwise, behavior will be the same as if this callback was registered during the beginning of the cycle
 *
 * @params
 * * callback - what to call
 * * cycle - the operation id to filter by, if any
 */
/datum/shuttle_controller/proc/on_docking(datum/callback/callback, cycle)
	// ensure right cycle if there is one set
	if(cycle && (docking_cycle != cycle))
		callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_EXPIRED, null)
	// if already docked, succeed. if not docked or dockign, fail.
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_DOCKED)
			callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_SUCCESS, SHUTTLE_DOCKING_STATE_DOCKING)
			return
		if(SHUTTLE_DOCKING_STATE_DOCKING)
		else
			callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_FAILED, SHUTTLE_DOCKING_STATE_DOCKING)
			return
	// we are currently docking and on the right cycle. add us to the callbacks list.
	docking_callbacks += callback

/**
 * register a callback to fire on undocking completion
 *
 * * if cycle isn't present, we will immediately succeed if undocking passes
 * * if cycle isn't present, we will immediately fail if we are not either undocking or undocked
 * * if cycle is present, we will return STATUS_EXPIRED if it passed, as we cannot know if the original cycle is the reason for success / fail.
 * * otherwise, behavior will be the same as if this callback was registered during the beginning of the cycle
 *
 * @params
 * * callback - what to call
 * * cycle - the operation id to filter by, if any
 */
/datum/shuttle_controller/proc/on_undocking(datum/callback/callback, cycle)
	// ensure right cycle if there is one set
	if(cycle && (docking_cycle != cycle))
		callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_EXPIRED, null)
	// if already undocked, succeed. if not undocked or undocking, fail.
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_UNDOCKED)
			callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_SUCCESS, SHUTTLE_DOCKING_STATE_UNDOCKING)
			return
		if(SHUTTLE_DOCKING_STATE_UNDOCKING)
		else
			callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_FAILED, SHUTTLE_DOCKING_STATE_UNDOCKING)
			return
	// we are currently docking and on the right cycle. add us to the callbacks list.
	docking_callbacks += callback

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

//* Transit - Configuration *//

/**
 * default transit time for a dock
 */
/datum/shuttle_controller/proc/default_transit_time_for_dock(obj/shuttle_dock/dock)
	return transit_time_default

//* Transit - Main *//

/**
 * begin a transit cycle
 *
 * * this is a very low level proc. you should know what you're doing before doing this.
 */
/datum/shuttle_controller/proc/run_transit_cycle(datum/shuttle_transit_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	run_transit_cycle_impl(cycle)

/**
 * internal proc; do not use
 */
/datum/shuttle_controller/proc/run_transit_cycle_impl(datum/shuttle_transit_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	PRIVATE_PROC(TRUE)
	#warn impl

/**
 * immediate transit towards a specific dock
 *
 * * immediately jumps us into transit space, or the target dock
 * * all docking / traversal events are marked as force-on-fail with a hard timeout equal to [jump_time]
 * * this means if anything takes longer than that it's immediately forced past.
 * * this does not flag the transit as DO_NOT_INTERRUPT, so if [transit_time] isn't instant the user can abort this!
 * * mostly a helper proc
 */
/datum/shuttle_controller/proc/perform_immediate_transit(
	obj/shuttle_dock/dock,
	obj/shuttle_port/align_with_port,
	centered,
	direction,
	transit_flags,
	list/datum/callback/on_transit_callbacks,
	traversal_flags_source = NONE,
	traversal_flags_target = NONE,
	transit_time = 0,
	jump_time = 0,
)
	traversal_flags_source |= SHUTTLE_TRAVERSAL_FLAGS_FORCE_ON_FAIL
	traversal_flags_target |= SHUTTLE_TRAVERSAL_FLAGS_FORCE_ON_FAIL
	return transit_towards_dock(
		dock,
		align_with_port,
		centered,
		direction,
		transit_flags,
		on_transit_callbacks,
		traversal_flags_source,
		traversal_flags_target,
		transit_time = transit_time,
		jump_time = jump_time,
	)

/**
 * normal transit cycle towards a specific dock.
 */
/datum/shuttle_controller/proc/transit_towards_dock(
	obj/shuttle_dock/dock,
	obj/shuttle_port/align_with_port,
	centered,
	direction,
	transit_flags,
	list/datum/callback/on_transit_callbacks,
	traversal_flags_source,
	traversal_flags_target,
	dock_timeout,
	traversal_timeout,
	transit_time,
	jump_time,
)
	var/datum/shuttle_transit_cycle/cycle = new(
		dock,
		align_with_port,
		centered,
		direction,
		transit_flags,
		on_transit_callbacks,
		traversal_flags_source,
		traversal_flags_target,
		dock_timeout,
		traversal_timeout,
		transit_time,
		jump_time,
	)
	cycle.initialize()
	return run_transit_cycle(cycle)
	cycle.set_transit_flags(transit_flags)
	cycle.set_source_traversal_flags(traversal_flags_source)
	cycle.set_target_traversal_flags(traversal_flags_target)

#warn below

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

#warn above

//* Transit - Hooks *//

/**
 * called on transit begint
 *
 * @params
 * * cycle - the transit cycle
 * * redirected - this is from us getting another transit_towards_dock while transiting
 */
/datum/shuttle_controller/proc/on_transit_begin(datum/shuttle_transit_cycle/cycle, redirected)
	return

/**
 * called on transit success
 *
 * @params
 * * cycle - the transit cycle
 * * status - transit status
 */
/datum/shuttle_controller/proc/on_transit_end(datum/shuttle_transit_cycle/cycle, status)
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
	#warn uh oh
	return
