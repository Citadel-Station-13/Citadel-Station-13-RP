//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * driver struct
 *
 * this is the mode the storyteller runs in
 */
/datum/storyteller_driver
	/// which 'point of view' we're centered on
	/// this faction is considered the primary faciton
	var/primary_faction_id
	/// the IDs of the world locations we're in
	/// this determines who's around
	//  todo: in the future, overmaps might override location. how to deal with that?
	var/list/world_location_ids



#warn impl

/datum/storyteller_driver/proc/perform_intercept(datum/storyteller_state/state)
