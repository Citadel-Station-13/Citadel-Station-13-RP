////////////////////
//! Claw Machine !//
////////////////////

/obj/machinery/computer/arcade/clawmachine
	name = "AlliCo Grab-a-Gift"
	desc = "Show off your arcade skills for that special someone!"
	icon_state = "clawmachine_new"
	icon_keyboard = null
	icon_screen = null
	circuit = /obj/item/circuitboard/arcade/clawmachine
	prize_override = list(/obj/random/plushie)
	var/wintick = 0
	var/winprob = 0
	var/instructions = "Insert 1 thaler or swipe a card to play!"
	var/gameStatus = "CLAWMACHINE_NEW"
	var/gamepaid = 0
	var/gameprice = 1
	var/winscreen = ""

// Payment
/obj/machinery/computer/arcade/clawmachine/attackby(obj/item/I, mob/user)
	if(..())
		return

	if(gamepaid == 0 && vendor_account && !vendor_account.suspended)
		var/paid = 0
		var/obj/item/card/id/W = I.GetID()
		if(W) //for IDs and PDAs and wallets with IDs
			paid = pay_with_card(W,I)
		else if(istype(I, /obj/item/spacecash/ewallet))
			var/obj/item/spacecash/ewallet/C = I
			paid = pay_with_ewallet(C)
		else if(istype(I, /obj/item/spacecash))
			var/obj/item/spacecash/C = I
			paid = pay_with_cash(C, user)
		if(paid)
			gamepaid = 1
			instructions = "Hit start to play!"
			return
		return

