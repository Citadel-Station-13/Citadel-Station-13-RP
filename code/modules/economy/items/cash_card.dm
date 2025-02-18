/**
 * Represents an electronic wallet. Simple as.
 */
/obj/item/cash_card
	name = "charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/cash_card/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	return //Don't act

/obj/item/cash_card/attackby()
	return //like actual

/obj/item/cash_card/update_icon()
	return //space cash

/obj/item/cash_card/examine(mob/user, dist)
	. = ..()
	if (!(user in view(2)) && user!=src.loc)
		return
	. += "<font color=#4F49AF>Charge card's owner: [src.owner_name]. Thalers remaining: [src.worth].</font>"

/obj/item/cash_card/economy_is_payment()

/obj/item/cash_card/economy_attempt_payment(datum/economy_payment/payment, payment_op_flags, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain)

#warn deal with

/obj/item/cash_card/is_static_currency(prevent_types)
	return (prevent_types & PAYMENT_TYPE_CHARGE_CARD)? NOT_STATIC_CURRENCY : DISCRETE_STATIC_CURRENCY

/obj/item/cash_card/do_static_currency_feedback(amount, mob/user, atom/target, range)
	visible_message(SPAN_NOTICE("[user] swipes [src] through [target]."), SPAN_NOTICE("You swipe [src] through [target]."), SPAN_NOTICE("You hear a card swipe."), range)

/obj/item/cash_card/amount_static_currency()
	return worth

/obj/item/cash_card/consume_static_currency(amount, force, mob/user, atom/target, range)
	if(force)
		amount = min(amount, worth)
	if(amount > worth)
		return PAYMENT_INSUFFICIENT
	worth -= amount
	do_static_currency_feedback(amount, user, target, range)
	return amount
