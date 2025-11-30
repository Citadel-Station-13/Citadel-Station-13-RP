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
	var/datum/economy_account/logged_in_account
	/// number of incorrect PIN tries

/obj/machinery/automated_teller/Initialize(mapload)
	. = ..()
	#warn terminal_id

#warn impl

/obj/machinery/automated_teller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/automated_teller/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/automated_teller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

/obj/machinery/automated_teller/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/machinery/automated_teller/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()

