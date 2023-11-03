//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * a faction in the in-game universe
 */
/datum/world_faction
	abstract_type = /datum/world_faction

	/// id - must be unique
	var/id

	/// storyteller faction path to init, if any
	var/datum/storyteller_faction/faction_story
