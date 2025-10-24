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

	ui_path = "vehicle/mecha/MechaController"

	//* Vehicle - Occupant Actions *//
	occupant_actions = list(
		/datum/action/vehicle/mecha/eject,
	)

	//* Cargo Hold *//
	/// Things in cargo hold
	/// * Lazy list
	/// * Should technically be a module but for better or worse this is an intrinsic of the /mecha
	///   type. This allows all mechs to use hydraulic clamps to pick up cargo.
	var/atom/movable/cargo_held
	/// Cargo hold capacity
	var/cargo_capacity = 1

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

	//* Maintenance *//
	#warn impl maybe?

	//* Movement *//
	/// Base turn speed. If non-zero, turns will take time.
	/// * A non-zero value specifically activates turn handling systems. Under turn handling,
	///   mecha move a little differently from normal.
	#warn impl
	var/base_turn_delay = 0
	/// Strafing? Strafing mechs won't turn to face where they're going.
	var/strafing = FALSE
	/// Move sound
	/// * Can be a soundbyte ID or path.
	var/move_sound = 'sound/mecha/mechstep.ogg'
	/// Turn sound
	/// * Can be a soundbyte ID or path.
	var/turn_sound = 'sound/mecha/mechturn.ogg'

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

/obj/vehicle/sealed/mecha/vehicle_turn(direction)
	if(dir == direction)
		return TRUE
	. = ..()
	if(.)
		#warn set move delay

/obj/vehicle/sealed/mecha/vehicle_move(direction)
	// Mechs have a special movement controller.
	if(strafing)
		// Strafing: Usually comes with a move delay but doesn't turn the mech.
		#warn handle strafing
	else if(!(direction & dir))
		// Normal: Turn the mech if we're not travelling vaguely in our dir.
		#warn handle turn

	return vehicle_move(direction, dir)

/obj/vehicle/sealed/mecha/proc/set_strafing(strafing)
	if(strafing == src.strafing)
		return TRUE
	src.strafing = strafing
	var/datum/vehicle_ui_controller/mecha/casted_ui_controller = ui_controller
	casted_ui_controller.update_ui_strafing()
	return TRUE

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
