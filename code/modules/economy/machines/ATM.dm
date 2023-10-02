/*

TODO:
give money an actual use (QM stuff, vending machines)
send money to people (might be worth attaching money to custom database thing for this, instead of being in the ID)
log transactions

*/

GLOBAL_LIST_INIT(atm_sounds, list('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'))

/obj/item/card/id/var/money = 2000

/obj/machinery/atm
	name = "Automatic Teller Machine"
	desc = "For all your monetary needs!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	circuit =  /obj/item/circuitboard/atm
	/// can accept deposits using these payment types
	var/deposit_payment_types = PAYMENT_TYPE_CASH | PAYMENT_TYPE_HOLOCHIPS | PAYMENT_TYPE_CHARGE_CARD
	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/card/id/held_card
	var/editing_security_level = 0
	var/account_security_level = 0
	var/datum/effect_system/spark_spread/spark_system

/obj/machinery/atm/Initialize(mapload)
	. = ..()
	machine_id = "ATM Terminal #[GLOB.num_financial_terminals++]"
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/machinery/atm/process(delta_time)
	if(machine_stat & NOPOWER)
		return

	if(ticks_left_timeout > 0)
		ticks_left_timeout--
		if(ticks_left_timeout <= 0)
			authenticated_account = null
	if(ticks_left_locked_down > 0)
		ticks_left_locked_down--
		if(ticks_left_locked_down <= 0)
			number_incorrect_tries = 0

	for(var/obj/item/spacecash/S in src)
		S.loc = src.loc
		playsound(loc, pick(GLOB.atm_sounds), 50, 1)

/obj/machinery/atm/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		return

	//Short out the machine, shoot sparks, spew money!
	emagged = TRUE
	spark_system.start()
	spawn_money(rand(100,500),src.loc)
	//We don't want to grief people by locking their id in an emagged ATM
	release_held_id(user)

	//Display a message to the user
	var/response = pick("Initiating withdraw. Have a nice day!", "CRITICAL ERROR: Activating cash chamber panic siphon.","PIN Code accepted! Emptying account balance.", "Jackpot!")
	to_chat(user, SPAN_WARNING("[icon2html(thing = src, target = user)] The [src] beeps: \"[response]\""))
	return TRUE

/obj/machinery/atm/attackby(obj/item/I, mob/user)
	if(computer_deconstruction_screwdriver(user, I))
		return
	if(istype(I, /obj/item/card))
		if(emagged > 0)
			//prevent inserting id into an emagged ATM
			to_chat(user, SPAN_CAUTION("[icon2html(thing = src, target = user)] CARD READER ERROR. This system has been compromised!"))
			return
		else if(istype(I,/obj/item/card/emag))
			I.resolve_attackby(src, user)
			return

		var/obj/item/card/id/idcard = I
		if(!held_card)
			if(!user.attempt_insert_item_for_installation(idcard, src))
				return
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
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
			var/datum/transaction/T = new()
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

/obj/machinery/atm/proc/generate_ui_transaction_log(var/list/transaction_list)
	var/list/passed_list = list()
	for(var/datum/transaction/T in transaction_list)
		var/transaction_num = 0
		var/list/new_list = list()
		new_list["target_name"] = T.target_name
		new_list["purpose"] = T.purpose
		new_list["amount"] = T.amount
		new_list["date"] = T.date
		new_list["time"] = T.time
		new_list["source_terminal"] = T.source_terminal
		transaction_num++
		passed_list["[transaction_num]"] = new_list
	return passed_list

/obj/machinery/atm/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ATM", "[machine_id]")
		ui.open()

