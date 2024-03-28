/**
 *  A vending machine
 */
/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	anchored = TRUE
	density = TRUE
	// todo: temporary, as this is unbuildable
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

//! ## Icons
	/// Icon_state when vending.
	var/icon_vend
	/// Icon_state when denying access.
	var/icon_deny

//! ## Power
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	var/vend_power_usage = 150 //actuators and stuff

//! ## Vending-related
	/// No sales pitches if off!
	var/active = TRUE
	/// Are we ready to vend?? Is it time??
	var/vend_ready = TRUE
	/// How long does it take to vend?
	var/vend_delay = 1 SECOND
	/// Bitmask of categories we're currently showing.
	var/categories = CAT_NORMAL
	/// What we're requesting payment for right now.
	var/datum/stored_item/vending_product/currently_vending = null
	/// Status screen messages like "insufficient funds", displayed in NanoUI.
	var/status_message = ""
	/// Set to TRUE if status_message is an error.
	var/status_error = FALSE

	/**
	 * Variables used to initialize the product list
	 * These are used for initialization only, and so are optional if
	 * product_records is specified
	*/
	var/list/products	= list() // For each, use the following pattern:
	var/list/contraband	= list() // list(/type/path = amount, /type/path2 = amount2)
	var/list/premium 	= list() // No specified amount = only one in stock
	var/list/prices     = list() // Prices for each item, list(/type/path = price), items not in the list don't have a price.
	var/price_default = 0

	/// List of vending_product items available.
	var/list/product_records = list()


	// Variables used to initialize advertising
	/// String of slogans spoken out loud, separated by semicolons.
	var/product_slogans = ""
	/// String of small ad messages in the vending screen.
	var/product_ads = ""

	var/list/ads_list = list()

	// Stuff relating vocalizations
	var/list/slogan_list = list()
	/// Set to true to silence it.
	var/shut_up = TRUE
	/// Thank you for shopping!
	var/vend_reply
	var/last_reply = FALSE
	/// When did we last pitch?
	var/last_slogan = 0
	/// How long until we can pitch again?
	var/slogan_delay = 10 MINUTES

	// Things that can go wrong
	/// Ignores if somebody doesn't have card access to that machine.
	emagged = FALSE
	/// Shock customers like an airlock.
	var/seconds_electrified = 0
	/// Fire items at customers! We're broken!
	var/shoot_inventory = FALSE

	var/scan_id = TRUE
	var/obj/item/coin/coin
	var/datum/wires/vending/wires = null

	var/list/log = list()

	/// Default access for checking logs is cargo.
	var/req_log_access = ACCESS_SUPPLY_BAY
	/// Defaults to 0, set to anything else for vendor to have logs.
	var/has_logs = NONE


/obj/machinery/vending/Initialize(mapload)
	. = ..()
	wires = new(src)
	spawn(4)
		if(product_slogans)
			slogan_list += splittext(product_slogans, ";")

			// So not all machines speak at the exact same time.
			// The first time this machine says something will be at slogantime + this random value,
			// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
			last_slogan = world.time + rand(0, slogan_delay)

		if(product_ads)
			ads_list += splittext(product_ads, ";")

		build_inventory()
		power_change()

/**
 *  Build produdct_records from the products lists
 *
 *  products, contraband, premium, and prices allow specifying
 *  products that the vending machine is to carry without manually populating
 *  product_records.
 */
