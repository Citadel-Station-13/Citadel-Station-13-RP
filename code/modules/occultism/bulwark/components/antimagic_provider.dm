//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Antimagic component.
 * Usable on most things.
 */
/datum/component/antimagic_provider
	registered_type = /datum/component/antimagic_provider

	/// antimagic datum; set to path to get cached copy
	var/datum/antimagic/antimagic = /datum/antimagic

	/// apply to ourselves
	var/apply_self = TRUE
	/// apply when worn
	var/apply_worn = FALSE
	/// apply when held
	var/apply_held = FALSE

	/// called by coverage on invoking
	var/datum/callback/on_invoke
	/// our own callback
	var/datum/callback/on_invoke_internal

/datum/component/antimagic_provider/Initialize(datum/antimagic/antimagic, datum/callback/on_invoke)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isnull(antimagic))
		src.antimagic = antimagic
	if(!isnull(on_invoke))
		src.on_invoke = on_invoke
	if(ispath(src.antimagic))
		src.antimagic = fetch_antimagic_struct(src.antimagic)
	else if(IS_ANONYMOUS_TYPEPATH(src.antimagic))
		src.antimagic = new src.antimagic
	else if(!istype(src.antimagic))
		stack_trace("invalid antimagic datum")
	on_invoke_internal = CALLBACK(src, PROC_REF(on_antimagic))

/datum/component/antimagic_provider/Destroy()
	on_invoke = null
	on_invoke_internal = null
	antimagic = null
	return ..()

/datum/component/antimagic_provider/RegisterWithParent()
	..()
	if(apply_self)
		var/atom/casted_parent = parent
		var/datum/component/antimagic_coverage/coverage = casted_parent.antimagic_fetch_or_init_coverage()
		coverage.add_source(antimagic, on_invoke)
	if(apply_worn || apply_held)
		if(isitem(parent))
			var/obj/item/casted_item = parent
			RegisterSignal(casted_item, COMSIG_ITEM_ON_INV_EQUIP, PROC_REF(on_equip))
			RegisterSignal(casted_item, COMSIG_ITEM_ON_INV_UNEQUIP, PROC_REF(on_unequip))
			if(casted_item.inv_inside)
				if(isnum(casted_item.inv_slot_or_index))
					if(apply_held)
						apply_to_equipper(casted_item.inv_inside.owner)
				else
					if(apply_worn)
						apply_to_equipper(casted_item.inv_inside.owner)

/datum/component/antimagic_provider/UnregisterFromParent()
	..()
	var/atom/casted_parent = parent
	var/datum/component/antimagic_coverage/coverage = casted_parent.antimagic_fetch_or_init_coverage()
	coverage.remove_source(antimagic)
	if(isitem(parent))
		var/obj/item/casted_item = parent
		UnregisterSignal(casted_item, list(
			COMSIG_ITEM_ON_INV_EQUIP,
			COMSIG_ITEM_ON_INV_UNEQUIP,
		))
		if(casted_item.inv_inside)
			remove_from_equipper(casted_item.inv_inside.owner)

/datum/component/antimagic_provider/proc/on_equip(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	SIGNAL_HANDLER
	if(isnum(slot_id_or_index))
		if(apply_held)
			apply_to_equipper(wearer)
	else
		if(apply_worn)
			apply_to_equipper(wearer)

/datum/component/antimagic_provider/proc/on_unequip(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	SIGNAL_HANDLER
	remove_from_equipper(wearer)

/datum/component/antimagic_provider/proc/check_equip_slot(slot_or_index)
	return isnum(slot_or_index) ? apply_held : apply_worn

/datum/component/antimagic_provider/proc/apply_to_equipper(mob/wearer)
	var/datum/component/antimagic_coverage/coverage = wearer.antimagic_fetch_or_init_coverage()
	coverage.add_source(antimagic, on_invoke_internal)

/datum/component/antimagic_provider/proc/remove_from_equipper(mob/wearer)
	var/datum/component/antimagic_coverage/coverage = wearer.antimagic_fetch_or_init_coverage()
	coverage.remove_source(antimagic)

/**
 * Bounces the callback used on coverage component to the real callback so that the real callback
 * can be varedited.
 */
/datum/component/antimagic_provider/proc/on_antimagic(...)
	return on_invoke ? on_invoke.Invoke(arglist(args)) : null

/datum/component/antimagic_provider/held_only
	apply_held = TRUE

/datum/component/antimagic_provider/worn_only
	apply_worn = TRUE

/datum/component/antimagic_provider/anywhere
	apply_worn = TRUE
	apply_held = TRUE
