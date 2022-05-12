/obj/machinery/computer/stockexchange
	name = "stock exchange computer"
	desc = "A console that connects to the galactic stock market. Stocks trading involves substantial risk of loss and is not suitable for every cargo technician."
	icon = 'icons/obj/computer.dmi'
	icon_state = "stockmarket"
	icon_screen = "stocks"
	icon_keyboard = "stockmarket_key"
	var/logged_in = "Cargo Department"
	var/vmode = 1
	light_color = LIGHT_COLOR_GREEN

/obj/machinery/computer/stockexchange/Initialize()
	. = ..()
	logged_in = "Cargo Department"

/obj/machinery/computer/stockexchange/attack_hand(mob/user)
	if(..(user))
		return

	//if(!ai_control && issilicon(user))
	//	to_chat(user, SPAN_WARNING("Access Denied."))
	//	return TRUE

	ui_interact(user)

/obj/machinery/computer/stockexchange/proc/balance()
	if(!logged_in)
		return FALSE
	return SSsupply.points

//! ## MAIN TGUI SCREEN ## !//

/obj/machinery/computer/stockexchange/ui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("logout")
			logged_in = null

		if("stocks_buy")
			var/datum/stock/S = locate(params["share"]) in GLOB.stockExchange.stocks
			if(S)
				buy_some_shares(S, usr)

		if("stocks_sell")
			var/datum/stock/S = locate(params["share"]) in GLOB.stockExchange.stocks
			if(S)
				sell_some_shares(S, usr)

		if("stocks_check")
			var/dat = "<html><head><title>Stock Transaction Logs</title></head><body><h2>Stock Transaction Logs</h2><div><a href='?src=[REF(src)];show_logs=1'>Refresh</a></div></br>"
			for(var/D in GLOB.stockExchange.logs)
				var/datum/stock_log/L = D
				if(istype(L, /datum/stock_log/buy))
					dat += "[L.time] | <b>[L.user_name]</b> bought <b>[L.stocks]</b> stocks at [L.shareprice] a share for <b>[L.money]</b> total credits in <b>[L.company_name]</b>.</br>"
					continue
				if(istype(L, /datum/stock_log/sell))
					dat += "[L.time] | <b>[L.user_name]</b> sold <b>[L.stocks]</b> stocks at [L.shareprice] a share for <b>[L.money]</b> total credits from <b>[L.company_name]</b>.</br>"
					continue
				if(istype(L, /datum/stock_log/borrow))
					dat += "[L.time] | <b>[L.user_name]</b> borrowed <b>[L.stocks]</b> stocks with a deposit of <b>[L.money]</b> credits in <b>[L.company_name]</b>.</br>"
					continue
			var/datum/browser/popup = new(usr, "stock_logs", "Stock Transaction Logs", 600, 400)
			popup.set_content(dat)
			popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()

		if("stocks_archive")
			var/datum/stock/S = locate(params["share"])
			if(logged_in && logged_in != "")
				var/list/LR = GLOB.stockExchange.last_read[S]
				LR[logged_in] = world.time
			var/dat = "<html><head><title>News feed for [S.name]</title></head><body><h2>News feed for [S.name]</h2><div><a href='?src=[REF(src)];archive=[REF(S)]'>Refresh</a></div>"
			dat += "<div><h3>Events</h3>"
			var/p = 0
			for(var/datum/stockEvent/E in S.events)
				if(E.hidden)
					continue
				if(p > 0)
					dat += "<hr>"
				dat += "<div><b>[E.current_title]</b></br>[E.current_desc]</div>"
				p++
			dat += "</div><hr><div><h3>Articles</h3>"
			p = 0
			for(var/datum/article/A in S.articles)
				if(p > 0)
					dat += "<hr>"
				dat += "<div><b>[A.headline]</b><br><i>[A.subtitle]</i><br><br>[A.article]<br>- [A.author], [A.spacetime] (via <i>[A.outlet]</i>)</div>"
				p++
			dat += "</div></body></html>"
			var/datum/browser/popup = new(usr, "archive_[S.name]", "Stock News", 600, 400)
			popup.set_content(dat)
			popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()

		if("stocks_history")
			var/datum/stock/S = locate(params["share"]) in GLOB.stockExchange.stocks
			if(S)
				S.displayValues(usr)

		if("stocks_cycle_view")
			vmode++
			if(vmode > 1)
				vmode = 0

