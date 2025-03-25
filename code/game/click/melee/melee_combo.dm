//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/combo/melee
	/// name
	var/name = "unnamed attack"
	/// description
	var/desc = "An attack of some kind."

	var/damage_force = 0
	var/damage_type = DAMAGE_TYPE_BRUTE
	var/damage_tier = 0
	var/damage_flag = ARMOR_MELEE
	var/damage_mode = NONE

/**
 * * Don't override this, override [inflict_on()]
 *
 * @params
 * * target - target
 * * target_zone - (optional) target zone
 * * attacker - (optional) attacking mob
 * * clickchain - (optional) clickchain data
 *
 * @return TRUE to override normal attack style / weapon damage (this is a request, the weapon/style can override this)
 */
/datum/combo/melee/proc/inflict(atom/target, target_zone, mob/attacker, datum/event_args/actor/clickchain/clickchain)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = inflict_on(target, target_zone, attacker, clickchain)
	clickchain.data[ACTOR_DATA_COMBO_LOG] = "[src]"

/**
 * * Override this, not [inflict()].
 *
 * @params
 * * target - target
 * * target_zone - (optional) target zone
 * * attacker - (optional) attacking mob
 * * clickchain - (optional) clickchain data
 *
 * @return TRUE to override normal attack style / weapon damage (this is a request, the weapon/style can override this)
 */
/datum/combo/melee/proc/inflict_on(atom/target, target_zone, mob/attacker, datum/event_args/actor/clickchain/clickchain)
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(damage_force)
		target.inflict_on(
			damage_force,
			damage_type,
			damage_tier,
			damage_flag,
			damage_mode,
			ATTACK_TYPE_MELEE,
			hit_zone = target_zone,
			clickchain = clickchain,
		)
	return TRUE

/datum/combo/melee/intent_based
