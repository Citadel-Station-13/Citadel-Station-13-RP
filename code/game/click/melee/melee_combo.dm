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

	/// a single, or a list of valid VFX to render by default
	///
	/// Supported VFX types:
	/// * a /obj/effect/temp_visual path
	var/default_feedback_vfx
	/// a single, or a list of get_sfx-resolveable sound effects to play by default
	var/default_feedback_sfx
	/// templateable message
	/// * automatic message emit will not happen if this isn't set, even if self/audible are.
	///
	/// accepted vars:
	/// * "%%ATTACKER%%" - the person attacking
	/// * "%%ATTACKER_P_THEIR%%" - pronoun for 'their' for attacker
	/// * "%%TARGET%%" - the target
	var/default_feedback_message
	/// templateable message
	///
	/// accepted vars:
	/// * "%%ATTACKER%%" - the person attacking
	/// * "%%ATTACKER_P_THEIR%%" - pronoun for 'their' for attacker
	/// * "%%TARGET%%" - the target
	var/default_feedback_message_self
	/// templateable message
	///
	/// accepted vars:
	/// * "%%ATTACKER%%" - the person attacking
	/// * "%%ATTACKER_P_THEIR%%" - pronoun for 'their' for attacker
	/// * "%%TARGET%%" - the target
	var/default_feedback_message_audible

/datum/combo/melee/New()
	// validate vfx
	if(default_feedback_vfx)
		for(var/validating_vfx in islist(default_feedback_vfx) ? default_feedback_vfx : list(default_feedback_vfx))
			if(ispath(validating_vfx, /obj/effect/temp_visual))
			else
				stack_trace("invalid vfx [validating_vfx] on [src] ([type]), vfx cleared")
				default_feedback_vfx = null
				break

/**
 * * Don't override this, override [inflict_on()]
 *
 * @params
 * * target - target
 * * target_zone - (optional) target zone
 * * attacker - (optional) attacking mob
 * * clickchain - (optional) clickchain data
 * * skip_fx - do not do default sfx/message/vfx
 *
 * @return TRUE to override normal attack style / weapon damage (this is a request, the weapon/style can override this)
 */
/datum/combo/melee/proc/inflict(atom/target, target_zone, mob/attacker, datum/event_args/actor/clickchain/clickchain, skip_fx)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	clickchain?.data[ACTOR_DATA_COMBO_LOG] = "[src]"
	. = inflict_on(target, target_zone, attacker, clickchain)
	if(!skip_fx)
		var/list/fx_msg_args = list(
			"ATTACKER" = "[attacker]",
			"ATTACKER_P_THEIR" = "[attacker.p_their()]",
			"TARGET" = "[target]",
		)
		if(default_feedback_sfx)
			playsound(
				attacker,
				islist(default_feedback_sfx) ? pick(default_feedback_sfx) : default_feedback_sfx,
				75,
				TRUE,
			)
		if(default_feedback_message)
			attacker.visible_message(
				string_format(default_feedback_message, fx_msg_args),
				string_format(default_feedback_message_audible, fx_msg_args),
				string_format(default_feedback_message_self, fx_msg_args),
			)
		if(default_feedback_vfx)
			var/picked_vfx = islist(default_feedback_vfx) ? pick(default_feedback_vfx) : default_feedback_vfx
			if(ispath(picked_vfx, /obj/effect/temp_visual))
				new picked_vfx(target.loc)

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
		clickchain?.data[ACTOR_DATA_COMBO_DAMAGE_LOG] = target.run_damage_instance(
			damage_force,
			damage_type,
			damage_tier,
			damage_flag,
			damage_mode,
			ATTACK_TYPE_MELEE,
			clickchain,
			hit_zone = target_zone,
		)
	return TRUE

/**
 * Intent-based combos
 */
/datum/combo/melee/intent_based
