/datum/controller/subsystem/characters
	/// species by id
	var/list/species_lookup
	/// species by type
	var/list/species_paths
	/// species by name
	var/list/species_names
	// todo: ids
	/// playable species - names
	var/list/whitelisted_species
	// todo: ids
	/// whitelisted species - names
	var/list/playable_species
	// todo: ids
	/// custom species icon bases - names
	var/list/custom_species_bases
	/// default species path
	var/default_species_path = /datum/species/human

/datum/controller/subsystem/characters/proc/rebuild_species()
	species_lookup = list()
	species_paths = list()
	species_names = list()
	playable_species = list()
	whitelisted_species = list()
	custom_species_bases = list()
	var/static/list/blacklisted_icon_ids = list(SPECIES_ID_CUSTOM, SPECIES_ID_PROMETHEAN)
	var/static/list/whitelisted_icon_ids = list(SPECIES_ID_VULPKANIN, SPECIES_ID_XENOMORPH_HUNTER)
	for(var/path in subtypesof(/datum/species))
		var/datum/species/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(species_lookup[S.uid])
			stack_trace("species id collision on [S.uid] on [path]")
			continue
		if(species_names[S.name])
			stack_trace("species name collision on [S.name] on [path]")
			continue
		species_lookup[S.uid] = S
		species_names[S.name] = S
		species_paths[path] = S

		if(S.species_spawn_flags & SPECIES_SPAWN_WHITELISTED)
			whitelisted_species += S.name
		if(!(S.species_spawn_flags & SPECIES_SPAWN_RESTRICTED))
			playable_species += S.name
		if((!(S.species_spawn_flags & (SPECIES_SPAWN_WHITELISTED | SPECIES_SPAWN_RESTRICTED)) && !(S.get_species_id() in blacklisted_icon_ids)) || (S.get_species_id() in whitelisted_icon_ids))
			custom_species_bases += S.name

	tim_sort(species_lookup, /proc/cmp_auto_compare, TRUE)
	tim_sort(species_names, /proc/cmp_auto_compare, TRUE)
	tim_sort(species_lookup, /proc/cmp_auto_compare, TRUE)
	tim_sort(whitelisted_species, /proc/cmp_auto_compare)
	tim_sort(playable_species, /proc/cmp_auto_compare)
	tim_sort(custom_species_bases, /proc/cmp_auto_compare)

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
/**
 * returns all static species datums
 * DO NOT EVER MODIFY THESE.
 */
/datum/controller/subsystem/characters/proc/all_static_species_meta()
	RETURN_TYPE(/list)
	. = list()
	for(var/path in species_paths)
		. += species_paths[path]

/datum/controller/subsystem/characters/proc/all_species_names()
	RETURN_TYPE(/list)
	. = list()
	for(var/name in species_names)
		. += name

/**
 * default species id for when someone's species is removed/no longer playable
 */
/datum/controller/subsystem/characters/proc/default_species_id()
	var/datum/species/S = resolve_species_path(ispath(default_species_path, /datum/species)? default_species_path : /datum/species/human)
	return S.id
