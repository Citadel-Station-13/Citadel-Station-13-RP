//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * A special microbattery casing capable of being recharged after use.
 */
/obj/item/ammo_casing/microbattery
	name = "microbattery"
	desc = "An experimental particle battery used for a hybrid energy weapon."
	slot_flags = SLOT_EARS
	w_class = WEIGHT_CLASS_TINY

	#warn how to handle caliber?

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

#warn impl all
