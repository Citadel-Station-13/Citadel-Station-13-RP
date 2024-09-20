//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * Returns if a level is reasonably accessible by players.
 */
/datum/controller/subsystem/mapping/proc/is_valid_player_level(z)
	return loaded_station.use_overmap ? !!SSovermaps.location_lookup[z] : TRUE
