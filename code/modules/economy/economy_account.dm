//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * An account; usually held as part of an economy faction. Or not. Maybe.
 */
/datum/economy_account
	/// Our account number.
	/// * Account numbers must be **globally unique** at time of writing.
	#warn impl uniqueness
	#warn audit access
	var/account_number

	/// Amount of money in it.
	var/balance = 0

	/// our faction id, if we're part of a faction
	var/faction_id
	/// our id, if we're a keyed account for our factoin
	var/faction_account_key

	/// transaction log
	var/list/datum/economy_transaction/transaction_log
	/// amount of balance change between the last transaction log and now
	var/transaction_log_change_since_last = 0

/**
 * Change the account's balance without making a transaction.
 */
/datum/economy_account/proc/adjust_balance_without_logging(amount)
	#warn impl

/**
 * append a transaction to the transaction log
 *
 * * the transaction should either have us as the source or the target
 * * source-less transactions always have us as the target
 */
/datum/economy_account/proc/append_transaction(datum/economy_transaction/transaction)
	#warn trim
