//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * ensure a given entity is in a given location at round end
 */
/datum/game_objective/secure
	abstract_type = /datum/game_objective/secure

	/// target entity
	var/datum/game_entity/target_entity
	/// target location
	var/datum/game_location/target_location

#warn impl



/datum/game_objective/secure/check_completion(datum/game_faction/faction)
	#warn impl
