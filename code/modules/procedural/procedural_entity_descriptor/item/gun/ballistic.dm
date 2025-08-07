//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/procedural_entity_descriptor/item/gun/ballistic

/**
 * Spawns basically what's going to be a revolver.
 */
/datum/procedural_entity_descriptor/item/gun/ballistic/xenoarcheology_1
	var/min_ammo = 2
	var/max_ammo = 12

	// this is shit but whatever
/datum/procedural_entity_descriptor/item/gun/ballistic/xenoarcheology_1/instantiate_single(atom/location, seed_unimplemented)
	var/obj/item/gun/projectile/ballistic/created_gun = new /obj/item/gun/projectile/ballistic/revolver(location)
	created_gun.icon = 'icons/obj/xenoarchaeology.dmi'
	created_gun.icon_state = "gun[rand(1,4)]"
	created_gun.caliber = null
	created_gun.internal_magazine = TRUE
	created_gun.internal_magazine_size = rand(min_ammo, max_ammo)
	for(var/i in 1 to created_gun.internal_magazine_size)
		created_gun.insert_casing(new /obj/item/ammo_casing/a7_62mm/ap)
	return created_gun
