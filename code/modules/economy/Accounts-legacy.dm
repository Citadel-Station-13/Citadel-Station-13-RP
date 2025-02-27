#warn annhilate this goddamn file

//this returns the first account datum that matches the supplied accnum/pin combination, it returns null if the combination did not match any account
/proc/attempt_account_access(var/attempt_account_number, var/attempt_pin_number, var/valid_card)
	var/datum/economy_account/D = get_account(attempt_account_number)
	if(D && (D.security_level != 2 || valid_card) && (!D.security_level || D.remote_access_pin == attempt_pin_number) )
		return D

