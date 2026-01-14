//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

GLOBAL_LIST_INIT(mecha_faults, init_mecha_faults())

/proc/init_mecha_faults()
	. = list()
	for(var/datum/mecha_fault/fault_type as anything in subtypesof(/datum/mecha_fault))
		.[fault_type] = new fault_type

/**
 * relatively stateless thingys
 * * can be stacked.
 * * shows up in UI
 */
/datum/mecha_fault
	/// id for UI and internal systems; do not change this
	var/id
	var/name = "unknown fault"
	var/desc = "A critical fault in the exosuit's systems."
	var/requires_ticking = TRUE

	#warn hook these
	var/sfx_on_apply = 'sound/mecha/critdestrnano.ogg'
	var/sfx_on_apply_vol = 75
	var/sfx_on_apply_external
	var/sfx_on_apply_vary = TRUE

	var/sfx_on_remove
	var/sfx_on_remove_vol = 75
	var/sfx_on_remove_external
	var/sfx_on_remove_vary = TRUE

	var/sfx_on_gain_stack
	var/sfx_on_gain_stack_vol = 75
	var/sfx_on_gain_stack_external
	var/sfx_on_gain_stack_vary = TRUE

	var/sfx_on_lose_stack
	var/sfx_on_lose_stack_vol = 75
	var/sfx_on_lose_stack_external
	var/sfx_on_lose_stack_vary = TRUE

#warn ways of inflicting these lol.

/**
 * * Called before `on_stack_change`
 * * It is undefined whether `mecha_fault_stacks` on the mecha will be changed before or after
 *   this call; use `on_stack_change` for behavior that cares.
 */
/datum/mecha_fault/proc/on_apply(obj/vehicle/sealed/mecha/mech)
	return

/**
 * * Called after `on_stack_change`
 * * It is undefined whether `mecha_fault_stacks` on the mecha will be changed before or after
 *   this call; use `on_stack_change` for behavior that cares.
 */
/datum/mecha_fault/proc/on_remove(obj/vehicle/sealed/mecha/mech)
	return

/**
 * * called after on_apply
 * * called before on_remove
 * * It is undefined whether `mecha_fault_stacks` on the mecha will be changed before or after
 *   this call; use the arguments.
 */
/datum/mecha_fault/proc/on_stack_change(obj/vehicle/sealed/mecha/mecha, old_stacks, new_stacks)
	return

/datum/mecha_fault/proc/tick(obj/vehicle/sealed/mecha/mech, stacks = 1, dt = 1)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	on_tick(mech, stacks)

/datum/mecha_fault/proc/on_tick(obj/vehicle/sealed/mecha/mech, stacks, dt)
	return

#warn impl

/**
 * causes:
 * * the main air tank to lose air to surroundings
 * fixed by:
 * * maint panel
 */
/datum/mecha_fault/tank_breach
	id = "tank-breach"
	name = "tank breach"
	desc = "The exosuit's internal airtank is leaking air."
	// TODO: sfx

/datum/mecha_fault/tank_breach/on_tick(obj/vehicle/sealed/mecha/mech, stacks, dt)
	..()
	// this is a somewhat serious fault as you need to fix it from maint panel, so.
	// lose less air.
	var/lose_ratio = stacks * 0.001
	#warn impl

/**
 * causes:
 * * heating internals up
 * fixed by:
 * * automatic
 */
/datum/mecha_fault/internal_fire
	id = "internal-fire"
	name = "internal fire"
	desc = "Something has ignited inside the cabin's backplane"
	sfx_on_apply = 'sound/mecha/internaldmgalarm.ogg'
	// TODO: sfx

/datum/mecha_fault/internal_fire/on_tick(obj/vehicle/sealed/mecha/mech, stacks, dt)
	..()
	var/max_temperature = T100C + stacks * 50
	var/ideal_stp_temperature_change = 0.5 * stacks
	#warn impl; damage too?
	#warn check oxygen and use oxygen for cabin air
	var/energy_to_add = stacks * THERMAL_ENERGY_STP_FOR_CHANGE(0.5)

/datum/mecha_fault/internal_fire/on_apply(obj/vehicle/sealed/mecha/mech)
	..()

/datum/mecha_fault/internal_fire/on_remove(obj/vehicle/sealed/mecha/mech)
	..()
//
#warn warn occupant

/**
 * causes:
 * * stumbling around in movement on bipedal mechs
 * * (unimplemented) angular dispersion, inaccuracy, and more on module aiming
 * fixed by:
 * * automatic, and maint panel
 */
/datum/mecha_fault/calibration_lost
	id = "calibration-lost"
	name = "calibration lost"
	desc = "The exosuit is experiencing control issues with its actuators."
	// TODO: sfx
	requires_ticking = FALSE

/**
 * causes:
 * * the cabin to mix with outside air
 * fixed by:
 * * damage being repaired
 */
/datum/mecha_fault/cabin_breach
	id = "cabin-breach"
	name = "cabin breach"
	desc = "The exosuit is leaking air from its cabin!"
	// TODO: sfx

/datum/mecha_fault/cabin_breach/on_tick(obj/vehicle/sealed/mecha/mech, stacks, dt)
	..()
	var/mix_ratio = stacks * 0.0025
	#warn impl

/**
 * causes:
 * * dynamic swings in temperature
 * * disables temperature regulation
 * fixed by:
 * * automatic, and maint panel
 */
/datum/mecha_fault/temperature_control
	id = "temperature-control"
	name = "thermal controller instability"
	desc = "The exosuit's thermal controller is malfunctioning."
	// TODO: sfx

/datum/mecha_fault/temperature_control/on_apply(obj/vehicle/sealed/mecha/mech)
	..()
	mech.occupant_send_default_chat(SPAN_BOLDWARNING("System: thermoregulation module offline."))

/datum/mecha_fault/temperature_control/on_remove(obj/vehicle/sealed/mecha/mech)
	..()
	mech.occupant_send_default_chat(SPAN_NOTICE("System: Thermoregulation module back online."))
	if(mech.fault_check(/datum/mecha_fault/internal_fire))
		mech.occupant_send_default_chat(SPAN_BOLDWARNING("System: Attempting fire supression..."))

/**
 * causes:
 * * higher power draws
 * * very slow cell discharge
 * fixed by:
 * * maint panel
 */
/datum/mecha_fault/short_circuit
	id = "short-circuit"
	name = "short circuit"
	desc = "The exosuit's internal wiring has fused together."
	// TODO: sfx

/datum/mecha_fault/short_circuit/on_tick(obj/vehicle/sealed/mecha/mech, stacks, dt)
	..()
	if(!mech.power_cell?.charge)
		return
	// a few stacks is still only a small chance because this is dangerous
	// and requires you to fix it from maint panel
	var/prob = dt * stacks * 0.005
	var/severity = prob > 100 ? prob / 100 : 1
	#warn drain, spark
	mech.spark_system.start()
