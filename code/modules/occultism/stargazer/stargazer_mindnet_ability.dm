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
	/// unique id for uis
	var/id
	var/name = "???"
	var/desc = "Do something at the targeted mind."

	/// attunement required for this to work if they cooperate with the action
	var/attunement_cooperative_threshold = INFINITY
	/// attunement required for this to work without them needing any input
	var/attunement_forced_threshold = INFINITY

	/// the target can sense a cooperative attempt even while unconsciuos
	var/can_be_cooperated_while_unconscious = FALSE

/datum/stargazer_mindnet_ability/proc/ui_mindnet_ability_data()
	return list(
		"name" = name,
		"desc" = desc,
		"attunementCooperativeThreshold" = attunement_cooperative_threshold,
		"attunementForcedThreshold" = attunement_forced_threshold,
		"cooperateWhileUnconscious" = can_be_cooperated_while_unconscious,
	)

/**
 * * This can sleep.
 */
/datum/stargazer_mindnet_ability/proc/run(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet)
	SHOULD_NOT_OVERRIDE(TRUE)

	on_run(actor, mindnet)
	#warn impl

/**
 * * This can sleep.
 */
/datum/stargazer_mindnet_ability/proc/on_run(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet)
	SHOULD_CALL_PARENT(TRUE)


	#warn impl

#warn impl
