//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * AI controller network.
 *
 * Holders form into networks during cooperative maneuvers.
 *
 * The network stores relevant shared data.
 */
/datum/ai_network
	/// agents under our control
	/// ais in this can be disabled; those won't be touched
	/// but they'll still be 'under our control'
	var/list/datum/ai_holder/agents = list()

#warn impl
