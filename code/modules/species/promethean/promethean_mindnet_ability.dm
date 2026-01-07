//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

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
/datum/promethean_mindnet_ability
	var/name = "???"
	var/desc = "Do something at the targeted mind."

	/// attunement required for this to work if they cooperate with the action
	var/attunement_cooperative_threshold = INFINITY
	/// attunement required for this to work without them needing any input
	var/attunement_forced_threshold = INFINITY

	/// the target can sense a cooperative attempt even while unconsciuos
	var/can_be_cooperated_while_unconscious = FALSE

/datum/promethean_mindnet_ability/proc/ui_mindnet_ability_data()
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
/datum/promethean_mindnet_ability/proc/run(datum/event_args/actor/actor, datum/promethean_mindnet/mindnet)
	SHOULD_NOT_OVERRIDE(TRUE)

	on_run(actor, mindnet)
	#warn impl

/**
 * * This can sleep.
 */
/datum/promethean_mindnet_ability/proc/on_run(datum/event_args/actor/actor, datum/promethean_mindnet/mindnet)
	SHOULD_CALL_PARENT(TRUE)


	#warn impl

/datum/promethean_mindnet_ability/ping
	name = "Ping"
	desc = "Ping the targeted mind, ascertaining if they sense you and \
	where they are."

/datum/promethean_mindnet_ability/commune
	name = "Commune"
	desc = "Send a message to a targeted mind, potentially receiving their thoughts \
	back towards you."

/datum/promethean_mindnet_ability/health_scan
	name = "Probe"
	desc = "Attempt to sense the biological status of a mind's body."

/datum/promethean_mindnet_ability/mindlink
	name = "Mindlink"
	desc = "Imprint your neural patterns on this mind, creating a more lasting attunement."

#warn impl
