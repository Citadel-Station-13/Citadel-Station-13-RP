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

#warn impl all
