//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Economy holder for factions. More generically, this is just a way to
 * group different accounts. Access to bank uplinks is determined by faction.
 */
/datum/economy_faction
	/// our ID
	var/id
	/// our abbreviation, used for displays
	/// * technically optional but it's a real bad idea to not have this
	var/abbreviation = "UNKW"
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
 * * Do not modify passed back list!
 */
/datum/economy_faction/proc/uplink_get_managed_accounts() as /list
	return list()

/**
 * Gets accounts an uplink can access that are root accounts to fund from / withdraw into
 * * This is stuff like station and department accounts
 * * Do not modify passed back list!
 */
/datum/economy_faction/proc/uplink_get_managed_source_accounts() as /list
	return list()

/**
 * Gets the effective root account for an uplink.
 * * The root account is what is the source / target for account creation funding / account deletion fund recovery.
 */
/datum/economy_faction/proc/uplink_get_effective_root_account() as /datum/economy_account
	return null
