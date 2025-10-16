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
	var/obj/item/vehicle_component/actuator/comp_actuator
	/// our armor component
	/// * set to typepath to start with
	var/obj/item/vehicle_component/armor/comp_armor
	/// our electrical component
	/// * set to typepath to start with
	var/obj/item/vehicle_component/electrical/comp_electrical
	/// our gas component
	/// * set to typepath to start with
	var/obj/item/vehicle_component/gas/comp_gas
	/// our hull component
	/// * set to typepath to start with
	var/obj/item/vehicle_component/hull/comp_hull


#warn impl all
