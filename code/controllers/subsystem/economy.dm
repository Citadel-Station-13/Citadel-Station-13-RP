//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * todo: good description of what the fuck this does
 */
SUBSYSTEM_DEF(economy)
	name = "Economy"
	init_order = INIT_ORDER_ECONOMY
	subsystem_flags = SS_NO_FIRE

	/// factions by id
	var/list/faction_lookup = list()
	/// account by account number
	/// * account numbers are text-ified
	/// todo: byond 516 alist()
	var/list/account_lookup = list()
	/// keyed accounts
	/// * this is for global accounts, not factional accounts
	var/list/keyed_accounts = list()

/datum/subsystem/economy/proc/resolve_faction(id) as /datum/economy_faction
	return faction_lookup[id]

/datum/subsystem/economy/proc/resolve_account_number(number) as /datum/economy_account
	return account_lookup["[number]"]

/**
 * @params
 * * id - the key of the account
 * * faction - the faction to use, if any; a faction, id, or path are all valid.
 */
/datum/subsystem/economy/proc/resolve_keyed_account(id, datum/economy_faction/faction) as /datum/economy_account
	if(faction)
		var/datum/economy_faction/resolved_faction
		if(istext(faction))
			resolved_faction = faction_lookup[faction]
		else if(ispath(faction))
			resolved_faction = faction_lookup[initial(faction)]
		else
			resolved_faction = faction
		return faction?.keyed_accounts[id]
	else
		return keyed_accounts[id]

/**
 * Initializes a faction with a given ID and returns it.
 *
 * **This is the only place where factions should be created.**
 * **You must use named parameters.**
 *
 * @return /datum/economy_faction, or null on an error
 */
/datum/subsystem/economy/proc/allocate_faction(with_id) as /datum/economy_faction
	RETURN_TYPE(/datum/economy_faction)
	#warn impl

/**
 * Allocates an account.
 *
 * **This is the only place where accounts should be created.**
 * **You must use named parameters.**
 *
 * @return /datum/economy_account, or null on an error
 */
/datum/subsystem/economy/proc/allocate_account(datum/economy_faction/for_faction, with_key) as /datum/economy_account
	RETURN_TYPE(/datum/economy_account)
	#warn impl
