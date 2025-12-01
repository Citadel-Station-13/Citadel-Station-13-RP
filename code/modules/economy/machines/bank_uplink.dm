//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: prime candidate (along with id card modification console)
//       for new experimental modular computer API with static console support
/obj/machinery/computer/bank_uplink
	name = "banking uplink terminal"
	desc = "A terminal with an uplink to the banking system. This is used to access transaction logs and accout data."
	#warn sprite

	/// our uplink terminal
	var/terminal_id
	/// inserted auth ID
	var/obj/item/card/id/inserted_id

	/// last time we printed a report
	var/last_report_print
	/// report print cooldown
	var/report_print_cooldown = 3 SECONDS

/obj/machinery/computer/bank_uplink/Initialize(mapload)
	#warn terminal id; generate but also get it from circuit?
	return ..()

/obj/machinery/computer/bank_uplink/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/card))

/obj/machinery/computer/bank_uplink/proc/get_accessible_factions() as /list
	RETURN_TYPE(/list)
	. = list()
	var/datum/economy_faction/sorry_unimplemented = SSeconomy.resolve_faction(/datum/world_faction/core/station::id)
	if(sorry_unimplemented)
		. += sorry_unimplemented

/obj/machinery/computer/bank_uplink/proc/can_access_faction(datum/economy_faction/faction)
	return faction.id == /datum/world_faction/core/station::id

/obj/machinery/computer/bank_uplink/proc/can_access_account(datum/economy_account/account)
	RETURN_TYPE(/list)

	var/datum/economy_faction/maybe_faction = account.faction_id ? SSeconomy.resolve_faction(account.faction_id) : null
	if(maybe_faction && !can_access_faction(maybe_faction))
		return FALSE
	return TRUE

#warn do we need more granular access for departments?

/obj/machinery/computer/bank_uplink/proc/get_accessible_accounts(datum/economy_faction/faction) as /list
	return faction.uplink_get_managed_accounts()

/obj/machinery/computer/bank_uplink/proc/get_accessible_source_accounts(datum/economy_faction/faction) as /list
	return faction.uplink_get_managed_source_accounts()

/obj/machinery/computer/bank_uplink/proc/get_effective_root_account(datum/economy_faction/faction) as /datum/economy_account
	return faction.uplink_get_effective_root_account()

/obj/machinery/computer/bank_uplink/proc/get_authorizing_name()
	if(!inserted_id)
		return "-- unknown auth (bug?) --"
	return "[inserted_id.registered_name] ([inserted_id.rank])"

/obj/machinery/computer/bank_uplink/power_change()
	. = ..()
	if(!powered())
		if(inserted_id)
			visible_message(SPAN_WARNING("[src] beeps once as it ejects [inserted_id]."))
			inserted_id.forceMove(drop_location())
			inserted_id = null

/obj/machinery/computer/bank_uplink/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/BankUplinkConsole.tsx")
		ui.open()

