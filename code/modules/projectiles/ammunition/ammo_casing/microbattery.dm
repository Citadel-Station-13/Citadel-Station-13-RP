//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * A special microbattery casing capable of being recharged after use.
 */
/obj/item/ammo_casing/microbattery
	name = "microbattery"
	desc = "An experimental particle battery used for a hybrid energy weapon."
	slot_flags = SLOT_EARS | SLOT_POCKET | SLOT_BELT
	w_class = WEIGHT_CLASS_TINY

	icon_spent = FALSE
	casing_caliber = /datum/ammo_caliber/microbattery
	casing_primer = CASING_PRIMER_MICROBATTERY

	// todo: residue vars are legacy
	leaves_residue = FALSE

	/// our group key
	/// * used so a revolver-like gun can switch to the next microbattery
	///   of a different type.
	/// * null is like NaN, it's not equivalent to itself or any other group key
	var/microbattery_group_key
	/// name used when we switch to this
	var/microbattery_mode_name
	/// color used for firemode color when we switch to this
	var/microbattery_mode_color

	/// allow recharging
	var/can_recharge = TRUE

	/// shots left; defaults to max
	var/shots_remaining
	/// shots max
	var/shots_capacity = 1

	// todo: charge costs should probably be a thing lmfao

/obj/item/ammo_casing/microbattery/expend()
	if(isnull(shots_remaining))
		if(!shots_capacity)
			return ..()
		shots_remaining = shots_capacity
	if(shots_remaining <= 0)
		return ..()
	--shots_remaining
	projectile_stored = null
	return ..()

/obj/item/ammo_casing/microbattery/is_loaded()
	return isnull(shots_remaining) ? shots_capacity : shots_remaining

/obj/item/ammo_casing/microbattery/proc/get_shots_remaining()
	return isnull(shots_remaining) ? shots_capacity : shots_remaining

/obj/item/ammo_casing/microbattery/proc/get_remaining_ratio()
	return (isnull(shots_remaining) ? shots_capacity : shots_remaining) / shots_capacity
