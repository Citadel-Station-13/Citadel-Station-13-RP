//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * stores data about the current transit cycle
 *
 * * we currently use spinlocks and executes with timerless fashion
 *
 * todo: this, and docking, should maybe be on SSshuttles instead of spinlocks?
 */
/datum/shuttle_transit_cycle
	//* state / processing *//
	/// current stage
	var/stage = SHUTTLE_TRANSIT_STAGE_IDLE
	/// behavior flags
	var/transit_flags = NONE
	/// the controller we're executing on
	var/datum/shuttle_controller/controller
	/// running?
	var/running = FALSE
	/// aborting?
	var/aborting = FALSE
	/// finished? also if aborted; we do not allow reuse of a cycle for now
	var/finished = FALSE

	//* hooking *//
	/// callbacks for when transit is done
	///
	/// * called with (controller: src, target: transit_target_dock, status: SHUTTLE_TRANSIT_STATUS_*)
	var/list/datum/callback/finish_callbacks

	//* visuals *//
	/// transit visuals
	var/list/obj/effect/temporary_effect/warning_visuals

	//* configuration *//
	/// how long to spend in transit
	///
	/// * transit can be aborted if [no_abort_mid_transit] isn't set
	/// * this time includes spool-up time to jump to target
	var/transit_duration = 0
	/// how long to spend spooling up / taking off
	///
	/// * takeoff can be aborted during this
	/// * landing can be aboted during this
	/// * time needed to jump out of source, basically
	var/jump_duration = 4 SECONDS
	/// the timeout allowed by docking / undocking
	///
	/// * if timeout expires, we will potentially have the transit cycle interrupted, even if it's no interrupt
	/// * don't set this too low because the user can only force inside this timeout
	var/dock_timeout = 30 SECONDS
	/// the timeout allowed by takeoff / landing
	///
	/// * if timeout expires, we will potentially have the transit cycle interrupted, even if it's no interrupt
	/// * don't set this too low because the user can only force inside this timeout
	var/traversal_timeout = 15 SECONDS
	/// the traversal flags used at the source
	var/traversal_flags_source = NONE
	/// the traversal flags used at the destination
	var/traversal_flags_target = NONE

	//* computed as we go *//
	/// world.time we should arrive at destination
	///
	/// * only set once in transit
	var/arrival_time

	//* target information *//
	/// for lazy docking support - dock has been resolved
	var/target_resolved = FALSE
	/// for lazy docking support - the callback to call for resolving the target
	///
	/// * called past PNR (so when shuttle is about to translate)
	/// * called with (shuttle transit cycle)
	/// * the callback should set [target_dock], [target_centered], [target_direction], [target_port] on us as needed
	/// * the callback should return FALSE if it fails to resolve target
	/// * it is a fatal error to fail to resolve target on the final translation to the new dock. if this happens, the cycle is terminated and the shuttle orphaned.
	var/datum/callback/target_resolver
	/// called if we are aborted to resolve where to go
	///
	/// * if this doesn't exist, we are orphaned (terminated).
	/// * if this doesn't exist, we are by default, DO_NOT_INTERRUPT
	/// * the callback should set [target_dock], [target_centered], [target_direction], [target_port] on us as needed
	/// * the callback should return FALSE if it fails to resolve target
	/// * if this fails to resolve target, we are orphaned (terminated).
	var/datum/callback/target_aborted_resolver
	/// dock we're going towards
	///
	/// this dock will have us set as inbound, which should
	/// protect it from everything else
	///
	/// * this won't be done if we have TRANSIT_NO_MUTEX in our flags.
	var/obj/shuttle_dock/target_dock
	/// are we doing a centered landing on said dock?
	/// if not, and there's no aligning port, we align our anchor's coordinates on the dock's coordinates.
	var/target_centered
	/// which direction should we land, for centered?
	var/target_direction
	/// if not centered, are we aligning with a specific port?
	var/obj/shuttle_port/target_port

/datum/shuttle_transit_cycle/New(
	obj/shuttle_dock/dock,
	obj/shuttle_port/with_port,
	centered,
	direction,
	transit_flags,
	list/datum/callback/callbacks,
	traversal_flags_source,
	traversal_flags_target,
	dock_timeout,
	traversal_timeout,
	transit_time,
	jump_time,
)
	src.target_dock = dock
	src.target_port = with_port
	src.target_direction = direction
	src.target_centered = centered
	src.finish_callbacks = callbacks || list()
	src.transit_flags = transit_flags
	src.traversal_flags_source = traversal_flags_source
	src.traversal_flags_target = traversal_flags_target
	src.dock_timeout = dock_timeout
	src.traversal_timeout = traversal_timeout
	src.transit_duration = transit_time
	src.jump_duration = jump_time

/datum/shuttle_transit_cycle/Destroy()
	if(!finished)
		terminate()
	return ..()

/**
 * callbacks are immediately invoked if we are already done.
 */
/datum/shuttle_transit_cycle/proc/register_on_finish(list/datum/callback/callback_or_callbacks)
	#warn impl

/datum/shuttle_transit_cycle/proc/set_transit_flags(new_flags)
	src.transit_flags = new_flags

/datum/shuttle_transit_cycle/proc/set_source_traversal_flags(new_flags)
	#warn handle it if we're already mid-takeoff
	src.traversal_flags_source = new_flags

/datum/shuttle_transit_cycle/proc/set_target_traversal_flags(new_flags)
	#warn handle it if we're already mid-landing
	src.traversal_flags_target = new_flags

