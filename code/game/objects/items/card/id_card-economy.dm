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
		payment.out_error_reason = "Linked account is administratively locked."
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
