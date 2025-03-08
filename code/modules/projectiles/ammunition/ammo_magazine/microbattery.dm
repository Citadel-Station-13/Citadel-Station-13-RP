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
	should_collect_spent = TRUE

	/// Supports cycling
	var/supports_cycling = TRUE

/obj/item/ammo_magazine/microbattery/Initialize(mapload)
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
 * Cycles the ammo in a looping manner to the next casing in the current group
 * * This returns TRUE if it tries to do something (the mag supports cycling), not if it actually
 *   successfully cycles.
 *
 * @return TRUE if supported / handled, FALSE otherwise
 */
/obj/item/ammo_magazine/microbattery/proc/advance_within_ammo_group()
	if(!supports_cycling)
		return FALSE
	if(length(ammo_internal) <= 1)
		return TRUE
	var/obj/item/ammo_casing/microbattery/current_maybe_microbattery = ammo_internal[length(ammo_internal)]
	var/current_group = istype(current_maybe_microbattery) ? current_maybe_microbattery.microbattery_group_key : null
	if(isnull(current_group))
		return TRUE

	// found_index is the first index below the top of the magazine
	// that's within the same contiguous group-segment, and currently has a charge;
	// nothing in between the index and current will have a different group.
	var/found_index
	for(var/i in length(ammo_internal) - 1 to 1 step -1)
		var/obj/item/ammo_casing/microbattery/maybe_microbattery = ammo_internal[i]
		if(!istype(maybe_microbattery))
			break
		if(maybe_microbattery.microbattery_group_key != current_group)
			break
		if(!maybe_microbattery.get_shots_remaining())
			continue
		found_index = i
		break
	if(!found_index)
		return TRUE

	ammo_internal = ammo_internal.Copy(found_index + 1) + ammo_internal.Copy(1, found_index + 1)
	return TRUE

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
	if(length(ammo_internal) <= 1)
		return TRUE
	var/obj/item/ammo_casing/microbattery/current_maybe_microbattery = ammo_internal[length(ammo_internal)]
	var/current_group = istype(current_maybe_microbattery) ? current_maybe_microbattery.microbattery_group_key : null

	// found_index is the first index below the top of the magazine
	// that's on a different group.
	var/found_index
	if(isnull(current_group))
		found_index = length(ammo_internal) - 1
	else
		for(var/i in length(ammo_internal) - 1 to 1 step -1)
			var/obj/item/ammo_casing/microbattery/maybe_microbattery = ammo_internal[i]
			if(!istype(maybe_microbattery))
				found_index = i
				break
			if(maybe_microbattery.microbattery_group_key != current_group)
				found_index = i
				break
	if(!found_index)
		return TRUE

	ammo_internal = ammo_internal.Copy(found_index + 1) + ammo_internal.Copy(1, found_index + 1)
	return TRUE
