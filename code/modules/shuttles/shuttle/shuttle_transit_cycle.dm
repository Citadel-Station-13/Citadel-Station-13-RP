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
	var/transit_stage
	/// behavior flags
	var/transit_flags = NONE
	/// the controller we're executing on
	var/datum/shuttle_controller/controller
	/// running?
	var/running = FALSE

	//* hooking *//
	/// callbacks for when transit is done
	///
	/// * called with (controller: src, target: transit_target_dock, status: SHUTTLE_TRANSIT_STATUS_*)
	var/list/datum/callback/finish_callbacks

	//* visuals *//
	/// transit visuals
	var/list/obj/effect/temporary_effect/warning_visuals

	//* arbitrary information *//
	/// source information;
	/// this is arbitrarily set by a shuttle controller type
	/// and fed back into it on transit failure. this tells the shuttle controller
	/// where to send the shuttle should things fail or get aborted.
	///
	/// * example: overmap controller usually feeds in the target overmap entity, so if transit is interrupted we go back to space ontop of it
	/// * this is also used if someone aborts the transit!
	var/abort_source_hint
	#warn hook

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
	/// dock we're going towards
	/// this dock will have us set as inbound, which should
	/// protect it from everything else
	///
	/// if the dock is occupied by the time we get there,
	/// that is **undefined behavior.**
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
	src.target_dock = dock
	src.target_port = with_port
	src.target_centered = centered
	src.target_direction = direction

/datum/shuttle_transit_cycle/proc/is_initialized()
	return !isnull(transit_stage)

/**
 * call to setup cycle
 * 
 * this should be called before being fed into run_transit_cycle on shuttle controllers!
 */
/datum/shuttle_transit_cycle/proc/initialize()
	ASSERT(isnull(transit_stage))

	transit_stage = SHUTTLE_TRANSIT_STAGE_UNDOCK

#warn oh no
