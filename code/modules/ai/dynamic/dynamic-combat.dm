//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic

/**
 * @params
 * * target - what to attack
 * * where - where they were when we scheduled this
 * * time - reflex speed?
 * * data - implementation-specific; used for weapons planning in subtypes.
 */
/datum/ai_holder/dynamic/proc/schedule_melee_attack(atom/target, turf/where, time, data)

/**
 * @params
 * * target - what to attack
 * * where - where they were when we scheduled this
 * * time - reflex speed?
 * * data - implementation-specific; used for weapons planning in subtypes.
 * * aim - force a specific AI_DYNAMIC_AIM_* value
 */
/datum/ai_holder/dynamic/proc/schedule_ranged_attack(atom/target, turf/where, time, data, aim)

#warn impl
