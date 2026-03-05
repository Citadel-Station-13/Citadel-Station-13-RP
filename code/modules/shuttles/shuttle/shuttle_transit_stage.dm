//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Stores data about a transit stage like docking / undocking / takeoff / landing
 */
/datum/shuttle_transit_stage
	/// stage enum
	var/stage = SHUTTLE_TRANSIT_STAGE_IDLE
	/**
	 * List of blockers
	 */
	var/list/datum/shuttle_transit_blocker/blockers

	/// timeout set on us
	/// * this isn't actually enforced on our side; it's enforced on the shuttle controller's side.
	var/timeout_duration
	/// world.time we will time out on
	var/timeout_at

#warn impl all
