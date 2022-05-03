/**
 * core helpers and atom API goes in here
 *
 * it is **not** recommended to use any procs in here other than get_currency_value if you're doing anything remotely
 * high effort! check currency payment cannot acocunt for multiple items combined value, auto_consume_currency can only
 * handle exact amounts, etc etc. DO NOT USE THEM UNLESS YOU ARE CODING SOMETHING EXTREMELY SIMPLE!
 *
 * warning for readers:
 * this api is not very well coded and we're going to get a *little* yanderedev about it due to the high amount of currency types we have
 */
// this is so, so ugly...
GLOBAL_LIST_INIT(coin_typecache, typecacheof(/obj/item/coin))
GLOBAL_LIST_INIT(cash_typecache, typecacheof(/obj/item/spacecash) - typecacheof(/obj/item/spacecash/ewallet))
GLOBAL_LIST_INIT(chargecard_typecache, typecacheof(/obj/item/spacecash/ewallet))
GLOBAL_LIST_INIT(id_card_typecache, typecacheof(/obj/item/card/id))


#warn impl
#warn comsigs!

/**
 * returns TRUE/FALSE based on if an atom used to pay for something has enough value to cover it in its entirety
 *
 * @params
 * - AM - atom used to pay with. usually an item.
 * - payment_types - allowed payment types - any
 * - prevent_types - blocked payment types - any - will override allowed
 * - amount - amount needed
 */
/proc/check_currency_payment(atom/movable/AM, payment_types = PAYMENT_TYPE_ANY, prevent_types = NONE, amount = 0)
	return get_currency_value(AM, payment_types) >= amount

/**
 * returns currency value of an atom, usually an item, with specific payment types
 *
 * @params
 * - AM - atom used to pay with, usually an item
 * - payment_types - allowed payment types - any
 * - prevent_types - blocked payment types - any - will override allowed
 */
/proc/get_currency_value(atom/movable/AM, payment_types = PAYMENT_TYPE_ANY, prevent_types = NONE)


/**
 * automatically handles payment with a singular transaction consuming money from a certain atom used to pay for something
 * this proc is expected to automatically consume whatever item
 * this proc will **only allow exact payments**, e.g. you can't split a coin into two magically so it'd fail!
 *
 * @return TRUE/FALSE based on success/failure
 *
 * @params
 * - AM - atom used to pay with, usually an item
 * - payment_types - allowed payment types
 * - prevent_types - blocked payment types - any - will override allowed
 * - amount - amount needed
 * - reason - (optional) - automated logging reason, used when you charge using a method that usually generates logs like bank cards
 * - initiator - (optional) - casted to datum, this is the initiator, usually a mob
 * - recipient - (optional) - some sort of datum which will be automatically queried for details if the method generates logs, like bank cards.
 * - data - (optional) - data-list that will be passed to the recipient datum during logging.
 */
/proc/auto_consume_currency(atom/movable/AM, payment_types = PAYMENT_TYPE_ANY, prevent_types = NONE, amount = 0, reason, datum/initiator, datum/recipient, list/data = list())


/**
 * datum proc called when auto_consume_currency is used, as well as any manual use cases
 *
 * used to return data on its identity and info
 * must return a data list
 */
/datum/proc/transaction_charge_details(list/data)
	return list(
		CHARGE_DETAIL_LOCATION = "Unknown",
		CHARGE_DETAIL_RECIPIENT = "Unknown",
		CHARGE_DETAIL_DEVICE = "Unknown"
	)
