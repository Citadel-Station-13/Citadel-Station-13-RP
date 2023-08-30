//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * AI movement handlers
 *
 * Used on arbitray /atom/movables
 *
 * It's okay to cast proc 'agent' params to the agent_type.
 */
/datum/ai_movement
	/// expected agent type
	var/agent_type = /atom/movable
	/// movement delay; this should be set after any move if needed because
	/// this is used to determine when to schedule the next move
	var/movement_delay = 1

/**
 * move in a certain direction
 *
 * @return time of next move
 */
/datum/ai_movement/proc/move_in_dir(atom/movable/agent, dir)
	return step(agent, dir)
