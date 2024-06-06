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

	/// our entity descriptor
	/// hard reference, set to typepath for autoinit
	var/datum/storyteller_entity/entity

	/// faction we belong to - hard reference
	var/datum/storyteller_faction/faction
	/// our storyteller location descriptor
	/// this may be set during placement - because we don't have a distinction between 'instance' and 'describe'
	/// for now.
	var/datum/storyteller_location/location

	/// inherent chaos to have this in (not danger)
	/// inherent danger is intentionally omitted as it doesn't make sense given our definition of danger (which requires relativity to another pawn)
	var/inherent_chaos = 0

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
/datum/storyteller_pawn/proc/evaluate_hostility(datum/storyteller_state/state, datum/storyteller_pawn/enemy)

/**
 * checks if the map is suitable for spawning this
 */
/datum/storyteller_pawn/proc/check_prerequisites(datum/storyteller_state/state)

/**
 * performs a spawn
 */
/datum/storyteller_pawn/proc/instance(datum/storyteller_state/state)

#warn impl
