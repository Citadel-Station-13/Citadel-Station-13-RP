/**
 * Represents an electronic wallet. Simple as.
 */
/obj/item/charge_card
	name = "charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

	/// balance remaining
	var/balance = 0

/obj/item/charge_card/Initialize(mapload, balance)
	. = ..()
	if(balance)
		src.balance = balance

/obj/item/charge_card/examine(mob/user, dist)
	. = ..()
	if (!(user in view(2)) && user!=src.loc)
		return
	. += "<font color=#4F49AF>Thalers remaining: [balance].</font>"

//* Economy *//

/obj/item/charge_card/economy_is_payment()
	return TRUE

/obj/item/charge_card/economy_attempt_payment(datum/economy_payment/payment, payment_op_flags, atom/movable/accepting_entity, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain)
	if((payment.payment_types_allowed & PAYMENT_TYPE_CHARGE_CARD))
		actor?.chat_feedback(
			SPAN_WARNING("[accepting_entity] doesn't accept charge-cards."),
			target = accepting_entity,
		)
		return TRUE

	var/paying_amount

	if(balance < payment.amount)
		if(payment.allow_partial)
			paying_amount = balance
	else
		paying_amount = payment.amount

	if(!(payment_op_flags & PAYMENT_OP_SUPPRESSED))
		actor?.visible_feedback(
			target = accepting_entity,
			range = MESSAGE_RANGE_ITEM_HARD,
			visible = SPAN_NOTICE("[actor.performer] swipes [src] through [accepting_entity]."),
			otherwise_self = SPAN_NOTICE("You swipe [src] through [accepting_entity]."),
		)
	// todo: sound

	if(balance < paying_amount)
		// unlike with cash, this is a swipe, which means the machine will get the result.
		payment.out_payment_result = PAYMENT_RESULT_INSUFFICIENT
		return TRUE

	balance -= paying_amount
	ASSERT(balance >= 0)

	payment.out_payment_result = PAYMENT_RESULT_SUCCESS
	payment.out_amount_paid = paying_amount
	update_appearance()
	return TRUE
