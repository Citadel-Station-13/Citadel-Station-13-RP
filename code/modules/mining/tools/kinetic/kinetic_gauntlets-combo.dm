//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_DATUM_INIT(kinetic_gauntlet_melee_combo, /datum/combo_set/melee, new /datum/combo_set/melee/intent_based/kinetic_gauntlets)

/datum/combo_set/melee/intent_based/kinetic_gauntlets
	expected_combo_type = /datum/combo/melee/intent_based/kinetic_gauntlets
	combos = list(
		/datum/combo/melee/intent_based/kinetic_gauntlets/slam,
		/datum/combo/melee/intent_based/kinetic_gauntlets/concuss,
		/datum/combo/melee/intent_based/kinetic_gauntlets/detonate,
	)

/datum/combo/melee/intent_based/kinetic_gauntlets
	abstract_type = /datum/combo/melee/intent_based/kinetic_gauntlets

	damage_force = 20
	damage_tier = 4
	damage_mode = DAMAGE_MODE_ABLATING
	damage_type = DAMAGE_TYPE_BRUTE
	damage_flag = ARMOR_BOMB

	default_feedback_sfx = 'sound/weapons/kenetic_accel.ogg'
	default_feedback_vfx = /obj/effect/temp_visual/kinetic_blast

/datum/combo/melee/intent_based/kinetic_gauntlets/slam
	name = "slam"
	desc = "Slam a target away."
	keys = list(
		INTENT_DISARM,
		INTENT_DISARM,
		INTENT_HARM,
	)
	default_feedback_message = SPAN_DANGER_CONST("%%ATTACKER%% rapidly strikes %%TARGET%% and sends them flying!")
	damage_force = 36

/datum/combo/melee/intent_based/kinetic_gauntlets/slam/inflict_on(atom/target, target_zone, mob/attacker, datum/event_args/actor/clickchain/clickchain)
	. = ..()
	. = TRUE

	if(!isliving(target))
		return
	var/mob/living/living_target = target

	if(living_target.anchored)
		return
	// todo: a 'forcefully push' proc that respects move force, which does need to be reworked at some point
	step_away(living_target, attacker)
	if(prob(50))
		step_away(living_target, attacker)
		if(prob(35))
			step_away(living_target, attacker)
	living_target.afflict_knockdown(2 SECONDS)
	living_target.afflict_root(0.2 SECONDS)
	living_target.adjustHalLoss(40)

/datum/combo/melee/intent_based/kinetic_gauntlets/concuss
	name = "concuss"
	desc = "Disrupt a target, making it harder for them to move and react."
	keys = list(
		INTENT_DISARM,
		INTENT_HARM,
		INTENT_DISARM,
	)

	damage_force = 36
	default_feedback_sfx = 'sound/weapons/resonator_blast.ogg'
	default_feedback_message = SPAN_DANGER_CONST("%%ATTACKER%% places three precision strikes %%TARGET%%, causing their destabilization field to collapse into a concussive blast!")

/datum/combo/melee/intent_based/kinetic_gauntlets/concuss/inflict_on(atom/target, target_zone, mob/attacker, datum/event_args/actor/clickchain/clickchain)
	. = ..()
	. = TRUE

	if(!isliving(target))
		return
	var/mob/living/living_target = target

	living_target.afflict_stagger(4.5 SECONDS)
	living_target.afflict_daze(0.75 SECONDS)
	living_target.adjustHalLoss(40)

/datum/combo/melee/intent_based/kinetic_gauntlets/detonate
	name = "detonate"
	desc = "Detonate a kinetic mark on a target with full intensity, in lieu of any special effects."
	keys = list(
		INTENT_HARM,
		INTENT_HARM,
		INTENT_HARM,
	)

	damage_force = 72
	default_feedback_message = SPAN_DANGER_CONST("%%ATTACKER%% slams %%ATTACKER_P_THEIR%% gauntlet into %%TARGET%%, violently detonating their destabilization field!")
