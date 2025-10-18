//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * This is called 'mecha' but it'll eventually just be our 'complex composable vehicle base'.
 * We'll have a tank, eventually. Surely.
 *
 * ## Components
 *
 * * Actuator: Movement actuators
 * * Armor: external armor
 * * Electrical: Power backplane
 * * Gas: Life support, EVA jet draws
 * * Hull: Internal armor
 *
 * ## Defense Handling
 *
 * * Armor is the first armor layer
 * * Hull is the second armor layer
 * * Base /vehicle integrity/armor is the third, and final chassis layer
 *
 * Incoming damage instances go through them in order.
 * * Once armor is pierced, damage can hit modules and other components.
 * * Once hull is pierced, modules/component hits become much more likely.
 * * Once chassis is pierced, damage can hit the occupant
 */
/obj/vehicle/sealed/mecha
	/// Can't go through
	density = TRUE
	/// Blocks vision
	/// * Unfortunately this doesn't work well with multi-tiles. We might have to re-evaluate.
	opacity = TRUE

	//* Vehicle - Occupant Actions *//
	occupant_actions = list(
		/datum/action/vehicle/mecha/eject,
	)

	//* Components *//
	/// our actuator component
	/// * set to typepath to start with
	var/obj/item/vehicle_component/mecha_actuator/comp_actuator = /obj/item/vehicle_component/mecha_actuator
	/// our armor component
	/// * set to typepath to start with
	var/obj/item/vehicle_component/plating/armor/comp_armor = /obj/item/vehicle_component/plating/armor
	/// armor relative thickness
	/// * pretty much multiplies the integrity
	/// * relative to 1
	var/comp_armor_relative_thickness = 1
	/// our electrical component
	/// * set to typepath to start with
	var/obj/item/vehicle_component/mecha_electrical/comp_electrical = /obj/item/vehicle_component/mecha_electrical
	/// our gas component
	/// * set to typepath to start with
	var/obj/item/vehicle_component/mecha_gas/comp_gas = /obj/item/vehicle_component/mecha_gas
	/// our hull component
	/// * set to typepath to start with
	var/obj/item/vehicle_component/plating/hull/comp_hull = /obj/item/vehicle_component/plating/hull
	/// hull relative thickness
	/// * pretty much multiplies the integrity
	/// * relative to 1
	var/comp_hull_relative_thickness = 1

/obj/vehicle/sealed/mecha/Initialize()
	. = ..()
	#warn anything?

/obj/vehicle/sealed/mecha/create_initial_components()
	..()
	for(var/maybe_path in list(
		initial(comp_actuator),
		initial(comp_armor),
		initial(comp_electrical),
		initial(comp_gas),
		initial(comp_hull),
	))
		if(!ispath(maybe_path))
			continue
		#warn impl


#warn impl all
