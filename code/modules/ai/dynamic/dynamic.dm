//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Default implementation of dynamic HFSM mob AI.
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
 * This type of AI is, however, entirely unsuitable for very complex planning-tree like AIs
 * employed by /tg/station and others.
 *
 * Tuning:
 * * Intelligence & tuning vars determine how dangerous this is
 * * Most vars are built off of the /mob/living it's built off of automatically.
 * * Cheat flags can be specified - be extremely careful, as these flags tend to make AIs extremely, extremely difficult.
 *
 * Limitations:
 * * As said, this isn't a decision tree system. Complex behaviors should not necessarily use this.
 * * This AI type can only target /atom's. This might sound silly but it's not suitable for 'abstract' /datum AIs; we might need that someday.
 */
/datum/ai_holder/dynamic
	agent_type = /atom/movable

	/// AI state
	/// this does not control if we're moving / anything
	/// this is our 'mind' state
	/// e.g. idle, fleeing, engaged in combat, investigating, etc
	var/state = AI_DYNAMIC_STATE_DISABLED
	/// mode - similar to state but much more general, serves as second order of hierarchy.
	var/mode = AI_DYNAMIC_MODE_DISABLED

#warn impl all

/**
 * called to propagate our state machine's actions.
 */
/datum/ai_holder/dynamic/proc/iterate(cycles)
	if(iterate_special(cycles, mode, state))
		return
	switch(mode)
		if(AI_DYNAMIC_MODE_PASSIVE)
			switch(state)
				if(AI_DYNAMIC_STATE_IDLE)
				if(AI_DYNAMIC_STATE_PATROL)
				if(AI_DYNAMIC_STATE_NAVIGATION)
		if(AI_DYNAMIC_MODE_COMBAT)
			switch(state)
				if(AI_DYNAMIC_STATE_STRAFE)
				if(AI_DYNAMIC_STATE_CQC)
				if(AI_DYNAMIC_STATE_GUARD)
				if(AI_DYNAMIC_STATE_FLEE)
		if(AI_DYNAMIC_MODE_DISABLED)
			// why are we here?

				if(AI_DYNAMIC_STATE_FLEE)
/**
 * called to set our state
 */
/datum/ai_holder/dynamic/proc/set_state(new_state)
	switch(state)
		if(AI_DYNAMIC_STATE_IDLE, AI_DYNAMIC_STATE_PATROL, AI_DYNAMIC_STATE_NAVIGATION)
			mode = AI_DYNAMIC_MODE_PASSIVE
		if(
			AI_DYNAMIC_STATE_STRAFE,
			AI_DYNAMIC_STATE_CQC,
			AI_DYNAMIC_STATE_GUARD,
			AI_DYNAMIC_STATE_FLEE,
		)
			mode = AI_DYNAMIC_MODE_COMBAT
		if(AI_DYNAMIC_STATE_DISABLED)
			mode = AI_DYNAMIC_MODE_DISABLED
		else
			CRASH("attempted to set state to an invalid state")
	state = new_state
	#warn update scheduling
