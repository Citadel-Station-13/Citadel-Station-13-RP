//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/projectile/sealant
	name = "sealant glob"
	desc = "A glob of sealant. Doesn't look pleasant to be hit by."
	icon = 'icons/modules/sealant_gun/sealant_glob.dmi'
	icon_state = "projectile"

	/**
	 * Sprites exist for these slots, as well as hands.
	 */
	var/const/list/allowed_slot_ids = list(
		/datum/inventory_slot/abstract/put_in_hands::id,
		/datum/inventory_slot/inventory/head::id,
		/datum/inventory_slot/inventory/mask::id,
		/datum/inventory_slot/inventory/shoes::id,
		/datum/inventory_slot/inventory/suit::id,
	)

	impact_ground_on_expiry = TRUE

/obj/projectile/sealant/clone()
	var/obj/projectile/cloning = ..()
	// todo: impl
	return cloning

#warn impl

/obj/projectile/sealant/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()

	// todo: use /obj/effect/temp_visual/sealant_splat

/obj/projectile/sealant/proc/apply_sealant_to_mob(mob/target, target_zone)

/obj/projectile/sealant/proc/apply_sealant_to_inventory(datum/inventory/inventory, slot_id)
