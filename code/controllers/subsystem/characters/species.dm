/datum/controller/subsystem/characters
	/// species by id
	var/list/species_lookup
	/// species by type
	var/list/species_paths
	/// species by name
	var/list/species_names
	/// playable species - names
	var/list/whitelisted_species
	/// whitelisted species - names
	var/list/playable_species

#warn species cache by type, uid, etc

/datum/controller/subsystem/characters/proc/rebuild_species()
	species_lookup = list()
	species_paths = list()
	species_names = list()
	playable_species = list()
	whitelisted_species = list()
	for(var/path in subtypesof(/datum/species))
		var/datum/species/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(species_lookup[S.uid])
			stack_trace("species id collision on [S.id] on [path]")
			continue
		if(species_names[S.name])
			stack_trace("species name collision on [S.name] on [path]")
			continue
		species_lookup[S.uid] = S
		species_names[S.name] = S
		species_paths[path] = S

		if(S.spawn_flags & SPECIES_IS_WHITELISTED)
			whitelisted_species += S.name
		if(!(S.spawn_flags & SPECIES_IS_RESTRICTED))
			playable_species += S.name

/datum/controller/subsystem/characters/proc/resolve_species(id_path_name)
	RETURN_TYPE(/datum/species)
	if(ispath(id_path_name))
		return species_paths[id_path_name]
	return species_lookup[id_path_name] || species_names[id_path_name]

/datum/controller/subsystem/characters/proc/resolve_species_id(id)
	RETURN_TYPE(/datum/species)
	return species_lookup[id]

/datum/controller/subsystem/characters/proc/resolve_species_path(path)
	RETURN_TYPE(/datum/species)
	ASSERT(ispath(path, /datum/species))		// why are you passing in invalid paths?
	return species_paths[path]

// todo: deprecated kinda - most of these uses should just be id
/datum/controller/subsystem/characters/proc/resolve_species_name(name)
	RETURN_TYPE(/datum/species)
	return species_names[name]

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

// todo: deprecated
/datum/controller/subsystme/characters/proc/all_static_species_meta()
	RETURN_TYPE(/list)
	. = list()
	for(var/path in species_paths)
		. += species_paths[path]

/datum/controller/subsystem/characters/proc/all_species_names()
	RETURN_TYPE(/list)
	. = list()
	for(var/name in species_names)
		. += name
