//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

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

	// todo: storytellers
	/// * set to typepath to initialize a storyteller faction.
	// var/datum/storyteller_faction/c_storyteller
	// todo: supply faction
	/// * set to typepath to initialize a supply faction.
	// var/datum/supply_faction/c_supply
	/// * set to typepath to initialize an economy faction.
	var/datum/economy_faction/c_economy = /datum/economy_faction

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
	create_economy_faction()
	#warn hook

/datum/world_faction/proc/create_economy_faction() as /datum/economy_faction
	RETURN_TYPE(/datum/economy_faction)
	if(!ispath(c_economy))
		return
	var/datum/economy_faction/creating = SSeconomy.allocate_faction(
		economy_faction,
		id,
	)
	creating.abbreviation = abbreviation
	c_economy = creating
	return creating

/**
 * called after all active map world factions are initialized.
 * * allows for resolving cross-faction dependencies safely.
 */
/datum/world_faction/proc/post_prime()
	#warn hook
