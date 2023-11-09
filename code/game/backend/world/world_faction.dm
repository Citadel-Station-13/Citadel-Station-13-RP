//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * a faction in the in-game universe
 */
/datum/world_faction
	abstract_type = /datum/world_faction

	/// name
	var/name
	/// id - must be unique
	var/id

	/// storyteller faction path to init, if any
	var/datum/storyteller_faction/faction_story

	/// locations we're in - set to paths to turn into ids on New()
	var/list/world_location_ids = list(
		/datum/world_location/frontier,
	)

/datum/world_faction/New()
	for(var/i in 1 to length(world_location_ids))
		var/datum/world_location/casted = world_location_ids[i]
		if(!ispath(casted))
			continue
		world_location_ids[i] = initial(casted.id)
