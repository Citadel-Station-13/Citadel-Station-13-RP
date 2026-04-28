//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A docking cycle.
 * * Docking cycles are event-driven.
 */
/datum/shuttle_docking_cycle
	var/set_state_on_success = SHUTTLE_DOCKING_STATE_UNKNOWN
	var/set_state_on_failure = SHUTTLE_DOCKING_STATE_UNKNOWN
	var/set_state_in_progress = SHUTTLE_DOCKING_STATE_UNKNOWN

/datum/shuttle_docking_cycle

/datum/shuttle_docking_cycle


/datum/shuttle_docking_cycle

/datum/shuttle_docking_cycle


#warn impl

/datum/shuttle_docking_cycle/undock
	set_state_on_success = SHUTTLE_DOCKING_STATE_UNDOCKED
	set_state_in_progress = SHUTTLE_DOCKING_STATE_UNDOCKING

/datum/shuttle_docking_cycle/dock
	set_state_on_success = SHUTTLE_DOCKING_STATE_DOCKED
	set_state_in_progress = SHUTTLE_DOCKING_STATE_DOCKING
