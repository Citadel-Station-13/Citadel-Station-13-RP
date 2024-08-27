
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * AI holders
 *
 * Generic AI holders that can bind to the /movable level
 *
 * Most, however, are probably on /mob.
 *
 * Base API:
 * * Interface API is a standard set of procs called on the AI from external systems to impart control or directives.
 *   An AI subtype can implement them to enable functionality.
 * * Hooks API is a standard set of procs called on the holder by the movable agent
 *   to react to events like attacks or hear/say, etc.
 * * Movement API allows registering on the movement subsystem, as well as efficient, variable-length 're-schedule' delays.
 * * Ticking API allows registering variable-length ticking loops on the subsystem, with automatic support for staggered ticking.
 * * Pathfinding API allows using various pathfinding datums to perform pathfinding. Please use it instead of raw calls for timekeeping purposes.
 * * Scheduling API allows for efficiently scheduling short-term callbacks to execute on the holder.
 *
 * Base features:
 * * base /datum/ai_holder, meant for movable atoms; usually this is however, for mobs and certain objs.
 * * base /datum/ai_lexicon, meant to hold say-vocabulary. datums are usually globally cached.
 * * base /datum/ai_network, meant to stitch multiple AIs together.
 * * base /datum/ai_pathing, meant to encapsulate pathfinding results
 * * base /datum/ai_patrol(_step), meant to be a holder-agnostic way of encapsulating a patrol route.
 * * base /datum/ai_personality, meant to encapsulate personality tuning.
 * todo: docs on targeting/etc.
 *
 * Limitations
 * * Right now, these can only bind to a /movable, not a /datum. There's little need to have /datum level AI. Yet.
 *
 * Notes:
 * * When implementing an ai_holder, feel free to cast all 'agent' accesses into the real type that it is, as opposed to just /atom/movable.
 */
/datum/ai_holder
	/// movable we are bound to
	var/atom/movable/agent
	/// expected type of movable to bind to
	var/agent_type = /atom/movable
	/// disabled
	/// this is what actually tells the scheduler to drop our scheduled callbacks
	/// make sure to set this as needed in your implementation.
	var/disabled = FALSE

/datum/ai_holder/New(atom/movable/agent)
	ASSERT(!agent.ai_holder)
	set_agent(agent)
	if(!disabled)
		on_enable()
	else
		on_disable()

/datum/ai_holder/Destroy()
	stop_ticking()
	stop_moving()
	set_agent(null)
	disabled = TRUE
	return ..()

/**
 * sets our agent to something
 */
/datum/ai_holder/proc/set_agent(atom/movable/agent)
	if(src.agent)
		unregister_agent(src.agent)
	src.agent = agent
	if(!agent)
		return

/**
 * bind to agent
 */
/datum/ai_holder/proc/register_agent(atom/movable/agent)
	return

/**
 * unbind from agent
 */
/datum/ai_holder/proc/unregister_agent(atom/movable/agent)
	return

/**
 * set if we're enabled
 */
/datum/ai_holder/proc/set_enabled(value)
	if(disabled == !value)
		return
	disabled = !value
	if(disabled)
		on_disable()
	else
		on_enable()

/**
 * called on disable
 *
 * * called once on init if we default to disabled
 * * this should be idempotent
 * * ticking will automatically be dropped on disable
 */
/datum/ai_holder/proc/on_disable()
	SHOULD_CALL_PARENT(TRUE)
	stop_ticking()

/**
 * called on re-enable
 *
 * * called once on init if we default to enabled
 * * this should be idempotent
 * * you should resume ticking here
 */
/datum/ai_holder/proc/on_enable()
	SHOULD_CALL_PARENT(TRUE)
