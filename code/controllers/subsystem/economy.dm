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

	/// fallback vendor account
	var/datum/economy_account/fallback_vendor_account

/datum/controller/subsystem/economy/Initialize()
	setup_economy_legacy()
	initialize_fallback_vendor_account()
	return ..()

/datum/controller/subsystem/economy/proc/initialize_fallback_vendor_account()
	var/datum/economy_account/allocating = allocate_account()
	allocating.owner_name = "Vendor"
	fallback_vendor_account = allocating

//* Lookup *//

/datum/controller/subsystem/economy/proc/resolve_faction(id) as /datum/economy_faction
	RETURN_TYPE(/datum/economy_faction)
	return faction_lookup[id]

/datum/controller/subsystem/economy/proc/resolve_account(number) as /datum/economy_account
	RETURN_TYPE(/datum/economy_account)
	return account_lookup["[number]"]

/**
 * @params
 * * id - the key of the account
 * * faction - the faction to use, if any; a faction, id, or path are all valid.
 */
/datum/controller/subsystem/economy/proc/resolve_keyed_account(id, datum/economy_faction/faction) as /datum/economy_account
	RETURN_TYPE(/datum/economy_account)
	var/datum/economy_faction/resolved_faction
	if(istext(faction))
		resolved_faction = faction_lookup[faction]
	else if(ispath(faction))
		resolved_faction = faction_lookup[initial(faction)]
	else
		resolved_faction = faction
	return faction?.keyed_accounts[id]

/**
 * legacy: get the vendor account to send stuff to if a vendor doesn't have a specific
 * target account
 */
/datum/controller/subsystem/economy/proc/resolve_fallback_vendor_account() as /datum/economy_account
	RETURN_TYPE(/datum/economy_account)
	return fallback_vendor_account

/**
 * get the account of the main map
 */
/datum/controller/subsystem/economy/proc/resolve_station_account() as /datum/economy_account
	RETURN_TYPE(/datum/economy_account)
	return resolve_keyed_account(/datum/world_faction/core/station::id, /datum/world_faction/core/station::id)

//* Allocation *//

/**
 * Initializes a faction with a given ID and returns it.
 *
 * **This is the only place where factions should be created.**
 * **You must use named parameters.**
 *
 * @return /datum/economy_faction, or null on an error
 */
/datum/controller/subsystem/economy/proc/allocate_faction(with_id) as /datum/economy_faction
	RETURN_TYPE(/datum/economy_faction)
	#warn impl

/**
 * Allocates an account.
 *
 * * **This is the only place where accounts should be created.**
 * * **You must use named parameters.**
 *
 * @params
 * * for_faction - (optional) for a given faction.
 * * with_key - (optional) with a given key for that faction, or if factionless, a global key.
 *
 * @return /datum/economy_account, or null on an error
 */
/datum/controller/subsystem/economy/proc/allocate_account(datum/economy_faction/for_faction, with_key) as /datum/economy_account
	RETURN_TYPE(/datum/economy_account)
	#warn impl

#warn impl all

//* Terminals *//

/**
 * Get a round-stable terminal ID.
 *
 * * Terminal IDs must be globally unique across all rounds and economy factions.
 * * Terminal IDs should be player-readable.
 * * Do not randomly call this for ephemerals unless you know what you're doing! You can
 *   exhaust the available round-pool of terminal IDs.
 */
/datum/controller/subsystem/economy/proc/generate_round_stable_terminal_id()
	#warn impl

//* Misc *//

/**
 * Best-effort attempt to pick a random account.
 *
 * @params
 * * require_faction - require a specific faction type / path / instance / id
 * * require_personal - do not return department / system accounts
 * * require_unlocked - do not return security locked ones
 */
/datum/controller/subsystem/economy/proc/pull_account_lottery(require_faction, require_personal, require_unlocked) as /datum/economy_account
	RETURN_TYPE(/datum/economy_account)
	var/list/datum/economy_account/picking_from = list()
	if(require_faction)
		var/datum/economy_faction/restrict_to_faction = resolve_faction(require_faction)
		for(var/datum/economy_account/account as anything in restrict_to_faction.accounts)
			if(account.security_lock && require_unlocked)
				continue
	else
		for(var/account_id in account_lookup)
			var/datum/economy_account/account = account_lookup[account_id]
			if(account.security_lock && require_unlocked)
				continue

	#warn impl, filter on faction / personal
	return length(picking_from) ? pick(picking_from) : null

//* Timestamping *//

/**
 * Gets the current time as galactic time (UTC + year offset)
 *
 * * Output will be ISO-8601
 */
/datum/controller/subsystem/economy/proc/timestamp_now()
	#warn impl

/**
 * Gets the current date as galactic time (UTC + year offset)
 */
/datum/controller/subsystem/economy/proc/timestamp_now_date()
	#warn impl

/**
 * Gets the current time as galactic time (UTC + year offset)
 */
/datum/controller/subsystem/economy/proc/timestamp_now_time()
	#warn impl