// Cash
/obj/machinery/computer/arcade/clawmachine/proc/pay_with_cash(obj/item/spacecash/cashmoney, mob/user)
	if(!emagged)
		if(gameprice > cashmoney.worth)

			// This is not a status display message, since it's something the character
			// themselves is meant to see BEFORE putting the money in
			to_chat(usr, "[icon2base64(cashmoney)] [SPAN_WARNING("That is not enough money.")]")
			return FALSE

		if(istype(cashmoney, /obj/item/spacecash))

			visible_message(SPAN_INFO("\The [usr] inserts some cash into \the [src]."))
			cashmoney.worth -= gameprice

			if(cashmoney.worth <= 0)
				usr.drop_from_inventory(cashmoney)
				qdel(cashmoney)
			else
				cashmoney.update_icon()

		// Machine has no idea who paid with cash
		credit_purchase("(cash)")
		return TRUE

	if(emagged)
		playsound(src, 'sound/arcade/steal.ogg', 50, TRUE, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		to_chat(user, SPAN_INFO("It doesn't seem to accept that! Seem you'll need to swipe a valid ID."))


///// Ewallet
/obj/machinery/computer/arcade/clawmachine/proc/pay_with_ewallet(obj/item/spacecash/ewallet/wallet)
	if(!emagged)
		visible_message(SPAN_INFO("\The [usr] swipes \the [wallet] through \the [src]."))
		playsound(src, 'sound/machines/id_swipe.ogg', 50, TRUE)
		if(gameprice > wallet.worth)
			visible_message(SPAN_INFO("Insufficient funds."))
			return FALSE
		else
			wallet.worth -= gameprice
			credit_purchase("[wallet.owner_name] (chargecard)")
			return TRUE

	if(emagged)
		playsound(src, 'sound/arcade/steal.ogg', 50, TRUE, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		to_chat(usr, SPAN_INFO("It doesn't seem to accept that! Seem you'll need to swipe a valid ID."))

///// ID
/obj/machinery/computer/arcade/clawmachine/proc/pay_with_card(obj/item/card/id/I, obj/item/ID_container)
	if(I==ID_container || ID_container == null)
		visible_message(SPAN_INFO("\The [usr] swipes \the [I] through \the [src]."))
	else
		visible_message(SPAN_INFO("\The [usr] swipes \the [ID_container] through \the [src]."))
	playsound(src, 'sound/machines/id_swipe.ogg', 50, 1)
	var/datum/money_account/customer_account = get_account(I.associated_account_number)
	if(!customer_account)
		visible_message(SPAN_WARNING("Error: Unable to access account. Please contact technical support if problem persists."))
		return FALSE

	if(customer_account.suspended)
		visible_message(SPAN_BOLDWARNING("Unable to access account: account suspended."))
		return FALSE

	// Have the customer punch in the PIN before checking if there's enough money. Prevents people from figuring out acct is
	// empty at high security levels
	if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		customer_account = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!customer_account)
			visible_message(SPAN_WARNING("Unable to access account: incorrect credentials."))
			return FALSE

	if(gameprice > customer_account.money)
		visible_message(SPAN_WARNING("Insufficient funds in account."))
		return FALSE
	else
		// Okay to move the money at this point
		if(emagged)
			gameprice = customer_account.money
		// debit money from the purchaser's account
		customer_account.money -= gameprice

		// create entry in the purchaser's account log
		var/datum/transaction/T = new()
		T.target_name = "[vendor_account.owner_name] (via [name])"
		T.purpose = "Purchase of arcade game([name])"
		if(gameprice > 0)
			T.amount = "([gameprice])"
		else
			T.amount = "[gameprice]"
		T.source_terminal = name
		T.date = current_date_string
		T.time = stationtime2text()
		customer_account.transaction_log.Add(T)

		// Give the vendor the money. We use the account owner name, which means
		// that purchases made with stolen/borrowed card will look like the card
		// owner made them
		credit_purchase(customer_account.owner_name)
		return TRUE

/// Add to vendor account

/obj/machinery/computer/arcade/clawmachine/proc/credit_purchase(target as text)
	vendor_account.money += gameprice

	var/datum/transaction/T = new()
	T.target_name = target
	T.purpose = "Purchase of arcade game([name])"
	T.amount = "[gameprice]"
	T.source_terminal = name
	T.date = current_date_string
	T.time = stationtime2text()
	vendor_account.transaction_log.Add(T)

/// End Payment

/obj/machinery/computer/arcade/clawmachine/Initialize(mapload)
	. = ..()

/obj/machinery/computer/arcade/clawmachine/attack_hand(mob/living/user)
	if(..())
		return
	ui_interact(user)

/// TGUI Stuff

/obj/machinery/computer/arcade/clawmachine/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ClawMachine", name, ui_x = 300, ui_y = 400)
		ui.autoupdate = TRUE
		ui.open()

/obj/machinery/computer/arcade/clawmachine/ui_data(mob/user)
	var/list/data = list()

	data["wintick"] = wintick
	data["instructions"] = instructions
	data["gameStatus"] = gameStatus
	data["winscreen"] = winscreen

	return data

/obj/machinery/computer/arcade/clawmachine/ui_act(action, params)
	if(..())
		return

	if(action == "newgame" && gamepaid == 0)
		playsound(src, 'sound/arcade/steal.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)

	if(action == "newgame" && gamepaid == 1)
		gameStatus = "CLAWMACHINE_ON"
		icon_state = "clawmachine_new_move"
		instructions = "Guide the claw to the prize you want!"
		wintick = 0

	if(action == "return" && gameStatus == "CLAWMACHINE_END")
		gameStatus = "CLAWMACHINE_NEW"

	if(action == "pointless" && wintick < 10)
		wintick += 1

	if(action == "pointless" && wintick >= 10)
		instructions = "Insert 1 thaler or swipe a card to play!"
		clawvend()

/// True to a real claw machine, it's NEARLY impossible to win.
/obj/machinery/computer/arcade/clawmachine/proc/clawvend()
	winprob += 1 /// Yeah.

	if(prob(winprob)) /// YEAH.
		if(!emagged)
			prizevend()
			winscreen = "You won!"
		else if(emagged)
			gameprice = 1
			emagged = FALSE
			winscreen = "You won...?"
			var/obj/item/grenade/G = new /obj/item/grenade/explosive(get_turf(src)) /// YEAAAAAAAAAAAAAAAAAAH!!!!!!!!!!
			G.activate()
			G.throw_at(get_turf(usr),10,10) /// Play stupid games, win stupid prizes.

		playsound(src, 'sound/arcade/Ori_win.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		winprob = 0

	else
		playsound(src, 'sound/arcade/Ori_fail.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		winscreen = "Aw, shucks. Try again!"
	wintick = 0
	gamepaid = 0
	icon_state = "clawmachine_new"
	gameStatus = "CLAWMACHINE_END"

/obj/machinery/computer/arcade/clawmachine/emag_act(mob/user)
	if(!emagged)
		to_chat(user, SPAN_NOTICE("You modify the claw of the machine. The next one is sure to win! You just have to pay..."))
		name = "AlliCo Snag-A-Prize"
		desc = "Get some goodies, all for you!"
		instructions = "Swipe a card to play!"
		winprob = 100
		gamepaid = 0
		wintick = 0
		gameStatus = "CLAWMACHINE_NEW"
		emagged = TRUE
		return TRUE
