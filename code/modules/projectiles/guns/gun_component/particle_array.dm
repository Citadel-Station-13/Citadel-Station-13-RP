//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/particle_array
	name = "weapon particle array"
	desc = "A nondescript particle array used in energy weapons."
	icon = 'icons/modules/projectiles/components/particle_array.dmi'
	component_slot = GUN_COMPONENT_PARTICLE_ARRAY

	/// base charge cost in joules
	var/base_energy_cost = /obj/item/cell/device/weapon::maxcharge / 24 * 500
	/// considered lethal?
	/// * lethal arrays can be disabled on a separate 'safety' setting
	var/considered_lethal = FALSE

	/// projectile type
	var/projectile_type

/**
 * Consume next projectile hook
 */
/obj/item/gun_component/particle_array/proc/consume_next_projectile(datum/gun_firing_cycle/cycle) as /obj/projectile
	#warn cycle charge cost mod
	var/effective_power_use = base_energy_cost
	if(effective_power_use)
		if(!installed.modular_use_checked_power(src, effective_power_use))
			return GUN_FIRED_FAIL_EMPTY
	return generate_projectile(cycle)

/**
 * Generates a projectile.
 * * The projectile will be created in nullspace. You must immediately
 *   move or delete it, or this constitutes a memory leak.
 */
/obj/item/gun_component/particle_array/proc/generate_projectile(datum/gun_firing_cycle/cycle) as /obj/projectile
	return new projectile_type
