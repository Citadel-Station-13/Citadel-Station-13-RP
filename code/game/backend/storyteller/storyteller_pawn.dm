//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Mild misnomer
 *
 * This is not a 'pawn' as you'd expect
 *
 * This is basically something the storyteller can place into the world to influence it.
 * This is also able to be instantiated multiple times, and therefore 'rate our hostility to another instance of ourselves' is a valid question.
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
 * perform a hostility rating against another pawn when placed in two relative locations
 *
 * this can return negative numbers too, for placing, say, allied things.
 *
 * @return positive for 'hostile effect', negative for 'positive effect'
 */
/datum/storyteller_pawn/proc/rate_hostilities(datum/storyteller_state/state, datum/storyteller_pawn/enemy, datum/storyteller_faction/their_faction, datum/storyteller_faction/our_faction, datum/game_location/their_location, datum/game_location/our_location)

/**
 * checks if the map is suitable for spawning this
 */
/datum/storyteller_pawn/proc/check_prerequisites(datum/storyteller_state/state, datum/storyteller_faction/faction)

/**
 * performs a spawn
 */
/datum/storyteller_pawn/proc/instance(datum/storyteller_state/state, datum/storyteller_faction/faction, datum/game_location/location)
