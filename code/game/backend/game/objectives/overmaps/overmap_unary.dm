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

/datum/game_objective/overmap_unary/New(parent)
	if(!isnull(parent))
		src.parent = parent
	..()

#warn impl

/**
 * go to a specific location at some point in the round
 */
/datum/game_objective/overmap_unary/visit_once
	name = "Visit Overmap Location"
	// todo: multiple overmaps
	#warn impl

/datum/game_objective/overmap_unary/visit_once/check_completion()
	. = ..()
	#warn impl

/datum/game_objective/overmap_unary/visit_once/build_task()
	#warn impl

/datum/game_objective/overmap_unary/visit_once/build_explanation()
	#warn impl

/**
 * end the round at a specific location
 */
/datum/game_objective/overmap_unary/end_at
	name = "End Round at Overmap Location"
	// todo: multiple overmaps
	#warn impl


/datum/game_objective/overmap_unary/end_at/check_completion()
	. = ..()
	#warn impl

/datum/game_objective/overmap_unary/end_at/build_task()
	#warn impl

/datum/game_objective/overmap_unary/end_at/build_explanation()
	#warn impl