/obj/machinery/vending/proc/build_inventory()
	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN),
		list(premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/datum/stored_item/vending_product/product = new/datum/stored_item/vending_product(src, entry)

			product.price = (entry in prices) ? prices[entry] : price_default
			product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product.category = category

			product_records.Add(product)

/obj/machinery/vending/Destroy()
	qdel(wires)
	wires = null
	qdel(coin)
	coin = null
	for(var/datum/stored_item/vending_product/R in product_records)
		qdel(R)
	product_records = null
	return ..()

/obj/machinery/vending/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				spawn(0)
					malfunction()
					return
				return
		else
	return

/obj/machinery/vending/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		to_chat(user, "You short out \the [src]'s product lock.")
		return 1

/obj/machinery/vending/attackby(obj/item/W, mob/user)
	var/obj/item/card/id/I = W.GetID()

	if(currently_vending && GLOB.vendor_account && !GLOB.vendor_account.suspended)
		var/paid = FALSE
		var/handled = FALSE

		var/obj/item/paying_with = I || W
		var/list/data = list()
		var/amount = paying_with.attempt_use_currency(user, src, currently_vending.price, FALSE, NONE, data, FALSE, 7)
		switch(amount)
			if(PAYMENT_DYNAMIC_ERROR)
				if(data[DYNAMIC_PAYMENT_DATA_FAIL_REASON])
					status_message = data[DYNAMIC_PAYMENT_DATA_FAIL_REASON]
					status_error = TRUE
				SSnanoui.update_uis(src)
				return
			if(PAYMENT_NOT_CURRENCY)
				handled = FALSE
			if(PAYMENT_INSUFFICIENT)
				handled = TRUE
				to_chat(user, SPAN_WARNING("That is not enough money!"))
			else
				handled = TRUE
				paid = amount == currently_vending.price

		if(handled)
			if(paid)
				var/payer_name = "Unknown"
				switch(data[DYNAMIC_PAYMENT_DATA_CURRENCY_TYPE])
					if(PAYMENT_TYPE_BANK_CARD)
						var/datum/money_account/A = data[DYNAMIC_PAYMENT_DATA_BANK_ACCOUNT]
						if(A)
							payer_name = A.owner_name
					else
						payer_name = "(cash)"
				credit_purchase(payer_name)
				vend(currently_vending, usr)
			SSnanoui.update_uis(src)
			return // don't smack that machine with your 2 thalers

	if(I || istype(W, /obj/item/spacecash))
		attack_hand(user)
		return
	else if(W.is_screwdriver())
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		playsound(src, W.tool_sound, 50, 1)
		cut_overlays()
		if(panel_open)
			add_overlay(image(icon, "[initial(icon_state)]-panel"))

		SSnanoui.update_uis(src)  // Speaker switch is on the main UI, not wires UI
		return
	else if(istype(W, /obj/item/multitool) || W.is_wirecutter())
		if(panel_open)
			attack_hand(user)
		return
	else if(istype(W, /obj/item/coin) && premium.len > 0)
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		coin = W
		categories |= CAT_COIN
		to_chat(user, "<span class='notice'>You insert \the [W] into \the [src].</span>")
		SSnanoui.update_uis(src)
		return
	else if(W.is_wrench())
		playsound(src, W.tool_sound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20 * W.tool_speed))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
			anchored = !anchored
		return
	else

		for(var/datum/stored_item/vending_product/R in product_records)
			if(istype(W, R.item_path) && (W.name == R.item_name))
				stock(W, R, user)
				return
		..()

/obj/machinery/vending/query_transaction_details(list/data)
	. = ..()
	.[CHARGE_DETAIL_DEVICE] = name
	.[CHARGE_DETAIL_LOCATION] = get_area(src).name
	.[CHARGE_DETAIL_REASON] = currently_vending? "Purchase of [currently_vending.item_name]" : "Unknown"
	.[CHARGE_DETAIL_RECIPIENT] = GLOB.vendor_account.owner_name

/**
 *  Add money for current purchase to the vendor account.
 *
 *  Called after the money has already been taken from the customer.
 */
/obj/machinery/vending/proc/credit_purchase(var/target as text)
	GLOB.vendor_account.money += currently_vending.price

	var/datum/transaction/T = new()
	T.target_name = target
	T.purpose = "Purchase of [currently_vending.item_name]"
	T.amount = "[currently_vending.price]"
	T.source_terminal = name
	T.date = GLOB.current_date_string
	T.time = stationtime2text()
	GLOB.vendor_account.transaction_log.Add(T)

