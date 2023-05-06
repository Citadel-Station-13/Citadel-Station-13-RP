
/datum/economy_account
	var/owner_name = ""
	var/remote_access_pin = 0
	var/money = 0
	var/list/transaction_log = list()
	var/suspended = 0
	var/security_level = 0	//0 - auto-identify from worn ID, require only account number
							//1 - require manual login / account number and pin
							//2 - require card and manual login

	/// account number, which is also our unique id
	var/account_number
	/// flags
	var/economy_account_flags = NONE
	/// account type
	var/account_type = ECONOMY_ACCOUNT_TYPE_PERSONAL


/proc/charge_to_account(var/attempt_account_number, var/source_name, var/purpose, var/terminal_id, var/amount)
	for(var/datum/economy_account/D in GLOB.all_money_accounts)
		if(D.account_number == attempt_account_number && !D.suspended)
			D.money += amount

			//create a transaction log entry
			var/datum/economy_transaction/T = new()
			T.target_name = source_name
			T.purpose = purpose
			if(amount < 0)
				T.amount = "([amount])"
			else
				T.amount = "[amount]"
			T.date = GLOB.current_date_string
			T.time = stationtime2text()
			T.source_terminal = terminal_id
			D.transaction_log.Add(T)

			return 1

	return 0

//this returns the first account datum that matches the supplied accnum/pin combination, it returns null if the combination did not match any account
/proc/attempt_account_access(var/attempt_account_number, var/attempt_pin_number, var/security_level_passed = 0)
	for(var/datum/economy_account/D in GLOB.all_money_accounts)
		if(D.account_number == attempt_account_number)
			if( D.security_level <= security_level_passed && (!D.security_level || D.remote_access_pin == attempt_pin_number) )
				return D
			break

/proc/get_account(var/account_number)
	for(var/datum/economy_account/D in GLOB.all_money_accounts)
		if(D.account_number == account_number)
			return D
