//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Microbattery ballistics.
 *
 * * Technically, any ballistic weapon can fire microbattery ammo. It's the same backend.
 *   All it needs is to be compatible with the casing priming.
 * * That said, this type has semantics like mode switches.
 *
 * Caveats:
 *
 * * You can set `magazine_restrict` to a non-microbattery path,
 *   but only microbattery magazines support cycling.
 * * Default firemode swap will be bound to cycling the magazine if there's only one firemode.
 *   If there's more than one, it'll be bound to firemode. You'll have to use the action button
 *   in that case.
 */
/obj/item/gun/projectile/ballistic/microbattery
	recoil = 0
	magazine_restrict = /obj/item/ammo_magazine/microbattery
	chamber_simulation = FALSE

	/**
	 * Microbattery swap action. Lazy-init'd.
	 */
	var/datum/action/item_action/gun_microbattery_swap/microbattery_swap_action

	var/tmp/cached_group_key
	var/tmp/cached_group_capacity
	var/tmp/cached_group_remaining
	var/tmp/cached_group_color

/obj/item/gun/projectile/ballistic/microbattery/Initialize(mapload)
	if(internal_magazine_revolver_mode)
		stack_trace("revolver-mode internal magazine is not supported on microbattery guns.")
		internal_magazine_revolver_mode = FALSE
	return ..()

/obj/item/gun/projectile/ballistic/microbattery/get_ammo_ratio(rounded)
	if(!cached_group_remaining)
		return 0
	return cached_group_remaining / cached_group_capacity

/obj/item/gun/projectile/ballistic/microbattery/get_ammo_remaining()
	return cached_group_remaining

/obj/item/gun/projectile/ballistic/microbattery/get_firemode_color()
	return cached_group_color

/obj/item/gun/projectile/ballistic/microbattery/insert_magazine(obj/item/ammo_magazine/magazine, silent)
	. = ..()
	if(!.)
		return
	scan_microbattery_group()
	update_icon()

/obj/item/gun/projectile/ballistic/microbattery/remove_magazine(atom/new_loc, silent, auto_eject)
	. = ..()
	if(!.)
		return
	scan_microbattery_group()
	update_icon()

/obj/item/gun/projectile/ballistic/microbattery/insert_casing(obj/item/ammo_casing/casing, silent, reverse_order)
	. = ..()
	if(!.)
		return
	scan_microbattery_group()
	update_icon()

/obj/item/gun/projectile/ballistic/microbattery/remove_casing(atom/new_loc, silent, reverse_order)
	. = ..()
	if(!.)
		return
	scan_microbattery_group()
	update_icon()

// todo: i'm crying please refactor internal magazines and chamber handling
/obj/item/gun/projectile/ballistic/microbattery/really_snowflake_chamber_ejection_check(obj/item/ammo_casing/casing, from_fire)
	return (!from_fire || !istype(get_chambered(), /obj/item/ammo_casing/microbattery)) && ..()

/obj/item/gun/projectile/ballistic/microbattery/ready_chambered()
	var/obj/item/ammo_casing/microbattery/maybe_top_microbattery
	if(internal_magazine)
		if(length(internal_magazine_vec))
			maybe_top_microbattery = internal_magazine_vec[length(internal_magazine_vec)]
	else
		maybe_top_microbattery = magazine?.peek()
	if(maybe_top_microbattery && !maybe_top_microbattery.is_loaded())
		advance_within_microbattery_group()
	return ..()

/obj/item/gun/projectile/ballistic/microbattery/prime_casing(datum/gun_firing_cycle/cycle, obj/item/ammo_casing/casing, casing_primer)
	var/obj/projectile/proj = ..(cycle, casing, casing_primer | CASING_PRIMER_MICROBATTERY)
	if(!istype(casing, /obj/item/ammo_casing/microbattery))
		return proj
	var/obj/item/ammo_casing/microbattery/microbattery_casing = casing
	if(microbattery_casing.microbattery_group_key == cached_group_key)
		--cached_group_remaining
	else
		scan_microbattery_group()
		if(cached_group_remaining)
			--cached_group_remaining
	return proj

/**
 * Used to switch ammo casings when the last one is empty if there's another one adjacent
 * to it.
 */
