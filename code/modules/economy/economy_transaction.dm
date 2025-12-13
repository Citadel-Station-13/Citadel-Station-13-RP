//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * An individual transaction made in economy system
 */
/datum/economy_transaction
	//*                      book-keeping                        *//
	//* these are handled by internals and may not be falsified. *//

	/// target account number, if any
	/// * non point-to-point transactions / system transactions will always have
	///   the target account as this!
	/// * 'amount' will be given (and withdrawan if negative)
	#warn uhhh hmmm
	#warn audit
	var/acct_num_target
	/// peer account number, if any
	/// * only sourced / point-to-point / transfer transactions have this set
	/// * 'amount' will be withdrawan (and given if negative)
	var/acct_num_peer

	/// balance change to target
	/// * if the peer is specified, this is, by default, the opposite change of target!
	///   this means that if this is '50', it means target gained 50 and peer lost 50.
	#warn audit
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
	var/audit_peer_name_as_unsafe_html
	/// stated date / tiem
	/// * plaintext ISO-8601: "YYYY-MM-DDTHH:MM:SS"
	/// * in universal galactic time (so, IC time!)
	/// * This value is inferred for IC logging if not provided.
	var/audit_timestamp_as_unsafe_html
	/// stated balance change
	/// * there's pretty much no possible reason for you to be messing with this but this is here if you want to
	/// * This value is inferred for IC logging if not provided (please don't provide it)
	var/audit_balance_change_as_unsafe_html

#warn impl

/datum/economy_transaction/New(amount)
	src.amount = amount

/datum/economy_transaction/clone()
	var/datum/economy_transaction/transaction = new
	if(acct_num_peer)
		transaction.acct_num_peer = acct_num_peer
	if(acct_num_target)
		transaction.acct_num_target = acct_num_target
	if(amount)
		transaction.amount = amount
	if(audit_purpose_as_unsafe_html)
		transaction.audit_purpose_as_unsafe_html = audit_purpose_as_unsafe_html
	if(audit_terminal_as_unsafe_html)
		transaction.audit_terminal_as_unsafe_html = audit_terminal_as_unsafe_html
	if(audit_peer_name_as_unsafe_html)
		transaction.audit_peer_name_as_unsafe_html = audit_peer_name_as_unsafe_html
	if(audit_timestamp_as_unsafe_html)
		transaction.audit_timestamp_as_unsafe_html = audit_timestamp_as_unsafe_html
	if(audit_balance_change_as_unsafe_html)
		transaction.audit_balance_change_as_unsafe_html = audit_balance_change_as_unsafe_html
	return transaction

/**
 * Executes against an account
 * * will runtime if target or peer is set and doesn't exist
 */
/datum/economy_transaction/proc/execute_system_transaction(datum/economy_account/account)
	#warn impl
	#warn set date / time to 'now'
	global.event_logger.log__economy_transaction(src)

/**
 * Executes as a transfer from one account to another
 * * will runtime if target or peer is set and doesn't exist
 * * 'amount' will be transferred from peer to source
 */
/datum/economy_transaction/proc/execute_transfer_transaction(datum/economy_account/source_account, datum/economy_account/peer_account)
	#warn impl
	#warn set date / time to 'now'
	global.event_logger.log__economy_transaction(src)
