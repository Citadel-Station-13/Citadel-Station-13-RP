//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/combo/melee
	/// name
	var/name = "unnamed attack"
	/// description
	var/desc = "An attack of some kind."

	var/damage_force = 0
	var/damage_tier = 0
	var/damage_flag = ARMOR_MELEE
	var/damage_mode = NONE

/**
 * @params
 * * target - target
 * * target_zone - (optional) target zone
 * * attacker - (optional) attacking mob
 * * actor - (optional) actor data for feedback
 */
/datum/combo/melee/proc/inflict(atom/target, target_zone, mob/attacker, datum/event_args/actor/actor)
	inflict_damage_instance(target, target_zone, attacker, actor)
	actor.data[ACTOR_DATA_COMBO_LOG]
	#warn impl

/**
 * @params
 * * target - target
 * * target_zone - (optional) target zone
 * * attacker - (optional) attacking mob
 * * actor - (optional) actor data for feedback
 */
/datum/combo/melee/proc/inflict_damage_instance(atom/target, target_zone, mob/attacker, datum/event_args/actor/actor)
	#warn impl

/datum/combo/melee/intent_based