/obj/item/gun/projectile/ballistic/microbattery/proc/advance_within_microbattery_group()
	if(internal_magazine)
		if(length(internal_magazine_vec) <= 1)
			return TRUE
		var/obj/item/ammo_casing/microbattery/current_maybe_microbattery = internal_magazine_vec[length(internal_magazine_vec)]
		var/current_group = istype(current_maybe_microbattery) ? current_maybe_microbattery.microbattery_group_key : null
		if(isnull(current_group))
			return TRUE

		// found_index is the first index below the top of the magazine
		// that's within the same contiguous group-segment, and currently has a charge;
		// nothing in between the index and current will have a different group.
		var/found_index
		for(var/i in length(internal_magazine_vec) - 1 to 1 step -1)
			var/obj/item/ammo_casing/microbattery/maybe_microbattery = internal_magazine_vec[i]
			if(!istype(maybe_microbattery))
				break
			if(maybe_microbattery.microbattery_group_key != current_group)
				break
			if(!maybe_microbattery.shots_remaining)
				continue
			found_index = i
			break
		if(!found_index)
			return TRUE

		internal_magazine_vec = internal_magazine_vec.Copy(found_index + 2) + internal_magazine_vec.Copy(1, found_index + 1)
		return TRUE

	else
		var/obj/item/ammo_magazine/microbattery/maybe_microbattery_magazine = magazine
		return istype(maybe_microbattery_magazine) ? maybe_microbattery_magazine.advance_within_ammo_group() : FALSE

/**
 * * This returns TRUE if handled, not necessarily implying that ammo actually changed.
 *
 * @return TRUE if handled, FALSE if not
 */
/obj/item/gun/projectile/ballistic/microbattery/proc/cycle_microbattery_group()
	. = cycle_microbattery_group_impl()
	if(.)
		scan_microbattery_group()
		update_icon()

/obj/item/gun/projectile/ballistic/microbattery/proc/cycle_microbattery_group_impl()
	PRIVATE_PROC(TRUE)
	// we only support internal magazines, and external /microbattery magazines
	if(internal_magazine)
		if(length(internal_magazine_vec) <= 1)
			return TRUE
		var/obj/item/ammo_casing/microbattery/current_maybe_microbattery = internal_magazine_vec[length(internal_magazine_vec)]
		var/current_group = istype(current_maybe_microbattery) ? current_maybe_microbattery.microbattery_group_key : null

		// found_index is the first index below the top of the magazine
		// that's on a different group.
		var/found_index
		if(isnull(current_group))
			found_index = length(internal_magazine_vec) - 1
		else
			for(var/i in length(internal_magazine_vec) - 1 to 1 step -1)
				var/obj/item/ammo_casing/microbattery/maybe_microbattery = internal_magazine_vec[i]
				if(!istype(maybe_microbattery))
					found_index = i
					break
				if(maybe_microbattery.microbattery_group_key != current_group)
					found_index = i
					break
		if(!internal_magazine_vec)
			return TRUE
		internal_magazine_vec = internal_magazine_vec.Copy(internal_magazine_vec + 2) + internal_magazine_vec.Copy(1, found_index + 1)
		return TRUE
	else if(istype(magazine, /obj/item/ammo_magazine/microbattery))
		var/obj/item/ammo_magazine/microbattery/supported_magazine = magazine
		supported_magazine.cycle_ammo_group()
		return TRUE
	return FALSE

/**
 * Retallies current group key / capacity / remaining
 */
/obj/item/gun/projectile/ballistic/microbattery/proc/scan_microbattery_group()
	cached_group_key = cached_group_capacity = cached_group_remaining = cached_group_color = null

	var/obj/item/ammo_casing/microbattery/current = get_chambered()
	if(!istype(current))
		return
	cached_group_key = current.microbattery_group_key
	cached_group_color = current.microbattery_mode_color

	for(var/obj/item/ammo_casing/microbattery/maybe_relevant in internal_magazine ? internal_magazine_vec : magazine?.unsafe_get_ammo_internal_ref())
		if(maybe_relevant.microbattery_group_key != cached_group_key)
			continue
		cached_group_capacity += maybe_relevant.shots_capacity
		cached_group_remaining += isnull(maybe_relevant.shots_remaining) ? maybe_relevant.shots_capacity : maybe_relevant.shots_remaining

//* Actions *//

/obj/item/gun/projectile/ballistic/microbattery/register_item_actions(mob/user)
	if(!microbattery_swap_action)
		microbattery_swap_action = new(src)
	. = ..()
	microbattery_swap_action.grant(user.inventory.actions)

/obj/item/gun/projectile/ballistic/microbattery/unregister_item_actions(mob/user)
	. = ..()
	microbattery_swap_action?.revoke(user.inventory.actions)

//* Action Datums *//

/datum/action/item_action/gun_microbattery_swap
	name = "Cycle Microbattery Group"
	desc = "Cycle to the next logical group of microbatteries in the magazine."
	target_type = /obj/item/gun/projectile/ballistic/microbattery
	check_mobility_flags = MOBILITY_CAN_USE

/datum/action/item_action/gun_microbattery_swap/pre_render_hook()
	. = ..()
	var/image/item_overlay = button_additional_overlay
	var/image/symbol_overlay = image('icons/screen/actions/generic-overlays.dmi', "swap")
	symbol_overlay.color = "#ccaa00"
	item_overlay.add_overlay(symbol_overlay)

/datum/action/item_action/gun_microbattery_swap/invoke_target(obj/item/gun/projectile/ballistic/microbattery/target, datum/event_args/actor/actor)
	. = ..()
	target.user_switch_microbattery_group(actor)
