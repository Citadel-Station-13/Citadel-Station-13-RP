//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/card/id/economy_is_payment()
	return !!associated_account_number

/obj/item/card/id/economy_attempt_payment(datum/economy_payment/payment, payment_op_flags, atom/movable/accepting_entity, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain)
	if(!associated_account_number)
		return FALSE


#warn impl

// currently just id cards

/obj/item/card/id/attempt_dynamic_currency(mob/user, atom/movable/predicate, amount, force, prevent_types, list/data, silent, visual_range)
	. = ..()
	if(. >= PAYMENT_SUCCESS)
		return	// component intercepted
	if(!silent)
		user.visible_message(SPAN_INFO("[user] swipes [src] through [predicate]."), range = visual_range)
	var/datum/economy_account/customer_account = SSeconomy.resolve_account_number(associated_account_number)
	if(!customer_account)
		data[DYNAMIC_PAYMENT_DATA_FAIL_REASON] = "Error: Unable to access account. Please contact technical support if problem persist."
		return PAYMENT_DYNAMIC_ERROR
	if(customer_account.suspended)
		data[DYNAMIC_PAYMENT_DATA_FAIL_REASON] = "Error: Account suspended."
		return PAYMENT_DYNAMIC_ERROR
	if(customer_account.security_level != 0)
		if(!user)
			data[DYNAMIC_PAYMENT_DATA_FAIL_REASON] = "Error: No credentials supplied."
			return PAYMENT_DYNAMIC_ERROR
		var/input_pin = input(user, "Enter pin code", "Vendor Transaction") as num|null
		if(!input_pin)
			data[DYNAMIC_PAYMENT_DATA_FAIL_REASON] = "Error: No credentials supplied."
			return PAYMENT_DYNAMIC_ERROR
		customer_account = attempt_account_access(associated_account_number, input_pin, 2)
		if(!customer_account)
			data[DYNAMIC_PAYMENT_DATA_FAIL_REASON] = "Error: Incorrect credentials."
			return PAYMENT_DYNAMIC_ERROR
	if(amount > customer_account.balance)
		if(!force)
			data[DYNAMIC_PAYMENT_DATA_FAIL_REASON] = "Error: Insufficient funds."
			return PAYMENT_DYNAMIC_ERROR

	data[DYNAMIC_PAYMENT_DATA_PAID_AMOUNT] = amount
	data[DYNAMIC_PAYMENT_DATA_BANK_ACCOUNT] = customer_account
	data[DYNAMIC_PAYMENT_DATA_CURRENCY_TYPE] = PAYMENT_TYPE_BANK_CARD

	var/datum/economy_transaction/transaction = new(-amount)
	transaction.audit_terminal_as_unsafe_html = details[CHARGE_DETAIL_DEVICE]
	transaction.audit_peer_name_as_unsafe_html = details[CHARGE_DETAIL_RECIPIENT]
	transaction.audit_purpose_as_unsafe_html = details[CHARGE_DETAIL_REASON]
	transaction.execute_system_transaction(transaction)

	return amount