/obj/machinery/vending/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vending/attack_hand(mob/user, list/params)
	if(machine_stat & (BROKEN|NOPOWER))
		return

	if(seconds_electrified != 0)
		if(shock(user, 100))
			return

	wires.Interact(user)
	nano_ui_interact(user)

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/vending/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	if(currently_vending)
		data["mode"] = 1
		data["product"] = currently_vending.item_name
		data["price"] = currently_vending.price
		data["message_err"] = 0
		data["message"] = status_message
		data["message_err"] = status_error
	else
		data["mode"] = 0
		var/list/listed_products = list()

		for(var/key = 1 to product_records.len)
			var/datum/stored_item/vending_product/I = product_records[key]

			if(!(I.category & categories))
				continue

			listed_products.Add(list(list(
				"key" = key,
				"name" = I.item_name,
				"price" = I.price,
				"color" = I.display_color,
				"amount" = I.get_amount())))

		data["products"] = listed_products

	if(coin)
		data["coin"] = coin.name

	if(panel_open)
		data["panel"] = 1
		data["speaker"] = shut_up ? 0 : 1
	else
		data["panel"] = 0

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "vending_machine.tmpl", name, 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/vending/Topic(href, href_list)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if(!IsAdminGhost(usr) && (usr.stat || usr.restrained()))
		return

	if(href_list["remove_coin"] && !istype(usr,/mob/living/silicon))
		if(!coin)
			to_chat(usr, "There is no coin in this machine.")
			return

		coin.forceMove(src.loc)
		if(!usr.get_active_held_item())
			usr.put_in_hands(coin)
		to_chat(usr, "<span class='notice'>You remove \the [coin] from \the [src]</span>")
		coin = null
		categories &= ~CAT_COIN

	if(IsAdminGhost(usr) || (usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		if((href_list["vend"]) && (vend_ready) && (!currently_vending))
			if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
				to_chat(usr, "<span class='warning'>Access denied.</span>")	//Unless emagged of course
				flick(icon_deny,src)
				playsound(src.loc, 'sound/machines/deniedbeep.ogg', 50, 0)
				return

			var/key = text2num(href_list["vend"])
			var/datum/stored_item/vending_product/R = product_records[key]

			// This should not happen unless the request from NanoUI was bad
			if(!(R.category & categories))
				return

			if((R.price <= 0) || IsAdminGhost(usr))
				vend(R, usr)
			else if(istype(usr,/mob/living/silicon)) //If the item is not free, provide feedback if a synth is trying to buy something.
				to_chat(usr, "<span class='danger'>Lawed unit recognized.  Lawed units cannot complete this transaction.  Purchase canceled.</span>")
				return
			else
				currently_vending = R
				if(!GLOB.vendor_account || GLOB.vendor_account.suspended)
					status_message = "This machine is currently unable to process payments due to issues with the associated account."
					status_error = 1
				else
					status_message = "Please swipe a card or insert cash to pay for the item."
					status_error = 0

		else if(href_list["cancelpurchase"])
			currently_vending = null

		else if((href_list["togglevoice"]) && (panel_open))
			shut_up = !shut_up

		SSnanoui.update_uis(src)

/obj/machinery/vending/proc/vend(datum/stored_item/vending_product/R, mob/user)
	if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
		to_chat(usr, "<span class='warning'>Access denied.</span>")	//Unless emagged of course
		flick(icon_deny,src)
		playsound(src.loc, 'sound/machines/deniedbeep.ogg', 50, 0)
		return
	vend_ready = 0 //One thing at a time!!
	status_message = "Vending..."
	status_error = 0
	SSnanoui.update_uis(src)

	if(R.category & CAT_COIN)
		if(!coin)
			to_chat(user, "<span class='notice'>You need to insert a coin to get this item.</span>")
			return
		if(coin.string_attached)
			if(prob(50))
				to_chat(user, "<span class='notice'>You successfully pull the coin out before \the [src] could swallow it.</span>")
			else
				to_chat(user, "<span class='notice'>You weren't able to pull the coin out fast enough, the machine ate it, string and all.</span>")
				qdel(coin)
				coin = null
				categories &= ~CAT_COIN
		else
			qdel(coin)
			coin = null
			categories &= ~CAT_COIN

	if(((last_reply + (vend_delay + 200)) <= world.time) && vend_reply)
		spawn(0)
			speak(vend_reply)
			last_reply = world.time

	use_power(vend_power_usage)	//actuators and stuff
	if(icon_vend) //Show the vending animation if needed
		flick(icon_vend,src)
	spawn(vend_delay)
		R.get_product(get_turf(src))
		if(has_logs)
			do_logging(R, user, 1)
		if(prob(1))
			sleep(3)
			if(R.get_product(get_turf(src)))
				visible_message("<span class='notice'>\The [src] clunks as it vends an additional item.</span>")

		playsound(src, 'sound/items/vending.ogg', 50, 1, 1)

		status_message = ""
		status_error = 0
		vend_ready = 1
		currently_vending = null
		SSnanoui.update_uis(src)

	return 1

/obj/machinery/vending/proc/do_logging(datum/stored_item/vending_product/R, mob/user, var/vending = 0)
	if(user.GetIdCard())
		var/obj/item/card/id/tempid = user.GetIdCard()
		var/list/list_item = list()
		if(vending)
			list_item += "vend"
		else
			list_item += "stock"
		list_item += tempid.registered_name
		list_item += stationtime2text()
		list_item += R.item_name
		log[++log.len] = list_item

/obj/machinery/vending/proc/show_log(mob/user as mob)
	if(user.GetIdCard())
		var/obj/item/card/id/tempid = user.GetIdCard()
		if(req_log_access in tempid.GetAccess())
			var/datum/browser/popup = new(user, "vending_log", "Vending Log", 700, 500)
			var/dat = ""
			dat += "<center><span style='font-size:24pt'><b>[name] Vending Log</b></span></center>"
			dat += "<center><span style='font-size:16pt'>Welcome [user.name]!</span></center><br>"
			dat += "<span style='font-size:8pt'>Below are the recent vending logs for your vending machine.</span><br>"
			for(var/i in log)
				dat += json_encode(i)
				dat += ";<br>"
			popup.set_content(dat)
			popup.open()
	else
		to_chat(user,"<span class='warning'>You do not have the required access to view the vending logs for this machine.</span>")

/obj/machinery/vending/verb/check_logs()
	set name = "Check Vending Logs"
	set category = "Object"
	set src in oview(1)

	show_log(usr)

/**
 * Add item to the machine
 *
 * Checks if item is vendable in this machine should be performed before
 * calling. W is the item being inserted, R is the associated vending_product entry.
 */
/obj/machinery/vending/proc/stock(obj/item/W, var/datum/stored_item/vending_product/R, var/mob/user)
	if(!user.attempt_insert_item_for_installation(W, src))
		return

	to_chat(user, "<span class='notice'>You insert \the [W] in the product receptor.</span>")
	R.add_product(W)
	if(has_logs)
		do_logging(R, user)

	SSnanoui.update_uis(src)

/obj/machinery/vending/process(delta_time)
	if(machine_stat & (BROKEN|NOPOWER))
		return

	if(!active)
		return

	if(seconds_electrified > 0)
		seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(((last_slogan + slogan_delay) <= world.time) && (slogan_list.len > 0) && (!shut_up) && prob(5))
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time

	if(shoot_inventory && prob(2))
		throw_item()

	return

/obj/machinery/vending/proc/speak(message)
	if(machine_stat & NOPOWER)
		return

	if(!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>",2)
	return

/obj/machinery/vending/power_change()
	..()
	if(machine_stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if(!(machine_stat & NOPOWER))
			icon_state = initial(icon_state)
		else
			spawn(rand(0, 15))
				icon_state = "[initial(icon_state)]-off"

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	for(var/datum/stored_item/vending_product/R in product_records)
		while(R.get_amount()>0)
			R.get_product(loc)
		break

	machine_stat |= BROKEN
	icon_state = "[initial(icon_state)]-broken"
	return

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_item/vending_product/R in product_records)
		throw_item = R.get_product(loc)
		if(!throw_item)
			continue
		break
	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at_old(target, 16, 3, src)
	visible_message("<span class='warning'>\The [src] launches \a [throw_item] at \the [target]!</span>")
	return 1

/* Template for creating new vendors

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 15
	products = list()
	contraband = list()
	premium = list()

*/