/obj/machinery/computer/bank_uplink/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	// many common operations will have a target account id; we auth it right now
	// this is not vulnerable to href / tgui modification as if it's not present
	// the operations will simply fail
	var/raw_target_account_id = params["targetAccountId"]
	var/datum/economy_account/validated_target_account
	if(raw_target_account_id)
		var/datum/economy_account/maybe_account = SSeconomy.resolve_account(raw_target_account_id)
		if(can_access_account(maybe_account))
			validated_target_account = maybe_account

	switch(action)
		if("createAccount")
			var/create_owner_name = params["createOwnerName"]
			var/create_fund_account = params["createFundSource"]
			var/create_fund_amount = params["createFundAmount"]
			var/create_target_faction = params["createTargetFaction"]

			#warn sanitize create owner name

			if(!is_safe_number(create_fund_amount) || create_fund_amount < 0)
				return TRUE

			// resolve target faction
			var/datum/economy_faction/resolve_target_faction = SSeconomy.resolve_faction(create_target_faction)
			if(!can_access_faction(resolve_target_faction))
				return TRUE
			// resolve fund source account if it's being funded
			var/datum/economy_account/resolve_fund_source_account
			if(create_fund_amount)
				resolve_fund_source_account = SSeconomy.resolve_account(create_fund_account)
				if(!create_fund_account || !can_access_account(resolve_fund_source_account))
					// this means they can't access the account anymore
					ui_push_faction_accounts(resolve_target_faction)
					return TRUE
				if(resolve_fund_source_account.balance < create_fund_amount)
					// this means the account is out of funds
					ui_push_account_details(resolve_fund_source_account)
					return TRUE
			// create account
			var/datum/economy_account/created_account = SSeconomy.allocate_account(resolve_target_faction)
			created_account.owner_name = create_owner_name
			created_account.randomize_credentials()
			// log & fund (if necessary) the account
			var/datum/economy_transaction/initial_funding_transaction = new(resolve_fund_source_account ? create_fund_amount : 0)
			if(resolve_fund_source_account)
				initial_funding_transaction.audit_peer_name_as_unsafe_html = resolve_fund_source_account.owner_name
			initial_funding_transaction.audit_purpose_as_unsafe_html = "Initial account creation (authorization by [get_authorizing_name()])"
			initial_funding_transaction.audit_terminal_as_unsafe_html = "#[terminal_id]"
			if(resolve_fund_source_account)
				initial_funding_transaction.execute_transfer_transaction(resolve_fund_source_account, created_account)
			else
				initial_funding_transaction.execute_system_transaction(created_account)
			// print packet
			wrap_report(
				print_account_creation(created_account),
				drop_location(),
			)
			return TRUE
		if("pullAccountDetails")
			ui_push_account_details(validated_target_account)
			return TRUE
		if("ejectCard")
			#warn impl
		if("insertCard")
			if(inserted_id)
				return TRUE
			var/obj/item/card/id/maybe_held_id = actor.performer.get_active_held_item()
			if(!istype(maybe_held_id))
				return TRUE
			#warn impl
			return TRUE
		if("fundAccount", "drainAccount")
			var/source_account_id = params["source"]
			var/transact_amount = params["amount"]
			var/transact_reason = params["reason"]
			#warn impl
		if("deleteAccount")
			#warn impl
		if("suspendAccount")
			if(!validated_target_account)
				return TRUE
			var/target_state = params["value"]
			validated_target_account.set_security_lock(target_state)
			#warn audit log
			ui_push_account_details(validated_target_account)
			return TRUE
		if("printAccountStatus")
			if(!try_invoke_print_cooldown())
				return TRUE
			if(!validated_target_account)
				return TRUE
			visible_message(SPAN_NOTICE("[src] spits out a small report. How neat."))
			print_account_status(validated_target_account, drop_location())
			return TRUE
		if("printAccountAudit")
			if(!try_invoke_print_cooldown())
				return TRUE
			if(!validated_target_account)
				return TRUE
			visible_message(SPAN_NOTICE("[src] spits out a small, securely packaged report. How neat."))
			wrap_report(
				print_account_audit(validated_target_account),
				drop_location(),
			)
			return TRUE
		if("printAccountAccess")
			if(!try_invoke_print_cooldown())
				return TRUE
			if(!validated_target_account)
				return TRUE
			visible_message(SPAN_NOTICE("[src] spits out a small, securely packaged report. How neat."))
			wrap_report(
				print_account_access(validated_target_account),
				drop_location(),
			)
			return TRUE

/obj/machinery/computer/bank_uplink/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	// our UI is an arbitrary key-value system
	// accounts are pushed as 'acct-[id]', flat
	// factions are pushed as 'fact-[id]', flat

	.["terminalId"] = terminal_id

/obj/machinery/computer/bank_uplink/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["authId"] = list(
		#warn auth id
	)
	.["printCooldown"] = last_report_print + report_print_cooldown > world.time

/obj/machinery/computer/bank_uplink/proc/ui_push_account_details(datum/economy_account/account)
	push_ui_modules(updates = list(
		"acct-[account.account_id]" = list(
			"id" = account.account_id,
			"balance" = account.balance,
			"ephemeral" = account.audit_ephemeral_balance_accumulator,
			"owner" = account.fluff_owner_name,
			"securityLevel" = account.security_level,
			"securityLock" = account.security_lock,
		),
	))

