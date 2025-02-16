//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Economy holder for factions.
 *
 * * These are spawned by a `/datum/world_faction`
 * * These always have the same ID as their parent world faction
 * * The system technically allows for unbound economy factions
 *   that aren't linked to a world faction, but you must take extreme
 *   care to not cause an ID conflict. Failure to do so will result in
 *   undefined behavior.
 */
/datum/economy_faction
	/// our ID
	var/id
	/// our abbreviation
	/// * technically optional but it's a real bad idea to not have this
	var/abbreviation
	/// keyed accounts
	/// * these accounts, while having an account number,
	///   may be accessed by key.
	var/list/keyed_accounts = list()
	/// all accounts belonging to, as a flat list
	var/list/datum/economy_account/accounts = list()

#warn impl

/**
 * Gets a random terminal name for this faction
 * * This is for non-simulated terminals only! This doesn't ensure a non-collision with
 *   an instanced terminal, nor does it track any state / permeance.
 */
/datum/economy_faction/proc/random_ephemeral_terminal_name()
	#warn impl

