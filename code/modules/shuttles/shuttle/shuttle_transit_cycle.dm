//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * stores data about the current transit cycle
 */
/datum/shuttle_transit_cycle
	//* state / processing *//
	/// current stage
	var/transit_stage
	/// timerid for movement
	///
	/// * only set once in transit; takeoff is done via spinlocks.
	/// todo: cpu used shouldn't be counted against SStimers.
	var/transit_timer_id
	/// behavior flags
	var/transit_flags = NONE

	//* hooking *//
	/// callbacks for when transit is done
	///
	/// * called with (controller: src, target: transit_target_dock, status: SHUTTLE_TRANSIT_STATUS_*)
	var/list/datum/callback/transit_finish_callbacks

	//* visuals *//
	/// transit visuals
	var/list/obj/effect/temporary_effect/shuttle_landing/transit_warning_visuals
	/// timerid for making warning bubbles
	///
	/// * only set once in transit; takeoff is done via spinlocks.
	/// * instant transits will not make visuals!
	var/transit_visual_timer_id

	//* arbitrary information *//
	/// source information;
	/// this is arbitrarily set by a shuttle controller type
	/// and fed back into it on transit failure. this tells the shuttle controller
	/// where to send the shuttle should things fail or get aborted.
	///
	/// * example: overmap controller usually feeds in the target overmap entity, so if transit is interrupted we go back to space ontop of it
	/// * this is also used if someone aborts the transit!
	var/transit_abort_source_hint
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

#warn oh no
