/// all species by typepath
GLOBAL_LIST_INIT(species_meta, initialize_static_species_cache())

/proc/initialize_static_species_cache()
	. = GLOB.species_meta = list()
	for(var/path in typesof(/datum/species))
		var/datum/species/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		.[path] = S

// todo: optimize
/**
 * Fetches the static species of a given species name
 *
 * **DO NOT EDIT RETURNED DATUM**
 */
/proc/name_static_species_meta(name)
	RETURN_TYPE(/datum/species)
	for(var/id in GLOB.species_meta)
		var/datum/species/S = GLOB.species_meta[id]
		if(S.name == name)
			return S

// todo: optimize
/**
 * Gets the unique static id/type of a species of a given name
 */
/proc/species_type_by_name(name)
	for(var/id in GLOB.species_meta)
		var/datum/species/S = GLOB.species_meta[id]
		if(S.name == name)
			return S.type

/**
 * gets species name by type
 */
/proc/species_name_by_type(type)
	var/datum/species/S = type
	return initial(S.name)

/**
 * Fetches the static species cached globally
 *
 * **DO NOT EDIT RETURNED DATUM**
 */
/proc/get_static_species_meta(path)
	RETURN_TYPE(/datum/species)
	return GLOB.species_meta[path]

/**
 * Fetches all static species in the global cache
 *
 * returns a list, **DO NOT EVER EDIT RETURNED DATUMS**
 */
/proc/all_static_species_meta()
	RETURN_TYPE(/list)
	. = list()
	for(var/path in GLOB.species_meta)
		. += GLOB.species_meta[path]

/**
 * returns all species names
 */
/proc/all_species_names()
	RETURN_TYPE(/list)
	. = list()
	for(var/id in GLOB.species_meta)
		var/datum/species/S = GLOB.species_meta[id]
		. += S.name
