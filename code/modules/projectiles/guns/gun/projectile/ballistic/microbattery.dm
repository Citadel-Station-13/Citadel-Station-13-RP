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

	#warn handle this
	var/datum/action/item_action/gun_microbattery_swap/microbattery_swap_action

	var/tmp/cached_group_key
	var/tmp/cached_group_capacity
	var/tmp/cached_group_remaining

/obj/item/gun/projectile/ballistic/microbattery/get_ammo_ratio(rounded)
	if(!cached_group_remaining)
		return 0
	return cached_group_capacity / cached_group_remaining

/obj/item/gun/projectile/ballistic/microbattery/get_ammo_remaining()
	return cached_group_remaining

/**
 * * This returns TRUE if handled, not necessarily implying that ammo actually changed.
 *
 * @return TRUE if handled, FALSE if not
 */
/obj/item/gun/projectile/ballistic/microbattery/proc/cycle_microbattery_group()
	. = cycle_microbattery_group_impl()
	if(.)
		scan_microbattery_group()

/obj/item/gun/projectile/ballistic/microbattery/proc/cycle_microbattery_group_impl()
	PRIVATE_PROC(TRUE)
	// we only support internal magazines, and external /microbattery magazines
	if(internal_magazine)
		if(length(internal_magazine_vec) <= 1)
			return TRUE
		if(!internal_magazine_revolver_mode)
			return TRUE
		var/obj/item/ammo_casing/microbattery/current_casing = internal_magazine_vec[internal_magazine_revolver_offset]
		var/current_group_key = current_casing?.microbattery_group_key
		for(var/i in internal_magazine_revolver_offset + 1 to length(internal_magazine_vec))
			var/obj/item/ammo_casing/microbattery/at_index = internal_magazine_vec[i]
			if(isnull(current_group_key) || at_index.microbattery_group_key != current_group_key)
				unsafe_spin_chamber_to_index(i)
				return TRUE
		for(var/i in 1 to internal_magazine_revolver_offset - 1)
			var/obj/item/ammo_casing/microbattery/at_index = internal_magazine_vec[i]
			if(isnull(current_group_key) || at_index.microbattery_group_key != current_group_key)
				unsafe_spin_chamber_to_index(i)
				return TRUE
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
	cached_group_key = cached_group_capacity = cached_group_remaining = null

	var/obj/item/ammo_casing/microbattery/current = get_chambered()
	if(!istype(current))
		return
	cached_group_key = current.microbattery_group_key
	cached_group_capacity += current.shots_capacity
	cached_group_remaining += current.shots_remaining

	for(var/obj/item/ammo_casing/microbattery/maybe_relevant in internal_magazine ? internal_magazine_vec : magazine?.unsafe_get_ammo_internal_ref())
		if(maybe_relevant.microbattery_group_key != cached_group_key)
			continue
		cached_group_capacity += maybe_relevant.shots_capacity
		cached_group_remaining += maybe_relevant.shots_remaining
