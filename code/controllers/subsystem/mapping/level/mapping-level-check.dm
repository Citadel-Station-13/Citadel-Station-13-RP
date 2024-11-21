//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Returns if a level is reasonably accessible by players.
 */
/datum/controller/subsystem/mapping/proc/level_check_is_player(z)
	return loaded_station.use_overmap ? !!SSovermaps.location_enclosed_levels[z] : TRUE
