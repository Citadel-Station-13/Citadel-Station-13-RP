//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * AI pathfinding handlers
 *
 * It's okay to cast 'agent' params in procs to the agent_type.
 */
/datum/ai_pathfinder
	/// Expected agent type
	var/agent_type = /atom/movable
