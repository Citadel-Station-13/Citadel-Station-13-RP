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
	/// keyed accounts
	/// * lazy list
	/// * these accounts, while having an account number,
	///   may be accessed by key.
	var/list/keyed_accounts
	/// all accounts belonging to, as a flat list
	var/list/dautm/economy_account/accounts

#warn impl
