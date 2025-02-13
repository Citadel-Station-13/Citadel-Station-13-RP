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

/datum/subsystem/economy/proc/resolve_faction(id) as /datum/economy_faction
	return faction_lookup[id]

/datum/subsystem/economy/proc/resolve_account(number) as /datum/economy_account
	return account_lookup["[number]"]

#warn impl