/obj/machinery/atm/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/data[0]

	data["incorrect_attempts"] = number_incorrect_tries
	data["max_pin_attempts"] = max_pin_attempts
	data["ticks_left_locked_down"] = ticks_left_locked_down
	data["emagged"] = emagged
	data["authenticated_acc"] = (authenticated_account ? 1 : 0)
	data["account_name"] = authenticated_account?.owner_name || "UNKWN"
	data["transaction_log"] = generate_ui_transaction_log(authenticated_account?.transaction_log || list())
	data["account_security_level"] = account_security_level
	data["current_account_security_level"] = authenticated_account?.security_level
	data["acc_suspended"] = authenticated_account?.suspended || 0
	data["balance"] = authenticated_account?.money || 0
	data["machine_id"] = machine_id
	data["card_inserted"] = (held_card ? TRUE : FALSE)
	data["inserted_card_name"] = (held_card ? held_card.registered_name : "--INSERT CARD--")
	data["logout_time"] = DisplayTimeText(ticks_left_timeout * 10)

	return data

/obj/machinery/atm/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
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
			if(authenticated_account)
				var/obj/item/paper/R = new(src.loc)
				R.name = "Account balance: [authenticated_account.owner_name]"
				R.info = "<b>NT Automated Teller Account Statement</b><br><br>"
				R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
				R.info += "<i>Account number:</i> [authenticated_account.account_number]<br>"
				R.info += "<i>Balance:</i> $[authenticated_account.money]<br>"
				R.info += "<i>Date and time:</i> [stationtime2text()], [GLOB.current_date_string]<br><br>"
				R.info += "<i>Service terminal ID:</i> [machine_id]<br>"

				//stamp the paper
				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.icon_state = "paper_stamp-cent"
				if(!R.stamped)
					R.stamped = new
				R.stamped += /obj/item/stamp
				R.add_overlay(stampoverlay)
				R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"

				playsound(loc, pick(GLOB.atm_sounds), 50, 1)
		if("transfer")
			if(authenticated_account)
				var/transfer_amount = text2num(params["funds_amount"])
				transfer_amount = round(transfer_amount, 0.01)
				if(transfer_amount <= 0)
					alert("That is not a valid amount.")
				else if(transfer_amount <= authenticated_account.money)
					var/target_account_number = text2num(params["target_acc_number"])
					var/transfer_purpose = params["purpose"]
					if(charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
						to_chat(user, "[icon2html(thing = src, target = user)]<span class='info'>Funds transfer successful.</span>")
						authenticated_account.money -= transfer_amount

						//create an entry in the account transaction log
						var/datum/transaction/T = new()
						T.target_name = "Account #[target_account_number]"
						T.purpose = transfer_purpose
						T.source_terminal = machine_id
						T.date = GLOB.current_date_string
						T.time = stationtime2text()
						T.amount = "([transfer_amount])"
						authenticated_account.transaction_log.Add(T)
					else
						to_chat(user, "[icon2html(thing = src, target = user)]<span class='warning'>Funds transfer failed.</span>")
				else
					to_chat(user, "[icon2html(thing = src, target = user)]<span class='warning'>You don't have enough funds to do that!</span>")
		if("change_security_level")
			if(authenticated_account)
				var/new_sec_level = max( min(text2num(params["new_security_level"]), 2), 0)
				authenticated_account.security_level = new_sec_level
		if("withdrawal")
			var/amount = max(text2num(params["funds_amount"]),0)
			amount = round(amount, 0.01)
			if(amount <= 0)
				alert("That is not a valid amount.")
			else if(authenticated_account && amount > 0)
				if(amount <= authenticated_account.money)
					playsound(src, 'sound/machines/chime.ogg', 50, 1)

					//remove the money
					authenticated_account.money -= amount

					if(text2num(params["form_ewallet"]))
						spawn_ewallet(amount,src.loc,user)
					else
						spawn_money(amount,src.loc,user)

					//create an entry in the account transaction log
					var/datum/transaction/T = new()
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
			if(authenticated_account)
				var/obj/item/paper/R = new(src.loc)
				R.name = "Transaction logs: [authenticated_account.owner_name]"
				R.info = "<b>Transaction logs</b><br>"
				R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
				R.info += "<i>Account number:</i> [authenticated_account.account_number]<br>"
				R.info += "<i>Date and time:</i> [stationtime2text()], [GLOB.current_date_string]<br><br>"
				R.info += "<i>Service terminal ID:</i> [machine_id]<br>"
				R.info += "<table border=1 style='width:100%'>"
				R.info += "<tr>"
				R.info += "<td><b>Date</b></td>"
				R.info += "<td><b>Time</b></td>"
				R.info += "<td><b>Target</b></td>"
				R.info += "<td><b>Purpose</b></td>"
				R.info += "<td><b>Value</b></td>"
				R.info += "<td><b>Source terminal ID</b></td>"
				R.info += "</tr>"
				for(var/datum/transaction/T in authenticated_account.transaction_log)
					R.info += "<tr>"
					R.info += "<td>[T.date]</td>"
					R.info += "<td>[T.time]</td>"
					R.info += "<td>[T.target_name]</td>"
					R.info += "<td>[T.purpose]</td>"
					R.info += "<td>$[T.amount]</td>"
					R.info += "<td>[T.source_terminal]</td>"
					R.info += "</tr>"
				R.info += "</table>"

				//stamp the paper
				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.icon_state = "paper_stamp-cent"
				if(!R.stamped)
					R.stamped = new
				R.stamped += /obj/item/stamp
				R.add_overlay(stampoverlay)
				R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"

				playsound(loc, pick(GLOB.atm_sounds), 50, 1)
		if("logout")
			authenticated_account = null
			account_security_level = 0

/obj/machinery/atm/attack_hand(mob/user, list/params)
	if(istype(user, /mob/living/silicon))
		to_chat (user, SPAN_WARNING("A firewall prevents you from interfacing with this device!"))
		return
	ui_interact(user)

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user as mob)
	if(!authenticated_account)
		var/obj/item/card/id/I = human_user.GetIdCard()
		if(istype(I))
			return I

