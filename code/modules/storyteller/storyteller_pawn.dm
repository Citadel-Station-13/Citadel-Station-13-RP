//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Mild misnomer
 *
 * This is not a 'pawn' as you'd expect
 *
 * This is basically something the storyteller can place into the world to influence it.
 */
/datum/storyteller_pawn
	abstract_type = /datum/storyteller_pawn

	/// id - must be globally, cross-round unique! leave blank for hardcoded instances if you want; it'll autogen from path
	/// this means you should not have any ids with /'s in them.
	var/id

/datum/storyteller_pawn/New()
	if(isnull(id))
		id = "[type]"

/**
 * checks if the map is suitable for spawning this
 */
/datum/storyteller_pawn/proc/check_spawn(datum/storyteller_state/state, datum/storyteller_faction/faction, list/errors)

