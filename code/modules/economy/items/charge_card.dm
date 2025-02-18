/**
 * Represents an electronic wallet. Simple as.
 */
/obj/item/charge_card
	name = "charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

	/// stated owner name, if any
	var/owner_name
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
	. += "<font color=#4F49AF>Charge card's owner: [src.owner_name]. Thalers remaining: [src.worth].</font>"

/obj/item/charge_card/economy_is_payment()
	return TRUE

/obj/item/charge_card/economy_attempt_payment(datum/economy_payment/payment, payment_op_flags, atom/movable/accepting_entity, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain)
	if((payment.payment_types_allowed & PAYMENT_TYPE_CHARGE_CARD))
		actor?.chat_feedback(
			SPAN_WARNING("[accepting_entity] doesn't accept charge-cards."),
			target = accepting_entity,
		)
		return TRUE

#warn deal with

/obj/item/charge_card/do_static_currency_feedback(amount, mob/user, atom/target, range)
	visible_message(SPAN_NOTICE("[user] swipes [src] through [target]."), SPAN_NOTICE("You swipe [src] through [target]."), SPAN_NOTICE("You hear a card swipe."), range)

/obj/item/charge_card/consume_static_currency(amount, force, mob/user, atom/target, range)
	if(force)
		amount = min(amount, worth)
	if(amount > worth)
		return PAYMENT_INSUFFICIENT
	worth -= amount
	do_static_currency_feedback(amount, user, target, range)
	return amount