// put the currently held id on the ground or in the hand of the user
/obj/machinery/atm/proc/release_held_id(mob/living/carbon/human/human_user as mob)
	if(!held_card)
		return

	held_card.loc = src.loc
	authenticated_account = null
	account_security_level = 0

	if(ishuman(human_user) && !human_user.get_active_held_item())
		human_user.put_in_hands(held_card)
	held_card = null


/obj/machinery/atm/proc/spawn_ewallet(var/sum, loc, mob/living/carbon/human/human_user as mob)
	var/obj/item/spacecash/ewallet/E = new /obj/item/spacecash/ewallet(loc)
	if(ishuman(human_user) && !human_user.get_active_held_item())
		human_user.put_in_hands(E)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name

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
		var/datum/money_account/D
		//Below is to avoid a runtime
		if(tried_account_num)
			D = get_account(tried_account_num)
			if(D)
				to_chat(user, "remote acc [D.account_number] remote pin [D.remote_access_pin]")

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

					//create an entry in the account transaction log
					var/datum/money_account/failed_account = get_account(tried_account_num)
					if(failed_account)
						var/datum/transaction/T = new()
						T.target_name = failed_account.owner_name
						T.purpose = "Unauthorised login attempt"
						T.source_terminal = machine_id
						T.date = GLOB.current_date_string
						T.time = stationtime2text()
						failed_account.transaction_log.Add(T)
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
			var/datum/transaction/T = new()
			T.target_name = authenticated_account.owner_name
			T.purpose = "Remote terminal access"
			T.source_terminal = machine_id
			T.date = GLOB.current_date_string
			T.time = stationtime2text()
			authenticated_account.transaction_log.Add(T)

			to_chat(user, "<font color=#4F49AF>[icon2html(thing = src, target = user)] Access granted. Welcome user '[authenticated_account.owner_name].</font>'")

		previous_account_number = tried_account_num
