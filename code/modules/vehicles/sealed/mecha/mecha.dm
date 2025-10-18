//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/armor/vehicle/mecha
	melee = 0.2
	melee_tier = 4
	bullet = 0.2
	bullet_tier = 4
	laser = 0.2
	laser_tier = 4

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
	armor_type = /datum/armor/vehicle/mecha
	integrity = 300
	integrity_max = 300
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
	START_PROCESSING(SSobj, src)

/obj/vehicle/sealed/mecha/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

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

/obj/vehicle/sealed/mecha/process(delta_time)
	#warn impl
	//! LEGACY
	// Legacy: Air temperature step, if air exists
	if(cabin_air?.volume && !hasInternalDamage(MECHA_INT_TEMP_CONTROL))
		// stabilize temperature
		// TODO: should be the job of a vehicle life support component; use proper heater and temperature loss modelling too.
		var/target_temperature_change = T20C - XGM_GET_TEMPERATURE(cabin_air)
		var/max_temperature_change = 10 + target_temperature_change * 0.35
		XGM_SET_TEMPERATURE(cabin_air, clamp(target_temperature_change, -max_temperature_change, max_temperature_change))
	// Legacy: Air pressurization step, if air exists
	if(internal_tank && cabin_air)
		legacy_air_flow_step()
	// Legacy: Process internal damage
	legacy_internal_damage_step()
	//! END
