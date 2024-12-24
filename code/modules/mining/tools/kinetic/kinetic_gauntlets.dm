//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/kinetic_gauntlets
	name = "proto-kinetic gauntlets"
	icon = 'icons/modules/mining/tools/kinetic/kinetic_gauntlets.dmi'
	icon_state = "normal"
	base_icon_state = "normal"

	w_class = WEIGHT_CLASS_NORMAL
	weight_volume = WEIGHT_VOLUME_SMALL
	slot_flags = SLOT_GLOVES

	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

	var/charged = FALSE
	var/charge_delay = 3 SECONDS
	var/charge_timerid

/obj/item/kinetic_gauntlets/update_icon()
	cut_overlays()
	. = ..()
	icon_state = "[base_icon_state]"
	worn_state = "[base_icon_state][charged ? "" : "-empty"]"
	if(!charged)
		add_overlay("[base_icon_state]-empty")
	update_worn_icon()

/obj/item/kinetic_gauntlets/context_menu_query(datum/event_args/actor/e_args)

/obj/item/kinetic_gauntlets/context_menu_query(datum/event_args/actor/e_args)
	. = ..()

/obj/item/kinetic_gauntlets/context_menu_act(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return

/obj/item/kinetic_gauntlets/equipped(mob/user, slot, flags)
	. = ..()
	#warn bugfix branch changes this
	start_recharge()

/obj/item/kinetic_gauntlets/unequipped(mob/user, slot, flags)
	. = ..()
	#warn bugfix branch changes this
	discharge()

/obj/item/kinetic_gauntlets/proc/recharge()
	charged = TRUE
	charge_timerid = null
	update_icon()

/**
 * Aborts charge cycle if it exists, and starts a new one.
 */
/obj/item/kinetic_gauntlets/proc/discharge(recharge_acceleration_multiplier = 1)
	charged = FALSE
	cancel_recharge()
	start_recharge(recharge_acceleration_multiplier)
	update_icon()

/**
 * Cancels recharge.
 */
/obj/item/kinetic_gauntlets/proc/cancel_recharge()
	if(charge_timerid)
		deltimer(charge_timerid)
		charge_timerid = null

/**
 * Will speed up current recharge cycle to be as fast as the requested
 * speed if it's not at least that fast.
 */
/obj/item/kinetic_gauntlets/proc/start_recharge(acceleration_multiplier = 1)
	if(worn_slot != /datum/inventory_slot/inventory/gloves::id)
		cancel_recharge()
		return

#warn impl all
