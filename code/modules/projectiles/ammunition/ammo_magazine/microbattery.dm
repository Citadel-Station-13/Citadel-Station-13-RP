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

/obj/item/ammo_magazine/microbattery/Initialize()
	. = ..()
	populate_datastructures()

/**
 * Microbattery magazines need to support basically acting like a revolver.
 */
/obj/item/ammo_magazine/microbattery/proc/populate_datastructures()
	if(!supports_cycling)
		return
	instantiate_internal_list()

/**
 * Cycles the ammo in a looping manner to the next group
 * * This returns TRUE if it tries to do something (the mag supports cycling), not if it actually
 *   successfully cycles.
 * * This cycles the top (so the one that the peek/pop accessor uses) casing to another group, if possible.
 *
 * @return TRUE if supported / handled, FALSE otherwise
 */
/obj/item/ammo_magazine/microbattery/proc/cycle_ammo_group()
	if(!supports_cycling)
		return FALSE
	var/obj/item/ammo_casing/microbattery/current_maybe_microbattery = ammo_internal[length(ammo_internal)]
	var/current_group = istype(current_maybe_microbattery) ? current_maybe_microbattery.microbattery_group_key : null


	#warn impl; null group is NaN and does not equate to other null groups!
