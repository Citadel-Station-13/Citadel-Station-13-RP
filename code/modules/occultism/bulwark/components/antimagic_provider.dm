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
	#warn resolve antimagic

/datum/component/antimagic_provider/Destroy()
	on_invoke = null
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
			RegisterSignal(casted_item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
			RegisterSignal(casted_item, COMSIG_ITEM_UNEQUIPPED, PROC_REF(on_unequip))
	#warn finish

/datum/component/antimagic_provider/UnregisterFromParent()
	..()
	if(isitem(parent))
		UnregisterSignal(parent, list(
			COMSIG_ITEM_UNEQUIPPED,
			COMSIG_ITEM_EQUIPPED,
		))
	var/atom/casted_parent = parent
	var/datum/component/antimagic_coverage/coverage = casted_parent.antimagic_fetch_or_init_coverage()
	coverage.remove_source(antimagic)

/datum/component/antimagic_provider/proc/on_equip()
	#warn impl

/datum/component/antimagic_provider/proc/on_unequip()
	#warn impl

/datum/component/antimagic_provider/proc/check_equip_slot(slot_or_index)
	return isnum(slot_or_index) ? apply_held : apply_worn

/datum/component/antimagic_provider/proc/apply_to_equipper(mob/wearer)
	var/datum/component/antimagic_coverage/coverage = wearer.antimagic_fetch_or_init_coverage()
	coverage.add_source(antimagic, on_invoke)

/datum/component/antimagic_provider/proc/remove_from_equipper(mob/wearer)
	var/datum/component/antimagic_coverage/coverage = wearer.antimagic_fetch_or_init_coverage()
	coverage.remove_source(antimagic)

/datum/component/antimagic_provider/held_only
	apply_held = TRUE

/datum/component/antimagic_provider/worn_only
	apply_worn = TRUE

/datum/component/antimagic_provider/anywhere
	apply_worn = TRUE
	apply_held = TRUE
