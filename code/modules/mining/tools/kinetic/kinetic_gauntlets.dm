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

	/// our combo tracker
	var/datum/combo_tracker/melee/combo_tracker
	/// only reapplied on un-equip/re-equip right now!
	var/combo_continuation_timeout = 3 SECONDS
	/// our combo is active; we won't go onto clickdelay until it falls off
	var/combo_continuation_active = FALSE

/obj/item/kinetic_gauntlets/update_icon()
	cut_overlays()
	. = ..()
	icon_state = "[base_icon_state]"
	worn_state = "[base_icon_state][charged ? "" : "-empty"]"
	if(!charged)
		add_overlay("[base_icon_state]-empty")
	update_worn_icon()

/obj/item/kinetic_gauntlets/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, flags)
	if(slot != /datum/inventory_slot/inventory/gloves::id)
		return ..()
	if(istype(I, /obj/item/clothing/gloves/gauntlets))
		return ..()
	return TRUE

/obj/item/kinetic_gauntlets/examine_query_usage_hints(datum/event_args/examine/examining)
	. = ..()
	. += "Punching a rock wall on <b>harm intent</b>, while charged, will try to mine it with the gauntlets."
	. += "Punching a mob on <b>harm intent</b>, while charged, will apply additional damage and stagger it."
	. += "Punching a mob with a kinetic destabilization field on <b>harm intent</b>, while charged, will detonate the field."

/obj/item/kinetic_gauntlets/examine_query_stat_hints(datum/event_args/examine/examining)
	. = ..()
	.["Charge Delay (Base)"] = charge_delay

/obj/item/kinetic_gauntlets/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	.["toggle-fingerless"] = create_context_menu_tuple("Toggle Finger Caps", image(src), null, MOBILITY_CAN_USE, FALSE)

/obj/item/kinetic_gauntlets/context_menu_act(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return

/obj/item/kinetic_gauntlets/on_equipped(mob/wearer, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	. = ..()
	if(slot_id_or_index == /datum/inventory_slot/inventory/gloves::id)
		start_recharge()
		if(!combo_tracker)
			combo_tracker = new(combo_continuation_timeout)
			combo_tracker.on_continuation_begin = CALLBACK(src, PROC_REF(on_continuation_begin))
			combo_tracker.on_continuation_end = CALLBACK(src, PROC_REF(on_continuation_end))

/obj/item/kinetic_gauntlets/on_unequipped(mob/wearer, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	. = ..()
	discharge()
	QDEL_NULL(combo_tracker)

/obj/item/kinetic_gauntlets/proc/on_continuation_begin()
	SHOULD_NOT_SLEEP(TRUE)
	combo_continuation_active = TRUE

/obj/item/kinetic_gauntlets/proc/on_continuation_end(list/stored_keys, timed_out)
	SHOULD_NOT_SLEEP(TRUE)
	discharge()
	combo_continuation_active = FALSE

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
