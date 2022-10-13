/datum/controller/subsystem/characters

#warn species cache by type, uid, etc

/datum/controller/subsystem/characters/proc/rebuild_species()
	RETURN_TYPE(/datum/species)

/datum/controller/subsystem/characters/proc/resolve_species_id(id)
	RETURN_TYPE(/datum/species)

/datum/controller/subsystem/characters/proc/resolve_species_path(path)
	RETURN_TYPE(/datum/species)

// todo: deprecated
/datum/controller/subsystem/characters/proc/resolve_species_name(name)
	RETURN_TYPE(/datum/species)
