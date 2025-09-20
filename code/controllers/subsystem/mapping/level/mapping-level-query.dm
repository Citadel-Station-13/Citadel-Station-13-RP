//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Attributes *//

/**
 * Returns the z indices of levels with a certain attribute set to a certain value
 */
/datum/controller/subsystem/mapping/proc/levels_by_attribute(key, value)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/map_level/L as anything in ordered_levels)
		if(L.get_attribute(key) == value)
			. += L.z_index

//* Traits *//

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
/datum/controller/subsystem/mapping/proc/levels_by_all_traits(list/traits)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/map_level/L as anything in ordered_levels)
		if(!length(traits - L.traits))
			. += L.z_index
