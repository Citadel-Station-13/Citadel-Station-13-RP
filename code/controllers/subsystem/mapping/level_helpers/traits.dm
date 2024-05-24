//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Checks if a z level has a trait
 */
/datum/controller/subsystem/mapping/proc/level_trait(z, trait)
	var/datum/map_level/L = ordered_levels[z]
	return L.has_trait(trait)

/**
 * Checks if a z level has any of these traits
 */
/datum/controller/subsystem/mapping/proc/level_trait_any(z, list/traits)
	var/datum/map_level/L = ordered_levels[z]
	return !!length(L.traits & traits)

/**
 * Checks if a z level has all of these traits
 */
/datum/controller/subsystem/mapping/proc/level_traits_all(z, list/traits)
	var/datum/map_level/L = ordered_levels[z]
	return !length(traits - L.traits)

/**
 * Returns a list of z indices with a trait
 */
/datum/controller/subsystem/mapping/proc/levels_by_trait(trait)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/map_level/L as anything in ordered_levels)
		if(L.has_trait(trait))
			. += L.z_index

/**
 * Returns a list of z indices with any of these traits
 */
/datum/controller/subsystem/mapping/proc/levels_by_any_trait(list/traits)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/map_level/L as anything in ordered_levels)
		if(length(L.traits & traits))
			. += L.z_index

/**
 * Returns a list of z indices with any of these traits
 */
/datum/controller/subsystem/mapping/proc/levels_by_all_trait(list/traits)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/map_level/L as anything in ordered_levels)
		if(!length(traits - L.traits))
			. += L.z_index
