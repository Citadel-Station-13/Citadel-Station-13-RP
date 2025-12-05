// todo: rewrite this from scratch
/obj/machinery/atm
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	/// can accept deposits using these payment types

/obj/machinery/atm/attackby(obj/item/I, mob/user)
	if(computer_deconstruction_screwdriver(user, I))
		return
	if(istype(I, /obj/item/card))
		if(emagged > 0)
			//prevent inserting id into an emagged ATM
			to_chat(user, SPAN_CAUTION("[icon2html(thing = src, target = user)] CARD READER ERROR. This system has been compromised!"))
			return

		var/obj/item/card/id/idcard = I
		if(!held_card)
			if(!user.attempt_insert_item_for_installation(idcard, src))
				return
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_id)
				authenticated_account = null
	else if(authenticated_account)
		var/can_deposit = I.is_static_currency(PAYMENT_TYPES_ALLOW_ONLY(deposit_payment_types))
		if(can_deposit)
			var/amount = I.consume_static_currency(INFINITY, TRUE, user, src, 3)
			if(!amount)
				return
			authenticated_account.money += amount
			if(prob(50))
				playsound(src, 'sound/items/polaroid1.ogg', 50, 1)
			else
				playsound(src, 'sound/items/polaroid2.ogg', 50, 1)

			//create a transaction log entry
			var/datum/economy_transaction/T = new()
			T.target_name = authenticated_account.owner_name
			T.purpose = "Credit deposit"
			T.amount = amount
			T.source_terminal = machine_id
			T.date = GLOB.current_date_string
			T.time = stationtime2text()
			authenticated_account.transaction_log.Add(T)
			attack_hand(user)
			if(!QDELETED(I))
				qdel(I)		// chargecards don't delete
	else
		..()

/obj/machinery/atm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/user = usr
	switch(action)
		if("attempt_authentication")
			attempt_authentication(user, text2num(params["pin"]), text2num(params["acc"]))
		if("eject_card")
			if(held_card)
				authenticated_account = null
				account_security_level = 0
				release_held_id(user)
			else
				//this might happen if the user had the browser window open when somebody emagged it
				if(emagged > 0)
					to_chat(user, "<font color='red'>[icon2html(thing = src, target = user)] The ATM card reader rejected your ID because this machine has been sabotaged!</font>")
				else
					var/obj/item/I = user.get_active_held_item()
					if (istype(I, /obj/item/card/id))
						if(!user.attempt_insert_item_for_installation(I, src))
							return
						held_card = I
		if("balance_statement")
			if(!authenticated_account)
				return TRUE
			var/obj/item/paper/R = new(src.loc)
			R.name = "Account balance: [authenticated_account.owner_name]"
			R.info = "<b>NT Automated Teller Account Statement</b><br><br>"
			R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
			R.info += "<i>Account number:</i> [authenticated_account.account_id]<br>"
			R.info += "<i>Balance:</i> $[authenticated_account.balance]<br>"
			R.info += "<i>Date and time:</i> [stationtime2text()], [GLOB.current_date_string]<br><br>"
			R.info += "<i>Service terminal ID:</i> [machine_id]<br>"
		if("transfer")
			if(!authenticated_account)
				return
			var/transfer_amount = text2num(params["funds_amount"])
			transfer_amount = round(transfer_amount, 0.01)
			if(transfer_amount <= 0)
				to_chat(user, "[icon2html(thing = src, target = user)]<span class='warning'>That is not a valid amount.</span>")
				return TRUE
			if(transfer_amount > authenticated_account.balance)
				to_chat(user, "[icon2html(thing = src, target = user)]<span class='warning'>You don't have enough funds to do that!</span>")
				return TRUE
			var/target_account_number = text2num(params["target_acc_number"])
			var/transfer_purpose = params["purpose"]
			#warn impl
			var/datum/economy_transaction/transfer_transaction = new(transfer_amount)
			if(charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
				to_chat(user, "[icon2html(thing = src, target = user)]<span class='info'>Funds transfer successful.</span>")
				authenticated_account.money -= transfer_amount

				//create an entry in the account transaction log
				var/datum/economy_transaction/T = new()
				T.target_name = "Account #[target_account_number]"
				T.purpose = transfer_purpose
				T.source_terminal = machine_id
				T.date = GLOB.current_date_string
				T.time = stationtime2text()
				T.amount = "([transfer_amount])"
				authenticated_account.transaction_log.Add(T)
			else
				to_chat(user, "[icon2html(thing = src, target = user)]<span class='warning'>Funds transfer failed.</span>")
		if("change_security_level")
			if(!authenticated_account)
				return
			var/new_sec_level = max( min(text2num(params["new_security_level"]), 2), 0)
			authenticated_account.security_level = new_sec_level
		if("withdrawal")
			if(!authenticated_account)
				return TRUE
			var/amount = max(text2num(params["funds_amount"]),0)
			amount = round(amount, 0.01)
			if(amount <= 0)
				alert("That is not a valid amount.")
			if(amount <= authenticated_account.money)
				playsound(src, 'sound/machines/chime.ogg', 50, 1)

				//remove the money
				authenticated_account.money -= amount

				if(text2num(params["form_ewallet"]))
					spawn_ewallet(amount,src.loc,user)
				else
					spawn_money(amount,src.loc,user)

				//create an entry in the account transaction log
				var/datum/economy_transaction/T = new()
				T.target_name = authenticated_account.owner_name
				T.purpose = "Credit withdrawal"
				T.amount = "([amount])"
				T.source_terminal = machine_id
				T.date = GLOB.current_date_string
				T.time = stationtime2text()
				authenticated_account.transaction_log.Add(T)
			else
				to_chat(user, "[icon2html(thing = src, target = user)]<span class='warning'>You don't have enough funds to do that!</span>")

		if ("print_transaction")
			if(!authenticated_account)
				return
			var/obj/item/paper/R = new(src.loc)
			R.name = "Transaction logs: [authenticated_account.owner_name]"
			R.info = "<b>Transaction logs</b><br>"
			R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
			R.info += "<i>Account number:</i> [authenticated_account.account_id]<br>"
			R.info += "<i>Date and time:</i> [stationtime2text()], [GLOB.current_date_string]<br><br>"
			R.info += "<i>Service terminal ID:</i> [machine_id]<br>"

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user as mob)
	if(!authenticated_account)
		var/obj/item/card/id/I = human_user.GetIdCard()
		if(istype(I))
			return I

