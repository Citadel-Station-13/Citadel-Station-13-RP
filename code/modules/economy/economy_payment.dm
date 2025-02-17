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

	/// allowed currency types
	/// * this is a suggestion, and is only enforced currency-side
	var/currency_types_allowed

	/// terminal name
	/// * Do not allow user input without sanitizing!
	var/audit_terminal_name_as_unsafe_html
	/// purpose
	/// * Do not allow user input without sanitizing!
	var/audit_purpose_as_unsafe_html
	/// who's it being sent to
	var/audit_recepient_as_unsafe_html

	/// executed? used to prevent double-executions
	/// * sometimes it might be beneficial to allow it; e.g. if you're drawing
	///   from multiple sources. by default, it shouldn't be allowed.
	/// * completed does not imply successful; check [out_success] for that.
	var/completed = FALSE

	/// output; successful?
	var/out_success = FALSE
	/// output; amount paid
	var/out_amount_paid = 0

/**
 * Reset status to allow for re-execution
 */
/datum/economy_payment/proc/reset()
	completed = FALSE
	out_success = FALSE
	out_amount_paid = 0

/**
 * Reset status, subtracting paid amount from amount
 * * This is an advanced proc, only use if you know what you're doing.
 *   This basically allows you to repeatedly re-use the same payment
 *   datum across multiple usages.
 * * This allows [amount] to go into the negatives. This happens if more
 *   is paid than should be paid.
 */
/datum/economy_payment/proc/reset_and_accumulate()
	completed = FALSE
	out_success = FALSE
	amount -= out_amount_paid

#warn impl all
