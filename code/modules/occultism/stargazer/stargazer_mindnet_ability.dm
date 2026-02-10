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
	/// * only used by default for default-targeted-runs
	var/attunement_cooperative_threshold = INFINITY
	/// attunement required for this to work without needing any input from them
	/// * only used by default for default-targeted-runs
	var/attunement_forced_threshold = INFINITY

	/// the target can sense a cooperative attempt even while unconsciuos
	var/can_be_cooperated_while_unconscious = FALSE

	/// enforce distance; active if nonnull, 0 is same tile
	var/enforce_distance_maximum
	/// enforce reachability; TRUE / FALSE
	var/enforce_reachability = FALSE
	/// enforce pulling; TRUE / FALSE
	var/enforce_pulling = FALSE
	/// enforce grab state; active if nonnull, uses GRAB_* state defines
	var/enforce_grab_state

	/// Cooldown for a given target.
	/// * No more than one exec-dedupe key will ever be allowed to run by default, but run() is not throttled by that.
	var/cooldown_global = 0 SECONDS
	/// Cooldown for a given target.
	/// * No more than one exec-dedupe key will ever be allowed to run by default, but run() is not throttled by that.
	var/cooldown_for_given_target = 0 SECONDS

	#warn impl
	/// emit default feedback message
	var/default_feedback_emit = TRUE
	/// default feedback message
	/// * %%USER%% will be replaced
	/// * %%TARGET%% will be replaced, with the target or 'something' if they're not visible.
	var/default_feedback_visible = ACTION_DESCRIPTOR_FOR_EXAMINE_FMTSTR_CONST("USER", "TARGET")

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

/datum/stargazer_mindnet_ability/proc/put_on_global_cooldown(datum/stargazer_mindnet_exec/exec, for_how_long)
	#warn impl

/datum/stargazer_mindnet_ability/proc/put_on_target_cooldown(datum/stargazer_mindnet_exec/exec, for_how_long, datum/mind/target)
	#warn impl

/**
 * * This will sleep.
 * * You are responsible for making the exec datum.
 */
/datum/stargazer_mindnet_ability/proc/run(datum/stargazer_mindnet_exec/exec)
	SHOULD_NOT_OVERRIDE(TRUE)

	#warn log this shit
	// TODO: find a sane way to tell osbervers. deadchat mains may have no rights, but admin ghosts exist.
	on_run(exec)

	if(cooldown_global)
		put_on_global_cooldown(exec, cooldown_global)
	if(cooldown_for_given_target && exec.target_mind)
		put_on_target_cooldown(exec, cooldown_for_given_target, exec.target_mind)

/**
 * * This will sleep.
 */
/datum/stargazer_mindnet_ability/proc/on_run(datum/stargazer_mindnet_exec/exec)
	default_run_targeted(exec)

/**
 * * This will sleep.
 */
/datum/stargazer_mindnet_ability/proc/default_run_targeted(datum/stargazer_mindnet_exec/exec)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!exec.target_mind)
		return FALSE
	if(!default_pre_run(exec))
		return FALSE
	#warn put this in invoke logic
	// var/dedupe_key = exec_dedupe_key(actor, mindnet, target, blackboard)
	// if(mindnet.executing[dedupe_key])
	// 	actor.chat_feedback(SPAN_WARNING("You're already invoking '[src]' in a similar manner."))
	// 	return

	if(!default_pre_prompt(exec))
		return FALSE
	exec.run_prompt()
	if(!default_post_prompt(exec))
		return FALSE
	return TRUE

/**
 * Called before anything happens, including exec dedupe / start.
 * * This may sleep.
 * @return FALSE to abort.
 */
/datum/stargazer_mindnet_ability/proc/default_pre_run(datum/stargazer_mindnet_exec/exec)
	return TRUE

/**
 * Called right before execution is passed to the exec datum for prompting
 * * This may sleep.
 * @return FALSE to abort.
 */
/datum/stargazer_mindnet_ability/proc/default_pre_prompt(datum/stargazer_mindnet_exec/exec)
	return TRUE

/**
 * Called right after the prompt is answered or times out
 * * This may sleep.
 * @return FALSE to abort.
 */
/datum/stargazer_mindnet_ability/proc/default_post_prompt(datum/stargazer_mindnet_exec/exec)
	return TRUE

/**
 * Returns our execution dedupe key; the user will not be allowed to invoke two abilities
 * simutaneously with the same key until one exits.
 * * Target is nullable.
 */
/datum/stargazer_mindnet_ability/proc/exec_dedupe_key(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, datum/mind/target)
	SHOULD_NOT_SLEEP(TRUE)
	if(target)
		return "[id]-[ref(target.get_mind_ref())]"
	return "[id]"

/datum/stargazer_mindnet_ability/proc/check_target_valid(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, datum/mind/target, silent)
	SHOULD_NOT_SLEEP(TRUE)
	return isliving(target.get_active_game_mob())

/datum/stargazer_mindnet_ability/proc/check_requirements_met(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, datum/mind/target, silent)
	SHOULD_NOT_SLEEP(TRUE)

#warn impl
