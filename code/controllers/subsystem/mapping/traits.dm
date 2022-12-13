/datum/controller/subsystem/mapping
	// Can add a trait caching system for fast access later.

/datum/controller/subsystem/mapping/proc/on_trait_add(datum/space_level/level, trait)
	return

/datum/controller/subsystem/mapping/proc/on_trait_del(datum/space_level/level, trait)
	return

/datum/controller/subsystem/mapping/proc/on_attribute_set(datum/space_level/level, attribute, value)
	return

/**
 * Checks if a z level has a trait
 */
/datum/controller/subsystem/mapping/proc/level_trait(z, trait)
	if(z < 1 || z > world.maxz)
		CRASH("Invalid z")
	var/datum/space_level/L = space_levels[z]
	return !!L.traits.Find(trait)

/**
 * Checks if a z level has any of these traits
 */
/datum/controller/subsystem/mapping/proc/level_trait_any(z, list/traits)
	if(z < 1 || z > world.maxz)
		CRASH("Invalid z")
	var/datum/space_level/L = space_levels[z]
	return !!length(L.traits & traits)

/**
 * Checks if a z level has all of these traits
 */
/datum/controller/subsystem/mapping/proc/level_traits_all(z, list/traits)
	if(z < 1 || z > world.maxz)
		CRASH("Invalid z")
	var/datum/space_level/L = space_levels[z]
	return !length(L.traits - traits)

/**
 * Returns a list of z indices with a trait
 */
/datum/controller/subsystem/mapping/proc/levels_by_trait(trait)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(L.traits.Find(trait))
			. += L.z_value

/**
 * Returns a list of z indices with any of these traits
 */
/datum/controller/subsystem/mapping/proc/levels_by_any_trait(list/traits)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(length(L.traits & traits))
			. += L.z_value

/**
 * Returns a list of z indices with any of these traits
 */
/datum/controller/subsystem/mapping/proc/levels_by_all_trait(list/traits)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(!length(L.traits - traits))
			. += L.z_value

/**
 * Returns an attribute of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_attribute(z, key)
	if(z < 1 || z > world.maxz)
		CRASH("Invalid z")
	var/datum/space_level/L = space_levels[z]
	return L.attributes[key]

/**
 * Returns the z indices of levels with a certain attribute set to a certain value
 */
/datum/controller/subsystem/mapping/proc/levels_by_attribute(key, value)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(L.attributes[key] == value)
			. += L.z_value

/**
 * Returns all crosslinked z indices
 */
/datum/controller/subsystem/mapping/proc/crosslinked_levels()
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/space_level/L as anything in space_levels)
		if(L.linkage_mode == Z_LINKAGE_CROSSLINKED)
			. += L.z_value

/**
 * Gets baseturf type of a zlevel
 */
/datum/controller/subsystem/mapping/proc/level_baseturf(z)
	var/datum/space_level/L = space_levels[z]
	return L.baseturf || world.turf

#warn indoors / outdoors airmix, maybe we should cache?
