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

/datum/economy_faction/Destroy()
	// doing this is a horrible idea but if someone's going to be unhinged..
	QDEL_LIST(accounts)
	keyed_accounts = null
	return ..()

/**
 * Gets a random terminal name for this faction
 * * This is for non-simulated terminals only! This doesn't ensure a non-collision with
 *   an instanced terminal, nor does it track any state / permeance.
 */
/datum/economy_faction/proc/random_ephemeral_terminal_name()
	if(!abbreviation)
		return "-- coders forgot to set abbreviation on faction id '[id]', point and laugh --"
	return "[abbreviation] ACH Node #[ECONOMY_GENERATE_EPHEMERAL_TERMINAL_ID]"

/**
 * Checks if an uplink can manage an account
 * * Assumed that the account is part of our faction. This will not check for you.
 * 
 * todo: access constraints, should that be here or in the uplink?
 */
/datum/economy_faction/proc/uplink_can_manage_account(datum/economy_account/account) as /datum/economy_account
	RETURN_TYPE(/datum/economy_account)
	#warn impl

/**
 * Gets accounts an uplink can access.
 *
 * todo: access constraints, should that be here or in the uplink?
 */
/datum/economy_faction/proc/uplink_get_managed_accounts() as /list
	RETURN_TYPE(/list)
	#warn impl

/**
 * Gets accounts an uplink can access that are root accounts to fund from / withdraw into
 * * This is stuff like station and department accounts
 *
 * todo: access constraints, should that be here or in the uplink?
 */
/datum/economy_faction/proc/uplink_get_managed_source_accounts() as /list
	RETURN_TYPE(/list)
	#warn impl
