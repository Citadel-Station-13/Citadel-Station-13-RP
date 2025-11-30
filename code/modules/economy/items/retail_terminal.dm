//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/retail_terminal_entry
	var/name
	var/amount
	var/units
	var/cost_per

/**
 * Combined utility item for both accepting payments and scanning retail items.
 *
 * This used to be separate EFTPOS and retail scanners but there was too much duplicate code,
 * so it's all one item now.
 */
/obj/item/retail_terminal
	name = "\improper EFTPOS Terminal"
	desc = "A portable terminal used to make purchases. Supports scanning products as well as accepting \
	inputs for custom payment amounts."
	#warn sprite

	//* terminal *//

	/// assigned by SSeconomy
	var/terminal_id

	//* security *//

	/// are we locked in any way (whether for purchase or otherwise)
	var/locked = FALSE
	/// PIN set, if any; if this is null, we are inoperable as a pin must be set first.
	var/access_pin
	/// allow state reset through interface
	/// * if disabled, you must implement your own way to break into this device.
	var/access_pin_allow_reset = TRUE

	//* state - wiped on reset *//

	/// account ID to pay into
	var/state_seller_account_id

	/// stated current transaction purpose
	/// * required for transaction to process
	var/state_transaction_purpose
	/// Scanned items, weakrefs to entries
	var/list/state_transaction_scanned_by_weakref
	/// Scanned items, custom string-key to entries
	var/list/state_transaction_scanned_by_key
	/// Additional entries for charges, flat entry list
	var/list/datum/retail_terminal_entry/state_transaction_custom_entries

	/// retail scanner mode enabled
	var/state_retail_mode = FALSE

	/// purchase is pending
	/// * [locked] should be set too
	var/state_purchase_pending = FALSE
	/// purchase was successfully finished
	var/state_purchase_completed = FALSE

	var/sfx_transaction_success 'sound/machines/chime.ogg'

/obj/item/retail_terminal/Initialize(mapload)
	. = ..()
	#warn get terminal id, bind to account if needed

#warn impl all

/obj/item/retail_terminal/using_as_item(atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(.)
		return
	if(state_retail_mode)
		// scanner mode
		scan_entity(target, e_args)
		return CLICKCHAIN_DID_SOMETHING

/obj/item/retail_terminal/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(.)
		return
	if(state_retail_mode)
		// scanner mode
		scan_entity(using, e_args)
		return CLICKCHAIN_DID_SOMETHING
	else if(state_purchase_pending)
		// purchase mode
		#warn impl

/obj/item/retail_terminal/proc/scan_entity(atom/movable/entity, datum/event_args/actor/actor, silent)
	if(!istype(entity))
		return FALSE
	#warn impl

	return TRUE

/obj/item/retail_terminal/proc/purchase_via_payment(obj/item/payment, datum/event_args/actor/actor, silent)
	#warn impl

/obj/item/retail_terminal/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["accessPinAllowReset"] = access_pin_allow_reset
	var/list/scanned_by_entity = list()
	for(var/id in state_transaction_scanned_by_weakref)
		var/datum/retail_terminal_entry/entry = state_transaction_scanned_by_weakref[id]
		#warn impl
	.["scannedEntityEntries"] = scanned_by_entity
	var/list/scanned_by_key = list()
	for(var/id in state_transaction_scanned_by_key)
		var/datum/retail_terminal_entry/entry = state_transaction_scanned_by_key[id]
		#warn impl
	.["scannedKeyedEntries"] = scanned_by_key
	var/list/custom_entries = list()
	for(var/datum/retail_terminal_entry/entry as anything in state_transaction_custom_entries)
		#warn impl
	.["customEntries"] = custom_entries

/obj/item/retail_terminal/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["locked"] = locked
	.["terminalId"] = terminal_id
	.["sellerAccountId"] = state_seller_account_id
	.["transactionPurpose"] = state_transaction_purpose
	.["scannerActive"] = state_retail_mode
	.["purchasePending"] = state_purchase_pending
	.["purchaseComplete"] = state_purchase_completed

/obj/item/retail_terminal/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "items/RetaiTerminal.tsx")
		ui.open()

/obj/item/retail_terminal/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("lock")
			if(locked)
				return TRUE
			if(!access_pin)
				return TRUE
			locked = TRUE
			return TRUE
		if("unlock")
			if(!locked)
				return TRUE
			var/pin = params["pin"]
			if(pin != access_pin)
				return TRUE
			locked = FALSE
			return TRUE
		if("resetPin")
			if(!access_pin_allow_reset)
				return TRUE
			#warn impl, reset state
			return TRUE
		if("setTransactionPurpose")
			var/purpose = params["purpose"]
		if("toggleScanner")
			var/state = params["on"]
		if("deleteCustomEntry")
			var/index = params["index"]
		if("addCustomEntry")
			var/replaceIndex = params["index"]
			var/name = params["name"]
			var/amount = params["amount"]
			var/cost_per = params["costPer"]
		if("deleteScannedEntity")
			var/weakref_ref = params["weakrefRef"]
		if("deleteKeyedEntity")
			var/key = params["key"]
		if("modifyKeyedEntity")
			var/key = params["key"]
			var/amount = params["amount"]
			var/cost_per = params["costPer"]
		if("scanSellerAccount")
		if("setSellerAccount")
			var/account_id = params["accountId"]
		if("beginPurchase")
		if("resetState")
		if("factoryReset")

#warn always face user when put on a table

// todo: allow unanchor
/obj/item/retail_terminal/cash_register
	name = "\improper EFTPOS Register"
	desc = "A not-so-portable terminal used to make purchases. Now with cash storage."
	#warn sprite

	anchored = TRUE

	//* storage *//

	/// register opened?
	var/cash_open = FALSE
	/// amount of Thaler stored
	var/cash_stored = 0

/obj/item/retail_terminal/cash_register/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("Alt-click while adjacent to access the cash register.")

/obj/item/retail_terminal/cash_register/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	if(cash_open)
		.["close-register"] = create_context_menu_tuple("close register", src, 1, MOBILITY_CAN_USE, TRUE)
	else
		.["open-register"] = create_context_menu_tuple("open register", src, 1, MOBILITY_CAN_USE, TRUE)

/obj/item/retail_terminal/cash_register/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("open-register")
		if("close-register")

/obj/item/retail_terminal/cash_register/proc/can_access_cash_drawer_from(turf/tile)
	return tile == loc || get_dir(src, tile) == dir

#warn impl all
