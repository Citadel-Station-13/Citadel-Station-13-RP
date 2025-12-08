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
	var/obj/item/vehicle_component/plating/mecha_armor/comp_armor = /obj/item/vehicle_component/plating/mecha_armor
	/// armor relative thickness
	/// * pretty much multiplies the integrity and weight
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
	var/obj/item/vehicle_component/plating/mecha_hull/comp_hull = /obj/item/vehicle_component/plating/mecha_hull
	/// hull relative thickness
	/// * pretty much multiplies the integrity and weight
	/// * relative to 1
	var/comp_hull_relative_thickness = 1

	// TODO: these should not be hardcoded but since i don't have a good
	//       formula yet they are. armor doesn't have a rel_size because it's
	//       always checked first.
	var/comp_actuator_rel_size = 1
	var/comp_hull_rel_size = 10
	var/comp_electrical_rel_size = 1
	var/comp_gas_rel_size = 1

	//* Faults *//
	/// Fault path to stacks
	var/list/mecha_fault_stacks

	//* Lights *//
	/// Floodlights are on
	var/floodlight_active = FALSE
	/// Floodlight range
	var/floodlight_range = 6
	/// Floodlight power
	var/floodlight_power = 0.7
	/// Floodlight color
	var/floodlight_color = "#ffffff"

	//* Melee *//
	/// Pickable melee options; set to list of typepaths to init
	var/list/datum/melee_attack/vehicle/mecha/melee_attacks = list(
		/datum/melee_attack/vehicle/mecha/punch,
		/datum/melee_attack/vehicle/mecha/kick,
	)
	/// Currently active melee attack
	var/datum/melee_attack/vehicle/mecha/melee_attack
	/// 'Standard' melee force, used to scale a melee attack accordingly.
	var/melee_standard_force = 20
	/// 'Standard' melee tier
	var/melee_standard_tier = 4.25
	/// 'Standard' melee attack cooldown
	var/melee_standard_speed = 0.8 SECONDS
	/// 'Standard' melee knockdown power
	var/melee_standard_knockdown = 20
	/// 'Standard' melee push-away power
	var/melee_standard_push_force = MOVE_FORCE_OVERPOWERING

	/// Next melee attack
	//  TODO: get rid of this on /mob-vehicle update
	var/melee_next_time

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
	/// Base move cost in joules
	var/move_cost_base = 2000
	/// Base turn cost in joules
	var/turn_cost_base = 500

	//* Power *//
	/// Our cell
	var/obj/item/cell/power_cell
	/// Our starting cell type
	//  TODO: this is super beecause we're moving to 30k base cells for large anyways at some point
	var/power_cell_type = /obj/item/cell/super

/obj/vehicle/sealed/mecha/Initialize()
	. = ..()
	create_initial_cell()
	START_PROCESSING(SSobj, src)

/obj/vehicle/sealed/mecha/Destroy()
	STOP_PROCESSING(SSobj, src)
	// TODO: cell wreckage?
	QDEL_NULL(power_cell)
	return ..()

/obj/vehicle/sealed/mecha/create_initial_cell(path = power_cell_type)
	if(power_cell)
		QDEL_NULL(power_cell)
	if(path)
		power_cell = new path

/obj/vehicle/sealed/mecha/create_initial_components()
	..()
	var/list/making = list()
	// these checks support anonymous types / pops which aren't technically paths.
	if(comp_actuator && !istype(comp_actuator))
		making += comp_actuator
		comp_actuator = null
	if(comp_armor && !istype(comp_armor))
		making += comp_armor
		comp_armor = null
	if(comp_hull && !istype(comp_hull))
		making += comp_hull
		comp_hull = null
	if(comp_electrical && !istype(comp_electrical))
		making += comp_electrical
		comp_electrical = null
	if(comp_gas && !istype(comp_gas))
		making += comp_gas
		comp_gas = null
	for(var/maybe_path in making)
		var/obj/item/vehicle_component/created = new maybe_path
		if(!install_component(created, null, TRUE, TRUE))
			// if you're reading this, make sure you're not trying to overrule
			// things that cannot be overruled with 'force' parameter.
			//
			// we generally use those for stability concerns so admins/mappers are not allowed
			// to overrule it.
			stack_trace("failed to install initial component [created] ([maybe_path]).")
			qdel(created)

/obj/vehicle/sealed/mecha/proc/user_set_strafing(datum/event_args/actor/actor, active)
	if(!set_strafing(active))
		return FALSE
	#warn log, feedback
	return TRUE

/obj/vehicle/sealed/mecha/proc/set_strafing(strafing)
	if(strafing == src.strafing)
		return TRUE
	src.strafing = strafing
	var/datum/vehicle_ui_controller/mecha/casted_ui_controller = ui_controller
	casted_ui_controller.update_ui_strafing()
	return TRUE

/obj/vehicle/sealed/mecha/proc/user_set_floodlights(datum/event_args/actor/actor, active)
	if(!set_floodlights(active))
		return FALSE
	#warn log, feedback
	playsound(src, 'sound/mecha/heavylightswitch.ogg', 50, 1)
	return TRUE

/obj/vehicle/sealed/mecha/proc/set_floodlights(active)
	if(active == src.floodlight_active)
		return
	src.floodlight_active = active
	if(active)
		set_light(floodlight_range, floodlight_power, floodlight_color)
	else
		set_light(l_power = 0)
	var/datum/vehicle_ui_controller/mecha/casted_ui_controller = ui_controller
	casted_ui_controller.update_ui_floodlights()
	#warn update button
	return TRUE

#warn impl all

/obj/vehicle/sealed/mecha/process(delta_time)
	// Attempt to recalibrate
	// TODO: faster if not moving / acting
	if(fault_check(/datum/mecha_fault/calibration_lost))
		// 10% per second
		if(prob(10 * delta_time))
			fault_remove(/datum/mecha_fault/calibration_lost, 1)
	// Attempt to fix temperature controller
	if(fault_check(/datum/mecha_fault/temperature_control))
		// 7% per second
		if(prob(7 * delta_time))
			fault_remove(/datum/mecha_fault/temperature_control, 1)
	fault_process(delta_time)
	#warn impl
	//! LEGACY
	// Legacy: Air temperature step, if air exists
	if(cabin_air?.volume && !fault_check(/datum/mecha_fault/temperature_control))
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

/obj/vehicle/sealed/mecha/mob_can_enter(mob/entering, datum/event_args/actor/actor, silent, suppressed)
	. = ..()
	if(!.)
		return
	// Yes, you can shove people in the mech now.
	if(!check_access_for_cockpit(actor?.performer || entering))
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("Access denied."),
				target = src,
			)
		return FALSE
	return TRUE

//* Access *//

/obj/vehicle/sealed/mecha/proc/check_access_for_maint(mob/user)
	#warn impl

/obj/vehicle/sealed/mecha/proc/check_access_for_cockpit(mob/user)
	return check_access_for_maint(user)
