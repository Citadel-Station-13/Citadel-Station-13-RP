//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * An individual transaction made in economy system
 */
/datum/economy_transaction
	//*                      book-keeping                        *//
	//* these are handled by internals and may not be falsified. *//

	/// source account number, if any
	/// * only sourced / point-to-point / transfer transactions have this set
	var/acct_num_src
	/// destination account number, if any
	/// * non point-to-point transactions / system transactions will always have
	///   the target account as this!
	var/acct_num_target

	/// balance change to target
	/// * if the source is specified, this is, by default, the opposite change of target!
	///   this means that if this is '50', it means source lost 50 and target gained 50
	/// * confusing, i know.
	var/amount = 0

	//*                        auditing                 *//
	//* these are fluff fields and may be falsified.    *//

	/// stated purpose, as html
	/// * this is unsanitized html, do not allow player input without an encode!
	var/audit_purpose_as_unsafe_html
	/// stated origin machine
	/// * this is unsanitized html, do not allow player input without an encode!
	/// * this should generally indicate to the player a hint on where it came from
	/// * avoid magic strings! these should be auto-generated in code for standardization,
	///   as IC investigations may end up using this!
	///
	/// examples:
	/// * Nanotrasen Corporate Accounting
	/// * Vey-Med (Vendor #xxxxxxxx)
	/// * Hephaestus Industries Terminal #xxxxxxxxx
	var/audit_terminal_as_unsafe_html
	/// stated destination name
	/// * this is unsanitized html, do not allow player input without an encode!
	/// * being an audit field, this is not a systems book-keeping field.
	var/audit_dest_name_as_unsafe_html

	/// stated date / tiem
	/// * plaintext ISO-8601: "YYYY-MM-DD"
	/// * in universal galactic time (so, IC time!)
	var/audit_date
	/// stated date / time
	/// * plaintext ISO-8601: "HH:MM:SS"
	/// * in universal galactic time (so, IC time!)
	var/audit_time


#warn impl

/datum/economy_transaction/New(amount)
	src.amount = amount

/datum/economy_transaction/clone()
	var/datum/economy_transaction/transaction = new
	if(acct_num_src)
		transaction.acct_num_src = acct_num_src
	if(acct_num_target)
		transaction.acct_num_target = acct_num_target
	if(amount)
		transaction.amount = amount
	if(audit_purpose_as_unsafe_html)
		transaction.audit_purpose_as_unsafe_html = audit_purpose_as_unsafe_html
	if(audit_terminal_as_unsafe_html)
		transaction.audit_terminal_as_unsafe_html = audit_terminal_as_unsafe_html
	if(audit_dest_name_as_unsafe_html)
		transaction.audit_dest_name_as_unsafe_html = audit_dest_name_as_unsafe_html
	if(audit_date)
		transaction.audit_date = audit_date
	if(audit_time)
		transaction.audit_time = audit_time
	return transaction

/**
 * Executes against an account
 *
 * * This will clone ourselves and inject a new copy into the account
 * * This will set `acct_num_target` as necessary on the created transaction
 * * This will set `audit_date` and `audit_time` to the current time as IC time.
 */
/datum/economy_transaction/proc/execute_system_transaction(datum/economy_account/account)
	#warn impl
	#warn set date / time to 'now'

/**
 * Executes as a transfer from one account to another
 *
 * * This will clone ourselves twice and inject new copies into both accounts
 * * This will set `acct_num_target` and `acct_num_src` as necessary on the created transactions
 */
/datum/economy_transaction/proc/execute_transfer_transaction(datum/economy_account/from_account, datum/economy_account/to_account)
	#warn impl
	#warn set date / time to 'now'
