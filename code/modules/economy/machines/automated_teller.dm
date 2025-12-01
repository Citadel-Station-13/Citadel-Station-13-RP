//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/automated_teller
	name = "automated teller machine"
	desc = "An ATM linked to an economy network. Simple, right?"
	#warn sprite
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	circuit = /obj/item/circuitboard/atm

	var/terminal_id

	//* config *//
	/// accepted payment types for deposits
	var/conf_deposit_allow_payment_types = PAYMENT_TYPE_COIN | PAYMENT_TYPE_CASH | PAYMENT_TYPE_CHARGE_CARD

	//* state *//

	/// account logged into
	var/datum/economy_account/auth_logged_in_account
	/// id inserted; removing it will de-authorize the current account regardless
	/// of security level.
	var/obj/item/card/id/auth_inserted_id
	/// timerid of logout timer
	var/auth_logout_timerid

	var/auth_fail_current = 0
	var/auth_fail_decay_time = 3 SECONDS
	var/auth_fail_lockout_threshold = 5
	var/auth_fail_lockout_time = 20 SECONDS
	var/auth_fail_lockout = FALSE

	var/sfx_emit_cash = 'sound/items/polaroid1.ogg'
	var/sfx_auth_fail = 'sound/machines/buzz-two.ogg'
	var/sfx_auth_success = 'sound/machines/quiet-beep.ogg'

/obj/machinery/automated_teller/Initialize(mapload)
	. = ..()
	#warn terminal_id

#warn impl

/obj/machinery/automated_teller/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/card))

/obj/machinery/automated_teller/power_change()
	. = ..()
	if(!powered())
		if(auth_inserted_id)
			visible_message(SPAN_WARNING("[src] beeps once as it ejects [auth_inserted_id]."))
			auth_inserted_id.forceMove(drop_location())
			auth_inserted_id = null

/obj/machinery/automated_teller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/automated_teller/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/automated_teller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("logout")
			if(!auth_logged_in_account)
				return TRUE
			log_economy(
				actor,
				"logged out of ATM",
				list(
					"terminal" = terminal_id,
					"pos" = COORD(src),
					"account" = auth_logged_in_account.account_id,
				),
			)
			auth_logged_in_account = null
			return TRUE
		if("withdraw")
			if(!auth_logged_in_account)
				return TRUE
			var/amount = params["amount"]
			var/emit_type = params["type"]
			switch(emit_type)
				if("chargeCard")
				if("cash")
				else
					return TRUE
		if("transfer")
			if(!auth_logged_in_account)
				return TRUE
			var/amount = params["amount"]
			var/target_id = params["id"]
		if("ejectCard")
			if(!auth_inserted_id)
				return TRUE
			log_economy(
				actor,
				"ejected ID from ATM",
				list(
					"terminal" = terminal_id,
					"pos" = COORD(src),
					"id" = "[auth_inserted_id]",
				),
			)
			if(actor.performer.Reachability(src))
				actor.performer.put_in_hands_or_drop(auth_inserted_id)
			else
				auth_inserted_id.forceMove(drop_location())
			auth_inserted_id = null
			auth_logout()
			return TRUE
		if("auth")
			if(auth_logged_in_account)
				return TRUE
			var/account_id = params["id"]
			var/account_pin = params["pin"]
		if("changeSecurityLevel")
			if(!auth_logged_in_account)
				return TRUE
			var/desired = params["level"]
			switch(desired)
				if(ECONOMY_SECURITY_LEVEL_MULTIFACTOR)
				if(ECONOMY_SECURITY_LEVEL_PASSWORD)
				if(ECONOMY_SECURITY_LEVEL_RELAXED)
				else
					return TRUE
		if("printBalance")
			if(!auth_logged_in_account)
				return TRUE
			var/obj/item/paper/printed = print_account_balance()
		if("printTransactions")
			if(!auth_logged_in_account)
				return TRUE
			var/obj/item/paper/printed = print_account_statement()

/obj/machinery/automated_teller/proc/spawn_cash(amount, mob/put_in_hands) as /obj/item/spacecash
	var/obj/item/spacecash/created = new(put_in_hands, amount)
	if(put_in_hands)
		put_in_hands.put_in_hands_or_drop(created)
	else
		created.forceMove(drop_location())
	return created

/obj/machinery/automated_teller/proc/spawn_charge_card(amount, mob/put_in_hands) as /obj/item/charge_card
	var/obj/item/charge_card/created = new(put_in_hands, amount)
	if(put_in_hands)
		put_in_hands.put_in_hands_or_drop(created)
	else
		created.forceMove(drop_location())
	return created

/obj/machinery/automated_teller/ui_status(mob/user, datum/ui_state/state)
	// TODO: don't entirely forbid silicons, let them touch if adjacent? or maybe with a hack?
	if(issilicon(user))
		return UI_UPDATE
	return ..()

/obj/machinery/automated_teller/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ATM")
		ui.open()

/obj/machinery/automated_teller/proc/print_account_balance(datum/economy_account/account) as /obj/item/paper
	var/obj/item/paper/created = new
	var/name_append = account.fluff_owner_name ? "- [account.fluff_owner_name]" : ""
	created.name = "Account Balance[name_append]"

	var/list/info = list()
	#warn impl
	created.info = info

	// TODO: generalize / refactor this
	var/image/stamp_overlay = image('icons/obj/bureaucracy.dmi', "paper_stamp-cent")
	created.stamped = list(
		/obj/item/stamp,
	)
	created.add_overlay(stamp_overlay)
	created.stamps = "<hr><i>This paper has been stamped by the Automated Teller Machine.</i>"
	return created

/obj/machinery/automated_teller/proc/print_account_statement(datum/economy_account/account) as /obj/item/paper
	var/obj/item/paper/created = new
	var/name_append = account.fluff_owner_name ? "- [account.fluff_owner_name]" : ""
	created.name = "Account Statement[name_append]"

	var/list/info = list()
	#warn impl
	info += account.print_html_account_transactions()
	created.info = info

	// TODO: generalize / refactor this
	var/image/stamp_overlay = image('icons/obj/bureaucracy.dmi', "paper_stamp-cent")
	created.stamped = list(
		/obj/item/stamp,
	)
	created.add_overlay(stamp_overlay)
	created.stamps = "<hr><i>This paper has been stamped by the Automated Teller Machine.</i>"
	return created

/obj/machinery/automated_teller/proc/has_any_auth_activity()
	. = FALSE
	for(var/datum/tgui/tgui in open_uis)
		if(tgui.status <= UI_UPDATE)
			continue
		// interactive ones are considered activity
		return TRUE

/obj/machinery/automated_teller/proc/reconsider_auth_logout_timer()
	var/has_any_activity = has_any_auth_activity()

/obj/machinery/automated_teller/proc/timer_logout()
	if(!auth_logged_in_account)
		return
	auth_logout()
	#warn yell

/obj/machinery/automated_teller/proc/auth_login(datum/economy_account/account, datum/event_args/actor/actor)
	if(auth_logged_in_account)
		if(auth_logged_in_account == account)
			return
		auth_logout()
	auth_logged_in_account = account

/obj/machinery/automated_teller/proc/auth_fail(datum/economy_account/account, datum/event_args/actor/actor)

/obj/machinery/automated_teller/proc/auth_logout()
	auth_logged_in_account = null

#warn impl

// TODO: readd emagging / similar
