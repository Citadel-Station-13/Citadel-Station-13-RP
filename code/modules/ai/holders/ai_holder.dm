//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * AI holders
 *
 * Generic AI holders that can bind to the /movable level
 *
 * Most, however, are probably on /mob.
 *
 * Base API:
 * * Movement API allows registering on the movement subsystem, as well as efficient, variable-length 're-schedule' delays.
 * * Ticking API allows registering variable-length ticking loops on the subsystem, with automatic support for staggered ticking.
 * * Pathfinding API allows using various pathfinding datums to perform pathfinding. Please use it instead of raw calls for timekeeping purposes.
 * * Scheduling API allows for efficiently scheduling short-term callbacks to execute on the holder.
 * * Standard hooks are used to react to events like attacks.
 *
 * Base features:
 * * base /datum/ai_holder, meant for movable atoms; usually this is however, for mobs and certain objs.
 * * base /datum/ai_lexicon, meant to hold say-vocabulary. datums are usually globally cached.
 * * base /datum/ai_network, meant to stitch multiple AIs together.
 * * base /datum/ai_pathing, meant to encapsulate pathfinding results
 * * base /datum/ai_patrol(_step), meant to be a holder-agnostic way of encapsulating a patrol route.
 * todo: docs on targeting/etc.
 *
 * Limitations
 * * Right now, these can only bind to a /movable, not a /datum. There's little need to have /datum level AI. Yet.
 */
/datum/ai_holder
	/// movable we are bound to
	var/atom/movable/agent
	/// expected type of movable to bind to
	var/agent_type = /atom/movable
	/// cheat flags
	var/ai_cheat_flags = NONE
	/// personality flags
	var/ai_personality_flags = NONE
	/// intelligence
	var/intelligence = AI_INTELLIGENCE_ADVANCED

/datum/ai_holder/New(atom/movable/agent)
	set_agent(agent)

/datum/ai_holder/Destroy()
	stop_ticking()
	set_agent(null)
	return ..()

/**
 * sets our agent to something
 */
/datum/ai_holder/proc/set_agent(atom/movable/agent, imprint = TRUE)
	if(src.agent)
		unregister_agent(src.agent)
	src.agent = agent
	if(!agent)
		return
	if(imprint)
		#warn impl

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
 * Sets all cached variables from an agent
 */
/datum/ai_holder/proc/imprint_from_agent(atom/movable/agent)
	return
