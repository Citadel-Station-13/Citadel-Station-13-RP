//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * primary station map
 *
 * this is what's loaded at init. this determines what other maps initially load.
 */
/datum/map/station
	abstract_type = /datum/map/station
	category = "Stations"

	/// force world to be bigger width
	var/world_width
	/// force world to be bigger height
	var/world_height

	/// allow random picking if no map set
	/// used to exclude indev maps
	var/allow_random_draw = TRUE

	//* Game World *//
	/// world_location's this is considered
	/// set to id, or typepath to parse into id in New()
	///
	/// * if null, the storyteller system will be inactive.
	/// * if null, many game systems might be inoperational, including things like supply factions.
	var/list/world_location_ids = list(
		/datum/world_location/frontier::id,
	)
	/// world faction this is primarily under the control of
	/// set to id, or typepath to parse into id in New()
	/// this is considered the primary, player-facing faction of the round, with other factions being 'off'-maps.
	///
	/// * if null, the storyteller system will be inactive.
	/// * seriously you don't want this to be null.
	var/world_faction_id = /datum/world_faction/corporation/nanotrasen::id
