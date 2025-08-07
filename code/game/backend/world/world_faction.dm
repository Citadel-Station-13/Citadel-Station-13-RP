//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * a faction in the in-game universe
 */
/datum/world_faction
	abstract_type = /datum/world_faction

	//* identity / basics *//

	/// name
	var/name = "Unknown Faction"
	/// public abbreviation; if null, it doesn't have one
	var/abbreviation
	/// id - must be unique
	var/id
	/// short description blurb
	var/desc = "A faction of some kind. Someone forgot to describe it."

	//* composition *//

	/// storyteller faction path to init, if any
	// var/datum/storyteller_faction/storyteller_faction
	// todo: supply faction
	/// supply faction path to init, if any
	// var/datum/supply_faction/supply_faction

	//* world simulation *//

	/// location ids we're in
	var/list/location_ids = list(
		/datum/world_location/frontier::id,
	)

	//* lore *//

	// at some point we'll want a way to encapsulate lore generation for these..

/**
 * called if we're on the active map so we create all our datums
 */
/datum/world_faction/proc/prime()
	return
