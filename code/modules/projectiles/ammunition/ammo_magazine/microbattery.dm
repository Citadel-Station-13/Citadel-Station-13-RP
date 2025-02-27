//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Magazines specifically for microbattery casings.
 *
 * * Should never accept any other kind of casing.
 * * Microbattery guns don't necessarily need to use us, but normal
 *   magazines do not support cycling.
 */
/obj/item/ammo_magazine/microbattery
	name = "microbattery magazine"
	desc = "An experimental magazine for particle batteries used by hybrid energy weapons."

	/// Supports cycling
	var/supports_cycling = TRUE

#warn impl all

/**
 * Microbattery magazines need to support basically acting like a revolver.
 */
/obj/item/ammo_magazine/microbattery/proc/populate_datastructures()

/**
 * Cycles the ammo in a looping manner to the next group
 */
/obj/item/ammo_magazine/microbattery/proc/cycle_ammo_group()
