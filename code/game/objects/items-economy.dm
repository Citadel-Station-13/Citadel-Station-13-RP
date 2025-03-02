//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Checks if we're valid for receiving [economy_attempt_payment]'s
 */
/obj/item/proc/economy_is_payment()
	return FALSE

/**
 * Core economy payment API
 *
 * Allows using an item as currency.
 * * This basically means someone is swiping this item on a machine.
 * * This proc returns TRUE / FALSE based on if it's handled. A failed payment is handling the payment.
 *   Only unimplemented items won't handle it.
 *
 * Conditions
 * * This proc **is** allowed to have the item self-delete (e.g. all of a stack of cash is inserted).
 *
 * @params
 * * payment - the payment being made
 * * payment_op_flags - (optional) PAYMENT_OP_* flags
 * * accepting_entity - (optional) entity being inserted into; this is required for messages.
 * * actor - (optional) the actor doing it; this is required for messages.
 * * clickchain - (optional) clickchain datum; if this exists, the actor is doing it as part of a click.
 *
 * @return TRUE if **handled**, FALSE otherwise.
 */
/obj/item/proc/economy_attempt_payment(datum/economy_payment/payment, payment_op_flags, atom/movable/accepting_entity, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain)
	return FALSE
