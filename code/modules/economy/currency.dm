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
 *
 * @return amount consumed
 */
/obj/item/proc/consume_static_currency(amount, force)
	return 0

/**
 * displays feedback upon being used as static currency by a person
 */
/obj/item/proc/do_static_currency_feedback(mob/user, atom/target, range)
	return

/**
 * dynamic currency
 *
 * this is where the fun/anguish/coder tears begin
 *
 * dynamic currency is currency that can potentially require logic during payment and whose value can be different due to payment types
 * and all sorts of situations that are absolutely dreadful to handle in code
 */




/**
 * automated payment proc
 *
 * @params
 * - user - user (can be null)
 * - I - currency used, static or dynamic
 * - predicate - thing we're paying into. has to be an atom/movable
 * - amount - amount requested
 * - force - go through even if insufficient
 *
 *
 * @return amount paid
 */
/proc/attempt_generic_currency_payment(mob/user, obj/item/I, atom/movable/predicate, amount, force, )

/**
 * returns TRUE/FALSE based on if an item used to pay for something has enough value to cover it in its entirety
 *
 * @params
 * - I - item used to pay with
 * - payment_types - allowed payment types - any
 * - prevent_types - blocked payment types - any - will override allowed
 * - amount - amount needed
 */
/proc/check_currency_payment(obj/item/I, payment_types = PAYMENT_TYPE_ANY, prevent_types = NONE, amount = 0)
	return get_currency_value(AM, payment_types) >= amount

/**
 * returns currency value of an item with specific payment types
 *
 * @params
 * - I - item used to pay with
 * - payment_types - allowed payment types - any
 * - prevent_types - blocked payment types - any - will override allowed
 */
/proc/get_currency_value(obj/item/I, payment_types = PAYMENT_TYPE_ANY, prevent_types = NONE)
	if(payment_types & PAYMENT_TYPE_COIN)
		if(istype(I, /obj/item/coin))
			return 0		// not implemented
	if(payment_types & PAYMENT_TYPE_BANK_CARD)
		if(istype(I, /obj/item/card/id))
			var/obj/item/card/id/ID = I
			var/datum/money_account/account = get_account(ID.associated_account_number)
			if(!account)
				return 0

	if(istype(I, /obj/item/spacecash))
		if(istype(I, /obj/item/spacecash/ewallet))
			if(payment_types & PAYMENT_TYPE_CHARGE_CARD)
				var/obj/item/spacecash/ewallet/wallet = I
				return wallet.worth
			else
				return 0
		if(payment_types & PAYMENT_TYPE_CASH)
			var/obj/item/spacecash/cash = I
			return cash.worth
		else
			return 0
	// comsig fired last
	var/list/capable = list()
	var/result = SEND_SIGNAL(I, COMSIG_ITEM_PAYMENT_CHECK, payment_types, prevent_types, 0, capable)
	if(!(result & PAYMENT_CAPABLE))
		return 0
	. = 0
	for(var/i in capable)	// scan across
		. = max(., capable[i])

/**
 * automatically handles payment with a singular transaction consuming money from a certain atom used to pay for something
 * this proc is expected to automatically consume whatever item
 * this proc will **only allow exact payments**, e.g. you can't split a coin into two magically so it'd fail!
 *
 * @return TRUE/FALSE based on success/failure
 *
 * @params
 * - I - item used to pay with
 * - payment_types - allowed payment types
 * - prevent_types - blocked payment types - any - will override allowed
 * - amount - amount needed
 * - reason - (optional) - automated logging reason, used when you charge using a method that usually generates logs like bank cards
 * - initiator - (optional) - casted to datum, this is the initiator, usually a mob
 * - acceptor - (optional) - some sort of datum which will be automatically queried for details if the method generates logs, like bank cards. this datum is usually the machine charging a payer.
 * - data - (optional) - data-list that will be passed to the recipient datum during logging.
 * - silent - (optional) - defaults to FALSE - if not set, error messages will be shown to the initiator on payment failure.
 */
/proc/auto_consume_currency(obj/item/I, payment_types = PAYMENT_TYPE_ANY, prevent_types = NONE, amount = 0, reason, datum/initiator, datum/acceptor, list/data = list())

#warn impl

/**
 * Scan a card and attempt to transfer payment from associated account.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed
 */
/obj/machinery/vending/proc/pay_with_card(var/obj/item/card/id/I, var/obj/item/ID_container)
	if(I==ID_container || ID_container == null)
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
	var/datum/money_account/customer_account = get_account(I.associated_account_number)
	if(!customer_account)
		status_message = "Error: Unable to access account. Please contact technical support if problem persists."
		status_error = 1
		return 0

	if(customer_account.suspended)
		status_message = "Unable to access account: account suspended."
		status_error = 1
		return 0

	// Have the customer punch in the PIN before checking if there's enough money. Prevents people from figuring out acct is
	// empty at high security levels
	if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		customer_account = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!customer_account)
			status_message = "Unable to access account: incorrect credentials."
			status_error = 1
			return 0

	if(currently_vending.price > customer_account.money)
		status_message = "Insufficient funds in account."
		status_error = 1
		return 0
	else
		// Okay to move the money at this point

		// debit money from the purchaser's account
		customer_account.money -= currently_vending.price

		// create entry in the purchaser's account log
		var/datum/transaction/T = new()
		T.target_name = "[vendor_account.owner_name] (via [name])"
		T.purpose = "Purchase of [currently_vending.item_name]"
		if(currently_vending.price > 0)
			T.amount = "([currently_vending.price])"
		else
			T.amount = "[currently_vending.price]"
		T.source_terminal = name
		T.date = current_date_string
		T.time = stationtime2text()
		customer_account.transaction_log.Add(T)

		// Give the vendor the money. We use the account owner name, which means
		// that purchases made with stolen/borrowed card will look like the card
		// owner made them
		credit_purchase(customer_account.owner_name)
		return 1

/**
 *  Add money for current purchase to the vendor account.
 *
 *  Called after the money has already been taken from the customer.
 */
/obj/machinery/vending/proc/credit_purchase(var/target as text)
	vendor_account.money += currently_vending.price

	var/datum/transaction/T = new()
	T.target_name = target
	T.purpose = "Purchase of [currently_vending.item_name]"
	T.amount = "[currently_vending.price]"
	T.source_terminal = name
	T.date = current_date_string
	T.time = stationtime2text()
	vendor_account.transaction_log.Add(T)


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