/datum/shuttle_transit_cycle/proc/set_transit_duration(new_duration)
	#warn handle mid-transit
	src.transit_duration = new_duration

/datum/shuttle_transit_cycle/proc/set_jump_duration(new_duration)
	#warn handle mid-jump
	src.jump_duration = new_duration

/datum/shuttle_transit_cycle/proc/set_dock_timeout(new_timeout)
	#warn handle mid dock
	src.dock_timeout = new_timeout

/datum/shuttle_transit_cycle/proc/set_traversal_timeout(new_timeout)
	#warn handle mid travversal
	src.traversal_timeout = new_timeout

/**
 * this **will** redirect the shuttle midflight!
 *
 * * it is not allowed to call this when our stage is already 'landing' or 'docking'!
 */
/datum/shuttle_transit_cycle/proc/set_target(obj/shuttle_dock/dock, obj/shuttle_port/with_port, centered, direction)
	#warn check for in-transit
	src.target_resolved = TRUE
	src.target_dock = dock
	src.target_port = with_port
	src.target_centered = centered
	src.target_direction = direction

/**
 * for overmaps controllers.
 */
/datum/shuttle_transit_cycle/proc/set_lazy_target(datum/callback/target_resolver)
	#warn check for in-transit
	src.target_resolver = target_resolved
	src.target_resolved = FALSE
	src.target_centered = src.target_direction = src.target_dock = src.target_port = null

/datum/shuttle_transit_cycle/proc/is_initialized()
	return !isnull(stage)

/**
 * call to setup cycle
 *
 * this should be called before being fed into run_transit_cycle on shuttle controllers!
 */
/datum/shuttle_transit_cycle/proc/initialize()
	ASSERT(isnull(stage))
	// nothing yet

/**
 * called right before we jump out of our transit dock (or directly to the destination if not using transit)
 *
 * * can be called in other circumstances too, but the callback is free to refuse if it isn't right before our arrival.
 */
/datum/shuttle_transit_cycle/proc/resolve_target()
	SHOULD_NOT_SLEEP(TRUE) // absolutely fucking not!
	if(target_resolved)
		return
	if(!target_resolver.Invoke(src))
		return
	if(!target_dock)
		stack_trace("target resolver didn't fail yet we don't have a dock..?")
		return
	target_resolved = TRUE

/**
 * immediate termination
 *
 * also called on finish!
 */
/datum/shuttle_transit_cycle/proc/terminate(status)
	SHOULD_NOT_SLEEP(TRUE)
	if(isnull(status))
		if(aborting)
			status = SHUTTLE_TRANSIT_STATUS_CANCELLED
		else
			status = SHUTTLE_TRANSIT_STATUS_FAILED
	#warn fire callbacks
	if(finished)
		return TRUE // already should be gone
	finished = TRUE
	cleanup()
	qdel(src)
	return TRUE

/**
 * cleans everything up
 */
/datum/shuttle_transit_cycle/proc/cleanup()
	cleanup_warning_visuals()

/**
 * graceful abort, tries to kick the shuttle to elsewhere
 *
 * @return TRUE / FALSE
 */
/datum/shuttle_transit_cycle/proc/abort()
	SHOULD_NOT_SLEEP(TRUE)
	if(aborting)
		return TRUE // already aborting
	switch(stage)
		if(SHUTTLE_TRANSIT_STAGE_DOCK)
			return FALSE
	src.target_resolved = FALSE
	src.target_centered = src.target_direction = src.target_dock = src.target_port = null
	if(!src.target_aborted_resolver?.Invoke(src))
		terminate()
	if(!src.target_dock)
		terminate()
		stack_trace("didn't fail to resolve abort dock, but still no dock")
	aborting = TRUE
	return TRUE

/datum/shuttle_transit_cycle/proc/start()
	SHOULD_NOT_SLEEP(TRUE)
	#warn impl

/datum/shuttle_transit_cycle/proc/why_isnt_this_a_subsystem()
	if(finished)
		CRASH("attempted to move to main loop while already finished")

	// ensure we're in idle
	ASSERT(stage == SHUTTLE_TRANSIT_STAGE_IDLE)

	// undock
	stage = SHUTTLE_TRANSIT_STAGE_UNDOCK

	// takeoff
	stage = SHUTTLE_TRANSIT_STAGE_TAKEOFF

	// transit
	stage = SHUTTLE_TRANSIT_STAGE_FLIGHT

	// land
	stage = SHUTTLE_TRANSIT_STAGE_LANDING

	// dock
	stage = SHUTTLE_TRANSIT_STAGE_DOCK

	#warn impl

	// we got through everything, fire callbacks
	terminate(SHUTTLE_TRANSIT_STATUS_SUCCESS)

#warn oh no

//* Visuals *//

/datum/shuttle_transit_cycle/proc/make_warning_visuals()
	resolve_target()
	cleanup_warning_visuals()

	if(!target_resolved)
		return

	var/list/motion = controller.shuttle.anchor.calculate_resultant_motion_from_docking(
		target_dock,
		target_port,
		target_centered,
		target_direction,
	)

	warning_visuals = list()

	for(var/turf/turf as anything in shuttle.anchor.aabb_ordered_turfs_at(motion, motion[4]))
		var/obj/effect/temporary_effect/shuttle_landing/landing_effect = new(turf)
		warning_visuals += landing_effect

/datum/shuttle_transit_cycle/proc/cleanup_warning_visuals()
	QDEL_LIST(warning_visuals)
