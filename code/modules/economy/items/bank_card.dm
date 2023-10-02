// currently just id cards

/obj/item/card/id/attempt_dynamic_currency(mob/user, atom/movable/predicate, amount, force, prevent_types, list/data, silent, visual_range)
	. = ..()
	if(. >= PAYMENT_SUCCESS)
		return	// component intercepted
	if(!silent)
		user.visible_message(SPAN_INFO("[user] swipes [src] through [predicate]."), range = visual_range)
	var/datum/money_account/customer_account = get_account(associated_account_number)
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
	if(amount > customer_account.money)
		if(!force)
			data[DYNAMIC_PAYMENT_DATA_FAIL_REASON] = "Error: Insufficient funds."
			return PAYMENT_DYNAMIC_ERROR
		else
			amount = customer_account.money

	// deduct
	customer_account.money -= amount
	data[DYNAMIC_PAYMENT_DATA_PAID_AMOUNT] = amount
	data[DYNAMIC_PAYMENT_DATA_BANK_ACCOUNT] = customer_account
	data[DYNAMIC_PAYMENT_DATA_CURRENCY_TYPE] = PAYMENT_TYPE_BANK_CARD
	// transaction log
	var/datum/transaction/T = new
	T.amount = amount
	var/list/details = predicate.query_transaction_details(data)
	T.target_name = details[CHARGE_DETAIL_RECIPIENT]
	T.source_terminal = details[CHARGE_DETAIL_DEVICE]
	T.date = GLOB.current_date_string
	T.time = stationtime2text()
	T.purpose = details[CHARGE_DETAIL_REASON]
	customer_account.transaction_log.Add(T)
	return amount
