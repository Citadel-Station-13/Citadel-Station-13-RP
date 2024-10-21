//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * ensure a given entity is in a given location at round end
 */
/datum/game_objective/secure
	name = "Secure"
	abstract_type = /datum/game_objective/secure

	/// target entity
	var/datum/game_entity/target_entity
	/// target location
	var/datum/game_location/target_location

/datum/game_objective/secure/New(entity, location)
	if(!isnull(entity))
		target_entity = entity
	if(!isnull(location))
		target_location = location
	..()

#warn impl



/datum/game_objective/secure/check_completion(datum/game_faction/faction)
	. = ..()
	#warn impl

/datum/game_objective/secure/build_task()
	#warn impl

/datum/game_objective/secure/build_explanation()
	#warn impl