/obj/machinery/atm/proc/attempt_authentication(var/mob/user, var/input_pin, var/input_acc)
	var/obj/item/card/id/login_card
	if(held_card)
		login_card = held_card
	else
		login_card = scan_user(user)

	if(!ticks_left_locked_down)
		var/tried_account_num = input_acc
		//We WILL need an account number entered manually if security is high enough, do not automagic account number
		if(!tried_account_num && login_card && (account_security_level != 2))
			tried_account_num = login_card.associated_account_number
		var/tried_pin = input_pin

		//We'll need more information if an account's security is greater than zero so let's find out what the security setting is
		var/datum/economy_account/D
		//Below is to avoid a runtime
		if(tried_account_num)
			D = get_account(tried_account_num)
			if(D)
				to_chat(user, "remote acc [D.account_id] remote pin [D.remote_access_pin]")

			if(D)
				account_security_level = D.security_level
		to_chat(user, "acc in [tried_account_num] pin [tried_pin]")
		to_chat(user, "get acc [get_account(tried_account_num)]")
		to_chat(user, "attempt accesss [attempt_account_access(tried_account_num, tried_pin, (login_card?.associated_account_number == tried_account_num))]")
		authenticated_account = attempt_account_access(tried_account_num, tried_pin, (login_card?.associated_account_number == tried_account_num))
		if(!authenticated_account)
			number_incorrect_tries++
			if(previous_account_number == tried_account_num)
				if(number_incorrect_tries > max_pin_attempts)
					//lock down the atm
					ticks_left_locked_down = 30
					playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
					// //create an entry in the account transaction log
					// todo: IC security log
					// var/datum/economy_account/failed_account = get_account(tried_account_num)
					// if(failed_account)
					// 	var/datum/economy_transaction/T = new()
					// 	T.target_name = failed_account.owner_name
					// 	T.purpose = "Unauthorised login attempt"
					// 	T.source_terminal = machine_id
					// 	T.date = GLOB.current_date_string
					// 	T.time = stationtime2text()
					// 	failed_account.transaction_log.Add(T)
				else
					to_chat(user, "<font color='red'>[icon2html(thing = src, target = user)] Incorrect pin/account combination entered, [max_pin_attempts - number_incorrect_tries] attempts remaining.</font>")
					previous_account_number = tried_account_num
					playsound(user, 'sound/machines/buzz-sigh.ogg', 50, 1)
			else
				to_chat(usr, "[icon2html(thing = src, target = user)] <span class='warning'>Unable to log in to account, additional information may be required.</span>")
				number_incorrect_tries = 0
		else
			playsound(user, 'sound/machines/twobeep.ogg', 50, 1)
			ticks_left_timeout = 120

			//create a transaction log entry
			// todo: IC security log
			// var/datum/economy_transaction/T = new()
			// T.target_name = authenticated_account.owner_name
			// T.purpose = "Remote terminal access"
			// T.source_terminal = machine_id
			// T.date = GLOB.current_date_string
			// T.time = stationtime2text()
			// authenticated_account.transaction_log.Add(T)

			to_chat(user, "<font color=#4F49AF>[icon2html(thing = src, target = user)] Access granted. Welcome user '[authenticated_account.owner_name].</font>'")

		previous_account_number = tried_account_num
