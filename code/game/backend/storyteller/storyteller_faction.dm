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
	var/list/available_pawns = list()

	//* active / instance
	/// active instances of pawns
	var/list/datum/storyteller_pawn/active_pawns
	/// created but not yet spawned / instanced instances of pawns
	var/list/datum/storyteller_pawn/pending_pawns

/datum/storyteller_faction/proc/from_world_faction(datum/world_faction/faction)
	src.name = faction.name

#warn impl
