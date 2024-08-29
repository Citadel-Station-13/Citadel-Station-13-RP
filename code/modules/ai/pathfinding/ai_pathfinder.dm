
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * AI pathfinding handlers
 *
 * It's okay to cast 'agent' params in procs to the agent_type.
 */
/datum/ai_pathfinder
	abstract_type = /datum/ai_pathfinder
	/// Expected agent type
	var/agent_type = /atom/movable

/**
 * performs a path search for an AI holder
 *
 * @params
 * * agent - thing moving
 * * source - source atom
 * * destination - destination atom
 * * limit - max distance in chebyshev distance
 * * within - stop at x tiles to destination
 * * slack - attempt to path within x tiles of destination if we can't successfully get to it exactly
 */
/datum/ai_pathfinder/proc/search(atom/movable/agent, atom/source, atom/destination, limit, within, slack)
	RETURN_TYPE(/datum/ai_pathing)
	CRASH("abstract proc called")
