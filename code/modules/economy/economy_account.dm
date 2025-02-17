//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * An account; usually held as part of an economy faction. Or not. Maybe.
 */
/datum/economy_account
	//* System *//

	/// Our account number.
	/// * Account numbers must be **globally unique** at time of writing.
	/// * Account numbers are strings.
	#warn impl uniqueness
	#warn audit access
	var/account_number

	//* Balance *//

	/// Amount of money in it.
	var/balance = 0

	//* Faction *//

	/// our faction id, if we're part of a faction
	var/faction_id
	/// our id, if we're a keyed account for our factoin
	var/faction_account_key

	//* Transaction Logging *//

	/// transaction log
	/// * this should never be directly edited, including to add transactions.
	///   use the procs on the transaction.
	var/list/datum/economy_transaction/transaction_log
	/// amount of balance change between the last transaction log and now
	var/transaction_log_change_since_last = 0

	//* Fluff *//

	/// Owner name
	/// * Used to infer ICly who it belongs to
	var/owner_name = "Unknown"

	//* Security *//

	/// PIN required for access, along with account number
	/// * if null, nothing can access this
	/// * this is a string, not a number
	var/security_passkey
	/// Security level; ECONOMY_SECURITY_LEVEL_* define
	#warn parse old: 0 relaxed 1 password 2 multifactor
	var/security_level = ECONOMY_SECURITY_LEVEL_RELAXED
	/// Lock the account from access
	/// * ICly, this generally is only able to be placed by the faction that owns this account.
	///   Please enforce this, don't be quirky and allow inter-offmap fuckery.
	var/security_lock = FALSE

/datum/economy_account/Destroy()
	SSeconomy.account_lookup -= "[account_number]"
	var/datum/economy_faction/our_faction = SSeconomy.faction_lookup[faction_id]
	if(our_faction)
		our_faction.accounts -= src
		our_faction.keyed_accounts -= faction_account_key
	return ..()

/**
 * Change the account's balance without making a transaction.
 *
 * * Best-faith effort will be made to track this in transaction log automatically.
 */
/datum/economy_account/proc/adjust_balance_without_logging(amount)
	#warn impl

/**
 * append a transaction to the transaction log
 *
 * * Should only be called from `/datum/economy_transaction`.
 * * We must own the transaction's reference after this; modifying it in IC transaction log variable
 *   is still allowed but this shouldn't be a shared instance.
 */
/datum/economy_account/proc/append_transaction_log(datum/economy_transaction/transaction)
	#warn impl

	// trim
	if(length(transaction_log) > 1000)
		transaction_log.Cut(1, 2)

/**
 * Randomize our access credentials
 */
/datum/economy_account/proc/randomize_credentials()
	security_passkey = "[rand(11111111, 99999999)]"