/obj/machinery/computer/stockexchange/ui_data(mob/user)
	var/list/data = list()

	data["stationName"] = GLOB.using_map.station_name
	data["balance"] = balance()

	if(vmode)
		data["viewMode"] = "Full"
	else
		data["viewMode"] = "Compressed"

	for(var/datum/stock/S in GLOB.stockExchange.last_read)
		var/list/LR = GLOB.stockExchange.last_read[S]
		if(!(logged_in in LR))
			LR[logged_in] = 0

	data["stocks"] = list()

	if(vmode)
		for(var/datum/stock/S in GLOB.stockExchange.stocks)
			var/mystocks = 0
			if(logged_in && (logged_in in S.shareholders))
				mystocks = S.shareholders[logged_in]

			var/value = 0
			if(!S.bankrupt)
				value = S.current_value

			data["stocks"] += list(list(
				"REF" = REF(S),
				"valueChange" = S.disp_value_change, // > 0 is +, < 0 is -, else its =
				"bankrupt" = S.bankrupt,
				"ID" = S.short_name,
				"Name" = S.name,
				"Value" = value,
				"Owned" = mystocks,
				"Avail" = S.available_shares,
				"Products" = S.products,
			))

			var/news = 0
			if(logged_in)
				var/list/LR = GLOB.stockExchange.last_read[S]
				var/lrt = LR[logged_in]
				for(var/datum/article/A in S.articles)
					if(A.ticks > lrt)
						news = 1
						break
				if(!news)
					for(var/datum/stockEvent/E in S.events)
						if(E.last_change > lrt && !E.hidden)
							news = 1
	else
		for(var/datum/stock/S in GLOB.stockExchange.stocks)
			var/mystocks = 0
			if(logged_in && (logged_in in S.shareholders))
				mystocks = S.shareholders[logged_in]

			var/unification = 0
			if(S.last_unification)
				unification = DisplayTimeText(world.time - S.last_unification)

			data["stocks"] += list(list(
				"REF" = REF(S),
				"bankrupt" = S.bankrupt,
				"ID" = S.short_name,
				"Name" = S.name,
				"Owned" = mystocks,
				"Avail" = S.available_shares,
				"Unification" = unification,
				"Products" = S.products,
			))

			var/news = 0
			if(logged_in)
				var/list/LR = GLOB.stockExchange.last_read[S]
				var/lrt = LR[logged_in]
				for(var/datum/article/A in S.articles)
					if(A.ticks > lrt)
						news = 1
						break
				if(!news)
					for(var/datum/stockEvent/E in S.events)
						if(E.last_change > lrt && !E.hidden)
							news = 1
							break

	return data

/obj/machinery/computer/stockexchange/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StockExchange")
		ui.open()

//! ## HISTORY SCREEN ## !//

/obj/machinery/computer/stockexchange/history/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StockExchangeHistory")
		ui.open()

/obj/machinery/computer/stockexchange/history/ui_data(mob/user)
	var/list/data = list()
	//data["var"] = var
	return data

/obj/machinery/computer/stockexchange/history/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("copypasta")
			//var/newvar = params["var"]
			// A demo of proper input sanitation.
			//var = CLAMP(newvar, min_val, max_val)
			. = TRUE

//! ## ARCHIVE SCREEN ## !//

/obj/machinery/computer/stockexchange/archive/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StockExchangeArchive")
		ui.open()

/obj/machinery/computer/stockexchange/archive/ui_data(mob/user)
	var/list/data = list()
	//data["var"] = var
	return data

