//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * relatively stateless thingys
 * * can be stacked.
 * * is stateless because status effects should be used for stateful ones.
 */
/datum/mecha_fault
	var/name = "unknown fault"
	var/desc = "A critical fault in the exosuit's systems."

/datum/mecha_fault/proc/on_apply(obj/vehicle/sealed/mecha/mech)


/datum/mecha_fault/proc/on_remove(obj/vehicle/sealed/mecha/mech)

/**
 * * called after on_apply
 * * called before on_remove
 */
/datum/mecha_fault/proc/on_stack_change(obj/vehicle/sealed/mecha/mecha, old_stacks, new_stacks)

/datum/mecha_fault/proc/tick(obj/vehicle/sealed/mecha/mech, stacks = 1)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	on_tick(mech, stacks)

/datum/mecha_fault/proc/on_tick(obj/vehicle/sealed/mecha/mech, stacks)

#warn impl

/**
 * causes:
 * * the main air tank to lose air to surroundings
 * fixed by:
 * * automatic
 */
/datum/mecha_fault/tank_breach
	name = "tank breach"
	desc = "The exosuit's internal airtank is leaking air."

/datum/mecha_fault/tank_breach/on_tick(obj/vehicle/sealed/mecha/mech, stacks)
	. = ..()

/**
 * causes:
 * * heating internals up
 * fixed by:
 * * automatic
 */
/datum/mecha_fault/internal_fire
	name = "internal fire"
	desc = "Something has ignited inside the cabin's backplane"

/datum/mecha_fault/internal_fire/on_tick(obj/vehicle/sealed/mecha/mech, stacks)
	. = ..()

/datum/mecha_fault/internal_fire/on_apply(obj/vehicle/sealed/mecha/mech)
	. = ..()

/datum/mecha_fault/internal_fire/on_remove(obj/vehicle/sealed/mecha/mech)
	. = ..()
// 'sound/mecha/internaldmgalarm.ogg'
#warn warn occupant

/**
 * causes:
 * * stumbling around in movement on bipedal mechs
 * * (unimplemented) angular dispersion, inaccuracy, and more on module aiming
 * fixed by:
 * * automatic
 */
/datum/mecha_fault/calibration_lost
	name = "calibration lost"
	desc = "The exosuit is experiencing control issues with its actuators."

/datum/mecha_fault/calibration_lost/on_tick(obj/vehicle/sealed/mecha/mech, stacks)
	. = ..()

/**
 * causes:
 * * the cabin to mix with outside air
 * fixed by:
 * * automatic
 */
/datum/mecha_fault/cabin_breach
	name = "cabin breach"
	desc = "The exosuit is leaking air from its cabin!"

/datum/mecha_fault/cabin_breach/on_tick(obj/vehicle/sealed/mecha/mech, stacks)
	. = ..()

/**
 * causes:
 * * dynamic swings in temperature
 * * disables temperature regulation
 * fixed by:
 * * automatic
 */
/datum/mecha_fault/temperature_control
	name = "thermal controller instability"
	desc = "The exosuit's thermal controller is malfunctioning."

/datum/mecha_fault/temperature_control/on_tick(obj/vehicle/sealed/mecha/mech, stacks)
	. = ..()
