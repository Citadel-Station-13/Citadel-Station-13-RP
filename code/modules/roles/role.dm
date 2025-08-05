//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * WIP
 *
 * todo: unified role system
 * todo: /datum/prototype? or maybe not? should this be loaded by map
 *       and shuttle / offmap / ghostrole spawner datums / objects?
 */
/datum/role
	abstract_type = /datum/role

	//* Basics *//

	/// unique id
	/// * must be globally unique, roles may be persistable!
	var/id

	//* Economy *//

	/// starting money multiplier
	var/economy_payscale = 1 * ECONOMY_PAYSCALE_JOB_DEFAULT
	/// automatically create an economy account
	/// * this will automatically bind to the role's world faction
	var/economy_create_account = TRUE
	/// economy accounts to give them the details to;
	/// format is a list of:
	/// * strings for global account keys
	/// * strings associated to a list of strings for keyed faction accounts
	var/list/economy_grant_account_details

//* Economy *//

/**
 * Get the multiplier to total starting funds in our personal account that we should impart.
 */
/datum/role/proc/get_economic_payscale()
	return economy_payscale

/**
 * Create and get economy account datum for someone.
 */
/datum/role/proc/economy_create_self_account(datum/mind/person) as /datum/economy_account
	RETURN_TYPE(/datum/economy_account)

	if(person.initial_economy_account_number)
		CRASH("attempted to create self account on someone already with 'initial_economy_account_number' set.")

	var/datum/economy_account/creating = SSeconomy.allocate_account()
	. = creating

	var/starting_amount = round(
		  get_economic_payscale() \
		* ECONOMY_PAYSCALE_BASE \
		* ECONOMY_PAYSCALE_MULT \
		* person.original_pref_economic_modifier \
		* gaussian(ECONOMY_PAYSCALE_RANDOM_MULT_MEAN, ECONOMY_PAYSCALE_RANDOM_MULT_DEV) \
		+ gaussian(ECONOMY_PAYSCALE_RANDOM_ADD_MEAN, ECONOMY_PAYSCALE_RANDOM_ADD_DEV)
	)

	// todo: more fluff from it being from the actual role's faction (and make sure role faction has economy account)
	var/datum/economy_transaction/initial_funding_transaction = new(starting_amount)
	initial_funding_transaction.audit_terminal_as_unsafe_html = ECONOMY_GENERATE_EPHEMERAL_SYSTEM_TERMINAL
	initial_funding_transaction.audit_purpose_as_unsafe_html = "Initial account creation"
	initial_funding_transaction.audit_peer_name_as_unsafe_html = "Orion Fudiciary Network"
	initial_funding_transaction.execute_system_transaction(creating)

	person.store_memory_of_economy_account(creating, "Personal Funds")
	person.initial_economy_account_number = creating.account_id

/**
 * Imprint managed accounts on someone
 */
/datum/role/proc/economy_imprint_managed_accounts(datum/mind/person)
	for(var/key in economy_grant_account_details)
		var/list/nested_keys_maybe = economy_grant_account_details[key]
		if(!nested_keys_maybe)
			var/datum/economy_account/top_level = SSeconomy.resolve_keyed_account(key)
			person.store_memory_of_economy_account(top_level, "[top_level.owner_name]")
		else
			for(var/nested_key in nested_keys_maybe)
				var/datum/economy_account/nested_account = SSeconomy.resolve_keyed_account(nested_key, key)
				person.store_memory_of_economy_account(nested_account, "[nested_account.owner_name]")

/**
 * Get economy account datums someone should have access to.
 */
/datum/role/proc/economy_get_managed_accounts(datum/mind/person) as /list
	RETURN_TYPE(/list)
	. = list()
	for(var/first_key in economy_grant_account_details)
		var/associated_values = economy_grant_account_details[first_key]
		var/list/datum/economy_account/resolved
		if(!islist(associated_values))
			// global key
			var/datum/economy_account/single = SSeconomy.resolve_account(first_key)
			if(!single)
				stack_trace("failed to resolve global id [first_key] in managed accounts")
			else
				resolved = list(single)
		else
			resolved = list()
			var/datum/economy_faction/faction = SSeconomy.resolve_faction(first_key)
			if(!faction)
				stack_trace("failed to resolve faction id [first_key] in managed accounts")
			else
				for(var/second_key in associated_values)
					// faction'd keys
					var/datum/economy_account/keyed = SSeconomy.resolve_keyed_account()
					if(!keyed)
						stack_trace("failed to resolve keyed account [first_key]/[second_key] in managed accounts")
					else
						resolved += keyed
		if(!resolved)
			continue
		. += resolved
