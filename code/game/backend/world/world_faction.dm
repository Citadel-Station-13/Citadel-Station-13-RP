//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * a faction in the in-game universe
 */
/datum/world_faction
	abstract_type = /datum/world_faction

	/// name
	var/name
	/// id - must be unique
	var/id

	/// storyteller faction path to init, if any
	// var/datum/storyteller_faction/storyteller_faction
	// todo: supply faction
	/// supply faction path to init, if any
	// var/datum/supply_faction/supply_faction

	/// location ids we're in
	var/list/location_ids = list(
		/datum/world_location/frontier::id,
	)

/**
 * called if we're on the active map so we create all our datums
 */
/datum/world_faction/proc/prime()
	return
