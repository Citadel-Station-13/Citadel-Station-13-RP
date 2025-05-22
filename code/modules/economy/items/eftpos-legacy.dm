#warn replace on maps
/obj/item/eftpos
	icon = 'icons/obj/device.dmi'
	icon_state = "eftpos"
	var/machine_id = ""
	var/eftpos_name = "Default EFTPOS scanner"
	var/transaction_locked = 0
	var/transaction_paid = 0
	var/transaction_amount = 0
	var/transaction_purpose = "Default charge"
	var/access_code = 0
	var/datum/economy_account/linked_account

/obj/item/eftpos/attackby(obj/item/O as obj, user as mob)

	var/obj/item/card/id/I = O.GetID()

	if(I)
		if(linked_account)
			scan_card(I, O)
		else
			to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>Unable to connect to linked account.</span>")
	else if (istype(O, /obj/item/charge_card))
		var/obj/item/charge_card/E = O
		if (linked_account)
			if(!linked_account.suspended)
				if(transaction_locked && !transaction_paid)
					if(transaction_amount <= E.worth)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)
						src.visible_message("[icon2html(thing = src, target = world)] \The [src] chimes.")
						transaction_paid = 1

						//transfer the money
						E.worth -= transaction_amount
						linked_account.money += transaction_amount

						//create entry in the EFTPOS linked account transaction log
						var/datum/economy_transaction/T = new()
						T.target_name = E.owner_name //D.owner_name
						T.purpose = (transaction_purpose ? transaction_purpose : "None supplied.")
						T.amount = transaction_amount
						T.source_terminal = machine_id
						T.date = GLOB.current_date_string
						T.time = stationtime2text()
						linked_account.transaction_log.Add(T)
					else
						to_chat(usr, "[icon2html(thing = src, target = user)]<span class='warning'>\The [O] doesn't have that much money!</span>")
			else
				to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>Connected account has been suspended.</span>")
		else
			to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>EFTPOS is not connected to an account.</span>")

	else
		..()

/obj/item/eftpos/Topic(var/href, var/href_list)
	if(href_list["choice"])
		switch(href_list["choice"])
			if("change_id")
				var/attempt_code = text2num(input("Re-enter the current EFTPOS access code", "Confirm EFTPOS code"))
				if(attempt_code == access_code)
					eftpos_name = sanitize(input("Enter a new terminal ID for this device", "Enter new EFTPOS ID"), MAX_NAME_LEN) + " EFTPOS scanner"
					print_reference()
				else
					to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>Incorrect code entered.</span>")
			if("toggle_lock")
				if(transaction_locked)
					if (transaction_paid)
						transaction_locked = 0
						transaction_paid = 0
					else
						var/attempt_code = input("Enter EFTPOS access code", "Reset Transaction") as num
						if(attempt_code == access_code)
							transaction_locked = 0
							transaction_paid = 0
				else if(linked_account)
					transaction_locked = 1
				else
					to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>No account connected to send transactions to.</span>")
			if("scan_card")
				if(linked_account)
					var/obj/item/I = usr.get_active_held_item()
					if (istype(I, /obj/item/card))
						scan_card(I)
				else
					to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>Unable to link accounts.</span>")
			if("reset")
				//reset the access code - requires HoP/captain access
				var/obj/item/I = usr.get_active_held_item()
				if (istype(I, /obj/item/card))
					var/obj/item/card/id/C = I
					if((ACCESS_CENTCOM_ADMIRAL in C.access) || (ACCESS_COMMAND_HOP in C.access) || (ACCESS_COMMAND_CAPTAIN in C.access))
						access_code = 0
						to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='info'>Access code reset to 0.</span>")
				else if (istype(I, /obj/item/card/emag))
					access_code = 0
					to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='info'>Access code reset to 0.</span>")

/obj/item/eftpos/proc/scan_card(var/obj/item/card/I, var/obj/item/ID_container)
	if (istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		if(I==ID_container || ID_container == null)
			usr.visible_message("<span class='info'>\The [usr] swipes a card through \the [src].</span>")
		else
			usr.visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
		if(transaction_locked && !transaction_paid)
			if(linked_account)
				if(!linked_account.suspended)
					var/attempt_pin = ""
					var/datum/economy_account/D = get_account(C.associated_account_number)
					if(D.security_level)
						attempt_pin = input("Enter pin code", "EFTPOS transaction") as num
						D = null
					D = attempt_account_access(C.associated_account_number, attempt_pin, 2)
					if(D)
						if(!D.suspended)
							if(transaction_amount <= D.money)
								playsound(src, 'sound/machines/chime.ogg', 50, 1)
								src.visible_message("[icon2html(thing = src, target = world)] \The [src] chimes.")
								transaction_paid = 1

								//transfer the money
								D.money -= transaction_amount
								linked_account.money += transaction_amount

								//create entries in the two account transaction logs
								var/datum/economy_transaction/T = new()
								T.target_name = "[linked_account.owner_name] (via [eftpos_name])"
								T.purpose = transaction_purpose
								if(transaction_amount > 0)
									T.amount = "([transaction_amount])"
								else
									T.amount = "[transaction_amount]"
								T.source_terminal = machine_id
								T.date = GLOB.current_date_string
								T.time = stationtime2text()
								D.transaction_log.Add(T)
								//
								T = new()
								T.target_name = D.owner_name
								T.purpose = transaction_purpose
								T.amount = "[transaction_amount]"
								T.source_terminal = machine_id
								T.date = GLOB.current_date_string
								T.time = stationtime2text()
								linked_account.transaction_log.Add(T)
							else
								to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>You don't have that much money!</span>")
						else
							to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>Your account has been suspended.</span>")
					else
						to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>Unable to access account. Check security settings and try again.</span>")
				else
					to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>Connected account has been suspended.</span>")
			else
				to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='warning'>EFTPOS is not connected to an account.</span>")
	else if (istype(I, /obj/item/card/emag))
		if(transaction_locked)
			if(transaction_paid)
				to_chat(usr, "[icon2html(thing = src, target = usr)]<span class='info'>You stealthily swipe \the [I] through \the [src].</span>")
				transaction_locked = 0
				transaction_paid = 0
			else
				usr.visible_message("<span class='info'>\The [usr] swipes a card through \the [src].</span>")
				playsound(src, 'sound/machines/chime.ogg', 50, 1)
				src.visible_message("[icon2html(thing = src, target = world)] \The [src] chimes.")
				transaction_paid = 1
