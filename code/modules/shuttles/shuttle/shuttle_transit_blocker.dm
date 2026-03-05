//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/shuttle_transit_blocker
	/**
	 * The hook blocking the transit, if any
	 */
	var/datum/shuttle_hook/hook
	/**
	 * The transit stage being blocked
	 */
	var/datum/shuttle_transit_stage/blocked

	/// Forcing this may be dangerous
	var/forcing_could_be_dangerous = FALSE

#warn impl
