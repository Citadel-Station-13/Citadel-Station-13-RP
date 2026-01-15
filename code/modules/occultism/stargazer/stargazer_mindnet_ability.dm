//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Datumized abilities; these get individual TGUI buttons in the mindnet panel.
 *
 * Each ability has thresholds for cooperative (target allows the mind intrusion)
 * and uncooperative (it just works regardless)
 *
 * Abilities may sleep while running, but should avoid doing so for long amounts of time.
 *
 * Sleeping abilities will block GC as they hold backreferences to the invoking mindnet
 * as well as the target mob.
 */
/datum/stargazer_mindnet_ability
	/// ability ID
	/// * Two abilities may not have the same ID on a mindnet datum.
	var/id
	var/name = "???"
	var/desc = "Do something at the targeted mind."
	/// targeted at minds
	var/targeted

	/// attunement required for this to work if they cooperate with the action
	var/attunement_cooperative_threshold = INFINITY
	/// attunement required for this to work without them needing any input
	var/attunement_forced_threshold = INFINITY

	/// the target can sense a cooperative attempt even while unconsciuos
	var/can_be_cooperated_while_unconscious = FALSE

	/// enforce distance
	var/enforce_distance_maximum
	/// enforce reachability
	var/enforce_reachability
	/// enforce pulling
	var/enforce_pulling
	/// enforce grab state
	var/enforce_grab_state

	#warn impl
	/// emit default feedback message
	var/default_feedback_emit = TRUE
	/// default feedback message
	/// * %%USER%% will be replaced
	/// * %%TARGET%% will be replaced, with the target or 'something' if they're not visible.
	var/default_feedback_visible = ACTION_DESCRIPTOR_FMT_FOR_EXAMINE("USER", "TARGET")

	/// default require a do_after
	/// * requirements & attunement will continually be checked.
	/// * this is before the prompt
	var/default_do_after = 0 SECONDS
	var/default_do_after_flags = DO_AFTER_IGNORE_ACTIVE_ITEM | DO_AFTER_IGNORE_TARGET_MOVEMENT

/datum/stargazer_mindnet_ability/proc/ui_mindnet_ability_data()
	return list(
		"name" = name,
		"desc" = desc,
		"attCoopThres" = attunement_cooperative_threshold,
		"attForceThres" = attunement_forced_threshold,
		"cooperateUnconscious" = can_be_cooperated_while_unconscious,
		"targeted" = targeted,
	)

/**
 * * This can sleep.
 */
/datum/stargazer_mindnet_ability/proc/run(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, datum/mind/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	on_run(actor, mindnet)
	#warn impl

/**
 * * This can sleep.
 */
/datum/stargazer_mindnet_ability/proc/on_run(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, datum/mind/target)
	if(target)
		default_run_targeted(actor, mindnet, target)

/datum/stargazer_mindnet_ability/proc/default_run_targeted(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, datum/mind/target)
	var/list/blackboard = list()
	#warn impl

/datum/stargazer_mindnet_ability/proc/default_pre_prompt(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target, datum/stargazer_mindnet_exec/exec)

/datum/stargazer_mindnet_ability/proc/default_post_prompt(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target, datum/stargazer_mindnet_exec/exec)

/**
 * Returns our execution dedupe key; the user will not be allowed to invoke two abilities
 * simutaneously with the same key until one exits.
 */
/datum/stargazer_mindnet_ability/proc/exec_dedupe_key(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target)
	return "[id]"

/datum/stargazer_mindnet_ability/proc/check_target_valid(datum/mind/mind, mob/entity, datum/event_args/actor/actor, silent)

/datum/stargazer_mindnet_ability/proc/check_requirements_met(datum/mind/mind, mob/entity, datum/event_args/actor/actor, silent)

#warn impl
