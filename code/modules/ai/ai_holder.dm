//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * AI holders
 *
 * Generic AI holders that can bind to the /movable level
 *
 * Most, however, are probably on /mob.
 */
/datum/ai_holder
	/// movable we are bound to
	var/atom/movable/agent
	/// expected type of movable to bind to
	var/agent_type = /atom/movable

/datum/ai_holder/Destroy()
	if(!isnull(agent))
		unregister_agent(agent)
		if(agent.ai_holder == src)
			agent.ai_holder = null
	stop_ticking()
	return ..()

/**
 * sets our agent to something
 */
/datum/ai_holder/proc/set_agent(atom/movable/agent, imprint = TRUE)
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
