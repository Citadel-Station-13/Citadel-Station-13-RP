//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Default implementation of dynamic state-machine-like mob AI.
 *
 * Prioritizes maximum efficiency of high-performance combat routines while
 * still providing support for various 'passive' mobs and their functions.
 *
 * General breakdown:
 * * /datum/ai_movement is independently ticked by subsystem
 * * AI subsystem ticks us normally, allowing us to 'think'
 * * 'Actions' run on an optimized callback/ticking system allowing for off-tick actions like shooting/meleeing
 * * Expensive actions like re-targeting are done sparingly.
 *
 * Polaris mob AI, while good, failed to appropriately 'weave' their actions in a way that makes them
 * dangerous. This holder system, on the other hand, can move, think, and act at the same time.
 *
 * AI flags determine how smart / dangerous this is.
 */
/datum/ai_holder/dynamic
	agent_type = /mob/living

	/// AI state
	/// this does not control if we're moving / anything
	/// this is our 'mind' state
	/// e.g. idle, fleeing, engaged in combat, investigating, etc
	var/state = AI_DYNAMIC_STATE_DISABLED
	/// mode - similar to state but much more general
	var/mode = AI_DYNAMIC_MODE_DISABLED

#warn impl all
