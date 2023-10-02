/**
 * core helpers and item API goes in here
 *
 * warning for readers:
 * this api is not very well coded and we're going to get a *little* yanderedev about it due to the high complexity of the currency system.
 */

/**
 * static currency
 *
 * these procs are used to determine if something is considered static currency and how much it's worth
 * static currency should never need logic to determine payment ability and/or worth
 *
 * because i hate everyone and myself but not *that* much, static currency can either logically be
 * a stack (cash, holochips, chargecards), or a discrete object like a coin
 *
 * i would code support for "stack of objects" to force people to roleplay counting dollar bills but that's too CPU-intensive to calculate
 * (see: coin counting problem)
 */

/**
 * returns if we are valid static currency for the given payment types
 *
 * @params
 * - prevent_types - these types aren't allowed
 */
/obj/item/proc/is_static_currency(prevent_types)
	return NOT_STATIC_CURRENCY

/**
 * returns our value as currency
 */
/obj/item/proc/amount_static_currency()
	return 0

/**
 * consumes our value as currency
 * this **can** cause us to delete!
 *
 * @params
 * - amount - amount to consume
 * - force - consume even if there isn't enough. use INFINITY and force = TRUE for things like ATM deposits
 * - user - used for visual feedback
 * - target - used for visual feedback
 * - range - used for visual feedback
 *
 * @return amount consumed, or a payment status enum
 */
/obj/item/proc/consume_static_currency(amount, force, mob/user, atom/target, range)
	return PAYMENT_NOT_CURRENCY

/**
 * displays feedback upon being used as static currency by a person
 *
 * **due to consume_static_currency potentially deleting us, it is on the item to call this proc, not the main proc!**
 */
/obj/item/proc/do_static_currency_feedback(amount, mob/user, atom/target, range)
	return

/**
 * dynamic currency
 *
 * this is where the fun/anguish/coder tears begin
 *
 * dynamic currency is currency that can potentially require logic during payment and whose value can be different due to payment types
 * and all sorts of situations that are absolutely dreadful to handle in code
 *
 * this, ofcourse, means that generalized component signals are supported
 * **however.**
 *
 * this also means that we lose estimation capabiltiies whatsoever, because we won't know if we can handle a payment request until it actually happens.
 */

/**
 * dynamic payment proc - this **can** block since some methods **will** query the user for details!
 *
 * behold, a trainwreck.
 *
 * @params
 * user - (optional) mobless is possible, otherwise user
 * predicate - thing we're paying into. it will be queried for log information if needed with query_transaction_details()
 * amount - amount to charge
 * force - charge even if amount is under, use for stuff like atm deposits/money drains
 * prevent_types - payment_types to block
 * data - arbitrary list provided by the predicate, fed back into it during query_transaction_details. the proc **can** feed things back into it, like error messages!
 * silent - suppress all feedback
 * visual_range - feedback/message range
 *
 * @returns amount paid
 */
/obj/item/proc/attempt_dynamic_currency(mob/user, atom/movable/predicate, amount, force, prevent_types, list/data = list(), silent, visual_range = 7)
	. = PAYMENT_NOT_CURRENCY
	var/list/iterating  = list()
	SEND_SIGNAL(src, COMSIG_ITEM_DYNAMIC_CURRENCY_QUERY, iterating)
	if(length(iterating))
		for(var/datum/D in iterating)
			var/ret = SEND_SIGNAL(D, COMSIG_ITEM_DYNAMIC_CURRENCY_CALL, user, predicate, amount, force, prevent_types, data, silent, visual_range)
			if(ret & COMPONENT_HANDLED_PAYMENT)
				// make sure they're not an idiot, and aren't forgetting to use our api
				if(!(force? data[DYNAMIC_PAYMENT_DATA_PAID_AMOUNT] < 0 : data[DYNAMIC_PAYMENT_DATA_PAID_AMOUNT] == amount))
					CRASH("[D]([D.type]) was coded by a monkey and didn't match required amount! force: [force], amount: [amount], returned: [data[DYNAMIC_PAYMENT_DATA_PAID_AMOUNT]].")
				. = data[DYNAMIC_PAYMENT_DATA_PAID_AMOUNT]
				// upon handle, we immediately break
				break
			else if(ret & COMPONENT_ERRORED_PAYMENT)
				return PAYMENT_DYNAMIC_ERROR
				// upon error, we immediately break
			else if(ret & COMPONENT_INSUFFICIENT_PAYMENT)
				. = PAYMENT_INSUFFICIENT
				// don't return, next component might override yet!

/**
 * handles attempting to use an item for an automatic payment using default handling
 * use this proc for simpler things.
 *
 * behold, a trainwreck.
 *
 * @params
 * user - (optional) mobless is possible, otherwise user
 * predicate - thing we're paying into. it will be queried for log information if needed with query_transaction_details()
 * amount - amount to charge
 * force - charge even if amount is under, use for stuff like atm deposits/money drains
 * prevent_types - payment_types to block
 * reason - payment reason for transaction logs
 * data - arbitrary list provided by the predicate, fed back into it during query_transaction_details. the proc **can** feed things back into it, like error messages and payment accounts!
 * silent - suppress all feedback
 * visual_range - feedback/message range
 *
 * @returns amount paid, or payment failure enum
 */
/obj/item/proc/attempt_use_currency(mob/user, atom/movable/predicate, amount, force, prevent_types, list/data = list(), silent, visual_range = 7)
	. = PAYMENT_NOT_CURRENCY
	// check static currency
	if(is_static_currency(prevent_types))
		. = consume_static_currency(amount, force, user, predicate, silent? 0 : visual_range)
		if(. >= PAYMENT_SUCCESS)
			return
	. = attempt_dynamic_currency(user, predicate, amount, force, prevent_types, data, silent, visual_range)
	if(data[DYNAMIC_PAYMENT_DATA_PAID_AMOUNT] && !(. > PAYMENT_SUCCESS))
		stack_trace("mismatch between datalist paid amount and payment success")
		. = data[DYNAMIC_PAYMENT_DATA_PAID_AMOUNT]

/**
 * datum proc called when auto_consume_currency is used, as well as any manual use cases
 *
 * used to return data on its identity and info
 * must return a data list
 */
/datum/proc/query_transaction_details(list/data)
	return list(
		CHARGE_DETAIL_LOCATION = "Unknown",
		CHARGE_DETAIL_RECIPIENT = "Unknown",
		CHARGE_DETAIL_DEVICE = "Unknown",
		CHARGE_DETAIL_REASON = "Unknown"
	)
