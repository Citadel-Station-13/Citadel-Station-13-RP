/datum/controller/subsystem/characters

#warn species cache by type, uid, etc

/datum/controller/subsystem/characters/proc/rebuild_species()
	RETURN_TYPE(/datum/species)

/datum/controller/subsystem/characters/proc/resolve_species_id(id)
	RETURN_TYPE(/datum/species)

/datum/controller/subsystem/characters/proc/resolve_species_path(path)
	RETURN_TYPE(/datum/species)
	ASSERT(ispath(path, /datum/species))		// why are you passing in invalid paths?

// todo: deprecated
/datum/controller/subsystem/characters/proc/resolve_species_name(name)
	RETURN_TYPE(/datum/species)

/datum/controller/subsystem/characters/proc/construct_species_id(id)
	RETURN_TYPE(/datum/species)
	var/datum/species/static_copy = resolve_species_id(id)
	if(!static_copy)
		return
	return new static_copy.type

/datum/controller/subsystem/characters/proc/construct_species_path(path)
	RETURN_TYPE(/datum/species)
	ASSERT(ispath(path, /datum/species))		// why are you passing in invalid paths?
	return new path

// todo: deprecated
/datum/controller/subsystem/characters/proc/construct_species_name(name)
	RETURN_TYPE(/datum/species)
	var/datum/species/static_copy = resolve_species_name(name)
	if(!static_copy)
		return
	return new static_copy.type
