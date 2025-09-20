//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Accessibility *//

/**
 * Returns if a level is reasonably accessible by players.
 */
/datum/controller/subsystem/mapping/proc/level_is_player_accessible(z)
	return loaded_station.use_overmap ? !!SSovermaps.location_enclosed_levels[z] : TRUE

//* Traits *//

/**
 * Checks if a z level has a trait
 */
/datum/controller/subsystem/mapping/proc/level_has_trait(z, trait)
	var/datum/map_level/L = ordered_levels[z]
	return L.has_trait(trait)

/**
 * Checks if a z level has any of these traits
 */
/datum/controller/subsystem/mapping/proc/level_has_any_trait(z, list/traits)
	var/datum/map_level/L = ordered_levels[z]
	return !!length(L.traits & traits)

/**
 * Checks if a z level has all of these traits
 */
/datum/controller/subsystem/mapping/proc/level_has_all_traits(z, list/traits)
	var/datum/map_level/L = ordered_levels[z]
	return !length(traits - L.traits)

//* Virtualization *//

/**
 * GAME PROC: level_is_virtualized(z)
 *
 * Checks if we should use get_virtual_coords and similar helpers while on this level.
 *
 * This is the case if the level has 'struct coords', which are virtual coordinates
 * placing it at a specific spot on a given map's internal level grid.
 */
/datum/controller/subsystem/mapping/proc/level_is_virtualized(z)
	return ordered_levels[z]?.struct_active
