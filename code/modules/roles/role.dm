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
	var/starting_amount = round(
		  get_economic_payscale() \
		* ECONOMY_PAYSCALE_BASE \
		* ECONOMY_PAYSCALE_MULT \
		* H.mind.original_pref_economic_modifier \
		* gaussian(ECONOMY_PAYSCALE_RANDOM_MULT_MEAN, ECONOMY_PAYSCALE_RANDOM_MULT_DEV) \
		+ gaussian(ECONOMY_PAYSCALE_RANDOM_ADD_MEAN, ECONOMY_PAYSCALE_RANDOM_ADD_DEV)
	)

	#warn impl

	person.store_memory_of_economy_account(creating, "Personal Funds")
	person.initial_economy_account_number = creating.account_number

// /datum/role/job/proc/setup_account(var/mob/living/carbon/human/H)
// 	var/datum/economy_account/M = create_account(H.real_name, money_amount, null, offmap_spawn)
// 	if(H.mind)
// 		var/remembered_info = ""
// 		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
// 		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
// 		remembered_info += "<b>Your account funds are:</b> $[M.money]<br>"

// 		if(M.transaction_log.len)
// 			var/datum/economy_transaction/T = M.transaction_log[1]
// 			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
// 		H.mind.store_memory(remembered_info)

// 		H.mind.initial_account = M

// 	to_chat(H, "<span class='notice'><b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b></span>")

/**
 * Imprint managed accounts on someone
 */
/datum/role/proc/economy_imprint_managed_accounts(datum/mind/person)
	#warn impl

/**
 * Get economy account datums someone should have access to.
 */
/datum/role/proc/economy_get_managed_accounts(datum/mind/person) as /list
	RETURN_TYPE(/list)
	#warn impl
