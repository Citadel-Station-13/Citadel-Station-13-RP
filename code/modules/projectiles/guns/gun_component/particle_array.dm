//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/design/generated/gun_component/particle_array
	abstract_type = /datum/prototype/design/generated/gun_component/particle_array

/**
 * ## Warning - Caveats
 * * Component signal hooks currently always fire, even if this isn't the active array.
 */
/obj/item/gun_component/particle_array
	name = "weapon particle array"
	desc = "A nondescript particle array used in energy weapons."
	icon = 'icons/modules/projectiles/components/particle_array.dmi'
	component_slot = GUN_COMPONENT_PARTICLE_ARRAY

	/// base charge cost in cell units
	var/base_charge_cost = /obj/item/cell/basic/tier_1/weapon::max_charge / 24
	/// base delay add
	var/base_delay_add = 0 SECONDS
	/// considered lethal?
	/// * lethal arrays can be disabled on a separate 'safety' setting
	var/considered_lethal = FALSE

	/// our selection name
	var/selection_name = "unknown particle"

	/// our render color
	var/render_color = "#ffffff"

	/// projectile type
	var/projectile_type

/**
 * Consume next projectile hook
 */
/obj/item/gun_component/particle_array/proc/consume_next_projectile(datum/gun_firing_cycle/cycle)
	// appliy delay if needed
	// sorry no subtracting with add! that can result in weird shit happening.
	if(cycle.cycle_iterations_fired == 1 && base_delay_add > 0)
		// first one, inject base delay
		cycle.firing_delay += base_delay_add
		cycle.overall_cooldown_adjust += base_delay_add
	var/effective_power_use = base_charge_cost * cycle.next_projectile_cost_multiplier
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

/**
 * Base projectile subtype for particle array / modular energy weapons.
 */
/obj/projectile/particle_array
	abstract_type = /obj/projectile/particle_array
	icon = 'icons/modules/projectiles/projectile.dmi'
	tracer_icon = 'icons/modules/projectiles/projectile-tracer.dmi'
