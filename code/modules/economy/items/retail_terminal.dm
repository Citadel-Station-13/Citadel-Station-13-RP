//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

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
	/// stated current transaction amount
	/// * this is in additional to any scanned items
	var/state_transaction_amount

	/// retail scanner mode enabled
	var/state_retail_mode = FALSE

	/// purchase is pending
	/// * [locked] should be set too
	var/state_purchase_pending = FALSE
	/// purchase was successfully finished
	var/state_purchase_completed = FALSE

/obj/item/retail_terminal/Initialize(mapload)
	. = ..()
	#warn get terminal id, bind to account if needed

#warn impl all

/obj/item/retail_terminal/using_as_item(atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()

/obj/item/retail_terminal/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()

/obj/item/retail_terminal/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/item/retail_terminal/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/item/retail_terminal/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)

/obj/item/retail_terminal/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

#warn always face user when put on a table

/obj/item/retail_terminal/cash_register
	name = "\improper EFTPOS Register"
	desc = "A not-so-portable terminal used to make purchases. Now with cash storage."
	#warn sprite

	access_pin_allow_reset = FALSE

	//* storage *//

	/// amount of Thaler stored
	var/cash_stored = 0

#warn impl all
