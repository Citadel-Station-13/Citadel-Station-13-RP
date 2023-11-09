//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * overmap objectives
 * targets a single overmap ship as the 'anchor'
 *
 * technically, you could composit some of these with other objectives and the location system,
 * but it's cleaner and more feature-rich to use this.
 */
/datum/game_objective/overmap_unary
	/// the target overmap entity
	var/obj/overmap/entity/parent

#warn impl

/**
 * go to a specific location at some point in the round
 */
/datum/game_objective/overmap_unary/visit_once


/datum/game_objective/overmap_unary/visit_once/check_completion(datum/game_faction/faction)
	#warn impl

/**
 * end the round at a specific location
 */
/datum/game_objective/overmap_unary/end_at

/datum/game_objective/overmap_unary/end_at/check_completion(datum/game_faction/faction)
	#warn impl