/obj/machinery/computer/bank_uplink/proc/ui_push_account_logs(datum/economy_account/account, page = 1)
	push_ui_modules(updates = list(
		"acct-log-[account.account_id]" = account.ui_audit_logs(page, 10),
		"acct-log-page" = page,
	))

/obj/machinery/computer/bank_uplink/proc/ui_push_faction_accounts(datum/economy_faction/faction)

#warn FUCK

/obj/machinery/computer/bank_uplink/proc/try_invoke_print_cooldown()
	if(last_report_print + report_print_cooldown > world.time)
		return FALSE
	last_report_print = world.time
	return TRUE

// todo: better printing, document datums, don't make custom strings every time
/**
 * @return printed report
 */
/obj/machinery/computer/bank_uplink/proc/print_account_status(datum/economy_account/account, atom/put_report_at)
	var/obj/item/paper/printing_paper = new /obj/item/paper(put_report_at)
	var/name_append = account.fluff_owner_name ? "- [account.fluff_owner_name]" : ""
	printing_paper.name = "Account Status[name_append]"

	var/list/info = list()
	info += account.print_html_account_identity()
	info += account.print_html_account_balance()
	#warn impl
	printing_paper.info = info

	stamp_report(printing_paper)

// todo: better printing, document datums, don't make custom strings every time
/**
 * @return printed report
 */
/obj/machinery/computer/bank_uplink/proc/print_account_audit(datum/economy_account/account, atom/put_report_at)
	var/obj/item/paper/printing_paper = new /obj/item/paper(put_report_at)
	var/name_append = account.fluff_owner_name ? "- [account.fluff_owner_name]" : ""
	printing_paper.name = "Account Audit[name_append]"

	var/list/info = list()
	info += account.print_html_account_identity()
	info += account.print_html_account_balance()
	#warn impl
	info += account.print_html_account_transactions()
	printing_paper.info = info

	stamp_report(printing_paper)

// todo: better printing, document datums, don't make custom strings every time
/**
 * @return printed report
 */
/obj/machinery/computer/bank_uplink/proc/print_account_access(datum/economy_account/account, atom/put_report_at)
	var/obj/item/paper/printing_paper = new /obj/item/paper(put_report_at)
	var/name_append = account.fluff_owner_name ? "- [account.fluff_owner_name]" : ""
	printing_paper.name = "Account Credentials[name_append]"

	#warn impl
	stamp_report(printing_paper)

// todo: better printing, document datums, don't make custom strings every time
/**
 * @return printed report
 */
/obj/machinery/computer/bank_uplink/proc/print_account_creation(datum/economy_account/account, atom/put_report_at)
	var/obj/item/paper/printing_paper = new /obj/item/paper(put_report_at)
	var/name_append = account.fluff_owner_name ? "- [account.fluff_owner_name]" : ""
	printing_paper.name = "Account Information[name_append]"
	var/list/info = list()
	info += "<h1><center>Account Details (Confidential)</center></h1><hr>"
	info += account.print_html_account_identity()
	info += account.print_html_account_authorization()
	info += {"
		<i>Starting balance:</i> $[account.balance]<br>
		<i>Date / Time:</i> [SSeconomy.timestamp_now()]<br>
		<i>Creation uplink ID:</i> #[terminal_id]<br>
		<i>Authorizing individual:</i> [get_authorizing_name()]<br>
	"}
	printing_paper.info = info
	stamp_report(printing_paper)

/obj/machinery/computer/bank_uplink/proc/stamp_report(obj/item/paper/report)
	// todo: rework stamps
	var/image/stamp_overlay = image('icons/obj/bureaucracy.dmi', "paper_stamp-cent")
	LAZYINITLIST(report.stamped)
	report.stamped += /obj/item/stamp
	report.stamps += "<hr><i>This paper has been stamped by the Accounts Database - #[terminal_id]</i>"
	report.add_overlay(stamp_overlay)

/obj/machinery/computer/bank_uplink/proc/wrap_report(obj/item/paper/report, atom/place_at)
	var/obj/item/smallDelivery/package = new /obj/item/smallDelivery(place_at)
	report.forceMove(package)
	return package
