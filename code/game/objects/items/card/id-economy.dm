//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/card/id/economy_is_payment()
	return !!associated_account_number

/obj/item/card/id/economy_attempt_payment(datum/economy_payment/payment, payment_op_flags, atom/movable/accepting_entity, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain)
	if(!associated_account_number)
		return TRUE

	if(!(payment_op_flags & PAYMENT_OP_SUPPRESSED) && accepting_entity)
		actor?.visible_feedback(
			target = accepting_entity,
			visible = SPAN_NOTICE("[actor.performer] swipes [src] through [accepting_entity]."),
		)

	var/datum/economy_account/connected_account = SSeconomy.resolve_account(associated_account_number)

	if(connected_account)
		payment.out_error_reason = "Linked account does not exist or is invalid."
		return TRUE
	if(connected_account.security_lock)
		payment.out_error_reason = "Linked account is under security lockdown."
		return TRUE

	switch(connected_account.security_level)
		if(ECONOMY_SECURITY_LEVEL_MULTIFACTOR, ECONOMY_SECURITY_LEVEL_PASSWORD)
			// card is taken care of by, well, being on us
			#warn handle pin entry and verify
		if(ECONOMY_SECURITY_LEVEL_RELAXED)
			// do nothing

	if(!payment.lazy_execute_against_account(connected_account))
		payment.out_error_reason = "Unknown error. Contact a coder."
		return TRUE
	return TRUE

#warn impl

// currently just id cards

/obj/item/card/id/attempt_dynamic_currency(mob/user, atom/movable/predicate, amount, force, prevent_types, list/data, silent, visual_range)
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

	return amount
