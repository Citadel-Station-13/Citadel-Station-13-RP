//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Staged payment datum that can be ran against things.
 *
 * * Used for standardized payment handling API
 */
/datum/economy_payment
	/// amount to take
	var/amount

	/// allow partial payment
	var/allow_partial = FALSE
	/// allow sinking source into negatives (this is a bad idea please don't use this)
	var/allow_overdraft = FALSE
	/// allow paying too much
	var/allow_overflow = FALSE

	/// target economy_account ID to pay to
	/// * if null, money is taken but not fully sent
	var/send_to_account_number

	/// allowed payment types; this is PAYMENT_TYPE_* flags
	/// * this is a suggestion, and is only enforced currency-side
	var/payment_types_allowed = PAYMENT_TYPE_ALL

	/// terminal name
	/// * Do not allow user input without sanitizing!
	var/audit_terminal_name_as_unsafe_html
	/// purpose
	/// * Do not allow user input without sanitizing!
	var/audit_purpose_as_unsafe_html
	/// who's it being sent to
	var/audit_recipient_as_unsafe_html

	/// output; result? uses PAYMENT_RESULT_* enums
	/// * this is PAYMENT_RESULT_UNSET until we are finished.
	var/out_payment_result = PAYMENT_RESULT_UNSET
	/// output; amount paid
	var/out_amount_paid = 0
	/// output; error explanation (short please!)
	var/out_error_reason = "Unknown failure."

/datum/economy_payment/New(amount = 0)
	src.amount = amount

/**
 * Reset status to allow for re-execution
 */
/datum/economy_payment/proc/reset()
	out_payment_result = initial(out_payment_result)
	out_error_reason = initial(out_error_reason)
	out_amount_paid = initial(out_amount_paid)

/**
 * Reset status, subtracting paid amount from amount
 * * This is an advanced proc, only use if you know what you're doing.
 *   This basically allows you to repeatedly re-use the same payment
 *   datum across multiple usages.
 * * This allows [amount] to go into the negatives. This happens if more
 *   is paid than should be paid.
 */
/datum/economy_payment/proc/reset_and_accumulate()
	amount -= out_amount_paid
	reset()

/**
 * Checks if we executed yet
 * * This is important to use in clickchain to know if it should continue, or if the user
 *   should / would stop after having already finished an action.
 * * This doesn't imply success!
 */
/datum/economy_payment/proc/is_handled()
	return out_payment_result != PAYMENT_RESULT_UNSET

/**
 * Checks if we're successful
 */
/datum/economy_payment/proc/is_successful()
	return out_payment_result == PAYMENT_RESULT_SUCCESS

/**
 * Helper to make a transaction to execute against a source account,
 * run it, and set out variables.
 *
 * @return TRUE if handled, FALSE on unknown error
 */
/datum/economy_payment/proc/lazy_execute_against_account(datum/economy_account/source_account)

	var/to_withdraw = max(0, allow_overdraft ? amount : min(amount, source_account.balance))

	var/datum/economy_transaction/attempt_transaction = new(to_withdraw)
	attempt_transaction.audit_purpose_as_unsafe_html = audit_purpose_as_unsafe_html
	attempt_transaction.audit_terminal_as_unsafe_html = audit_terminal_name_as_unsafe_html
	attempt_transaction.audit_peer_name_as_unsafe_html = audit_recipient_as_unsafe_html

	#warn impl

	return TRUE
