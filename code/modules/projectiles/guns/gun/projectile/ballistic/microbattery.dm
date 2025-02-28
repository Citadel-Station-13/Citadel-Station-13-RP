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

#warn impl all

/**
 * * This returns TRUE if handled, not necessarily implying that ammo actually changed.
 *
 * @return TRUE if handled, FALSE if not
 */
/obj/item/gun/projectile/ballistic/microbattery/proc/cycle_microbattery_group()
	// we only support internal magazines, and external /microbattery magazines
	if(internal_magazine)
		if(length(internal_magazine_vec) <= 1)
			return TRUE
		if(!internal_magazine_is_revolver)
			return TRUE
		var/obj/item/ammo_casing/microbattery/current_casing = internal_magazine_vec[internal_magazine_borrowed_offset]
		var/current_group_key = current_casing?.microbattery_group_key
		for(var/i in internal_magazine_borrowed_offset + 1 to length(internal_magazine_vec))
			var/obj/item/ammo_casing/microbattery/at_index = internal_magazine_vec[i]
			if(at_index.microbattery_group_key != current_group_key)
				unsafe_spin_chamber_to_index(i)
				return TRUE
		for(var/i in 1 to internal_magazine_borrowed_offset - 1)
			var/obj/item/ammo_casing/microbattery/at_index = internal_magazine_vec[i]
			if(at_index.microbattery_group_key != current_group_key)
				unsafe_spin_chamber_to_index(i)
				return TRUE
		return TRUE
	else if(istype(magazine, /obj/item/ammo_magazine/microbattery))
		var/obj/item/ammo_magazine/microbattery/supported_magazine = magazine
		supported_magazine.cycle_ammo_group()
		return TRUE
	return FALSE
