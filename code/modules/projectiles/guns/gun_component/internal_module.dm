//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/internal_module
	name = "weapon module"
	desc = "An internal module for a modular gun."
	icon = 'icons/modules/projectiles/components/internal_module.dmi'
	component_slot = GUN_COMPONENT_INTERNAL_MODULE

// TODO: This file is mostly stubs and WIPs.

/**
 * mostly a test module;
 *
 * * makes the gun fire a second round on every fire
 * * conflicts with any other burst modifiers
 */
/obj/item/gun_component/internal_module/double_shot
	name = "\improper AN-94 Fire Controller"
	desc = /obj/item/gun_component/internal_module::desc + " This will cause the gun to fire one additional round per burst, at the cost of reduced accuracy."
	hook_iteration_pre_fire = TRUE

	/// angular dispersion to impose on the last round in the burst, and the round we add
	var/dispersion_amount = 3.5

/obj/item/gun_component/internal_module/double_shot/on_firing_cycle_iteration(obj/item/gun/source, datum/gun_firing_cycle/cycle)
	// only invoke on last iteration
	if(cycle.cycle_iterations_fired != cycle.firing_iterations)
		return
	// do not invoke multiple times
	switch(LAZYACCESS(cycle.blackboard, "an-94-refire-triggered"))
		if(0, null)
			// set re-invoke flag
			LAZYSET(cycle.blackboard, "an-94-refire-triggered", 1)
			// add one iteration
			cycle.firing_iterations++
			// force current shot dispersion
			cycle.next_dispersion_adjust += dispersion_amount
		if(1)
			// add dispersion
			LAZYSET(cycle.blackboard, "an-94-refire-triggered", 2)
			cycle.next_dispersion_adjust += dispersion_amount

// todo: integrated electronics framework
