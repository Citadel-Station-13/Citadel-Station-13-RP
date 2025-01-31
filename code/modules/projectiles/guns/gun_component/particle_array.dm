//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/particle_array
	name = "weapon particle array"
	desc = "A nondescript particle array used in energy weapons."
	icon = 'icons/modules/projectiles/components/particle_array.dmi'
	component_slot = GUN_COMPONENT_PARTICLE_ARRAY

	/// base charge cost
	var/charge_cost = /obj/item/cell/device/weapon::maxcharge / 24
	/// considered lethal?
	/// * lethal arrays can be disabled on a separate 'safety' setting
	var/considered_lethal = FALSE

	/// projectile type
	var/projectile_type

/**
 * Generates a projectile.
 * * The projectile will be created in nullspace. You must immediately
 *   move or delete it, or this constitutes a memory leak.
 */
/obj/item/gun_component/particle_array/proc/generate_projectile(datum/gun_firing_cycle/cycle) as /obj/projectile
	return new projectile_type
