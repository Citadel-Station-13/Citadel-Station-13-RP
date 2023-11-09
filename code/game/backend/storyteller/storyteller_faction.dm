//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * stores a faction for usage in the storyteller
 */
/datum/storyteller_faction
	abstract_type = /datum/storyteller_faction

	/// faction name
	var/name = "Unknown"

	/// available pawns, by typepath or id
	var/list/pawns = list()

/datum/storyteller_faction/proc/from_world_faction(datum/world_faction/faction)
	src.name = faction.name

#warn impl