/obj/machinery/computer/stockexchange/archive/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("copypasta")
			//var/newvar = params["var"]
			// A demo of proper input sanitation.
			//var = CLAMP(newvar, min_val, max_val)
			. = TRUE

//! ## PROCS ## !//

/obj/machinery/computer/stockexchange/proc/sell_some_shares(datum/stock/S, mob/user)
	if(!user || !S)
		return

	var/li = logged_in
	if(!li)
		to_chat(user, SPAN_DANGER("No active account on the console!"))
		return
	var/b = SSsupply.points
	var/avail = S.shareholders[logged_in]
	if(!avail)
		to_chat(user, SPAN_DANGER("This account does not own any shares of [S.name]!"))
		return
	var/price = S.current_value
	var/amt = round(input(user, "How many shares? \n(Have: [avail], unit price: [price])", "Sell shares in [S.name]", 0) as num|null)
	amt = min(amt, S.shareholders[logged_in])

	if(!user || (!(user in range(1, src)) && iscarbon(user)))
		return
	if(!amt)
		return
	if(li != logged_in)
		return
	b = SSsupply.points
	if(!isnum(b))
		to_chat(user, SPAN_DANGER("No active account on the console!"))
		return

	var/total = amt * S.current_value
	if(!S.sellShares(logged_in, amt))
		to_chat(user, SPAN_DANGER("Could not complete transaction."))
		return
	to_chat(user, SPAN_NOTICE("Sold [amt] shares of [S.name] at [S.current_value] a share for [total] credits."))
	GLOB.stockExchange.add_log(/datum/stock_log/sell, user.name, S.name, amt, S.current_value, total)

/obj/machinery/computer/stockexchange/proc/buy_some_shares(var/datum/stock/S, var/mob/user)
	if(!user || !S)
		return

	var/li = logged_in
	if(!li)
		to_chat(user, SPAN_DANGER("No active account on the console!"))
		return
	var/b = balance()
	if(!isnum(b))
		to_chat(user, SPAN_DANGER("No active account on the console!"))
		return
	var/avail = S.available_shares
	var/price = S.current_value
	var/canbuy = round(b / price)
	var/amt = round(input(user, "How many shares? \n(Available: [avail], unit price: [price], can buy: [canbuy])", "Buy shares in [S.name]", 0) as num|null)
	if(!user || (!(user in range(1, src)) && iscarbon(user)))
		return
	if(li != logged_in)
		return
	b = balance()
	if(!isnum(b))
		to_chat(user, SPAN_DANGER("No active account on the console!"))
		return

	amt = min(amt, S.available_shares, round(b / S.current_value))
	if(!amt)
		return
	if(!S.buyShares(logged_in, amt))
		to_chat(user, SPAN_DANGER("Could not complete transaction."))
		return

	var/total = amt * S.current_value
	to_chat(user, SPAN_NOTICE("Bought [amt] shares of [S.name] at [S.current_value] a share for [total] credits."))
	GLOB.stockExchange.add_log(/datum/stock_log/buy, user.name, S.name, amt, S.current_value,  total)

/obj/machinery/computer/stockexchange/proc/do_borrowing_deal(var/datum/borrow/B, var/mob/user)
	if(B.stock.borrow(B, logged_in))
		to_chat(user, SPAN_NOTICE("You successfully borrowed [B.share_amount] shares. Deposit: [B.deposit]."))
		GLOB.stockExchange.add_log(/datum/stock_log/borrow, user.name, B.stock.name, B.share_amount, B.deposit)
	else
		to_chat(user, SPAN_DANGER("Could not complete transaction. Check your account balance."))

/obj/machinery/computer/stockexchange/Topic(href, href_list)
	if(..())
		return TRUE

	if(!usr || (!(usr in range(1, src)) && iscarbon(usr)))
		usr.machine = src

	src.add_fingerprint(usr)
	src.updateUsrDialog()
