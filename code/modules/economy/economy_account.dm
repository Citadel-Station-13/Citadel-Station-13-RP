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
	/// * Account numbers may not have spaces, and must be serializable as this is used for
	///   UI unique-keys within the backend.
	#warn impl uniqueness
	#warn audit access
	var/account_id

	//* Balance *//

	/// Amount of money in it.
	/// * Should only be changed by executing `/datum/economy_transaction`'s.
	/// * Not doing so will result in weird behaviors. This is not just for IC logging, this
	///   is a backend system. Don't mess around.
	var/balance = 0

	//* Faction *//

	/// our faction id, if we're part of a faction
	var/faction_id
	/// our id, if we're a keyed account for our factoin
	var/faction_account_key

	//* Logging *//

	/// log entries
	var/list/datum/economy_account_log/audit_log
	/// balance change applied through adjust_balance_without_logging()
	/// * applied as an audit log when a log is appended if it exists
	var/audit_ephemeral_balance_accumulator = 0

	//* Fluff *//

	/// Owner name
	/// * Used to infer ICly who it belongs to
	var/fluff_owner_name = "Unknown"

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
	SSeconomy.account_lookup -= "[account_id]"
	var/datum/economy_faction/our_faction = SSeconomy.faction_lookup[faction_id]
	if(our_faction)
		our_faction.accounts -= src
		our_faction.keyed_accounts -= faction_account_key
	return ..()

/**
 * Appends an audit entry to the log.
 *
 * * All parameters accept raw HTMl. This is an extremely unsafe proc; make sure you properly sanitize things.
 */
/datum/economy_account/proc/append_audit_log(datum/economy_account_log/log_entry, do_not_flush)
	if(!do_not_flush && audit_ephemeral_balance_accumulator)
		var/datum/economy_account_log/log_for_untracked = new
		log_for_untracked.audit_purpose_as_unsafe_html = "Untracked lambda balance adjustments."
		log_for_untracked.audit_balance_change_as_unsafe_html = "[audit_ephemeral_balance_accumulator]"
		append_audit_log(log_for_untracked, do_not_flush = TRUE)
		audit_ephemeral_balance_accumulator = 0
	#warn impl

/datum/economy_account/proc/adjust_balance_without_logging(amount, actually_dont_log)
	balance += amount
	if(!actually_dont_log)
		audit_ephemeral_balance_accumulator += amount

/**
 * Randomize our access credentials
 */
/datum/economy_account/proc/randomize_credentials()
	security_passkey = "[rand(11111111, 99999999)]"

/**
 * Sets our security lock status.
 */
/datum/economy_account/proc/set_security_lock(lock_status)
	security_lock = lock_status

/**
 * Sets our security level.
 */
/datum/economy_account/proc/set_security_level(level_enum)
	security_level = level_enum

/**
 * Actor / clickchain access. This can sleep.
 *
 * @params
 * * actor - actor data
 * * clickchain - (optional) clickchain data if this is from a click
 * * via_bridge - (optional) this is like the ID card that's being used or whatever
 */
/datum/economy_account/proc/user_clickchain_access(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchian, datum/via_bridge)
	#warn impl

/**
 * Helper to get standard economy log output
 *
 * @return {
 *   pages = number,
 *   page = number,
 *   logs = {
 *     balance = html | null,
 *     peer = html | null,
 *     terminal = html | null,
 *     purpose = html | null,
 *     timestamp = html | null,
 *   }[],
 */
 /datum/economy_account/proc/ui_audit_logs(page, per_page = 10)
	#warn impl
