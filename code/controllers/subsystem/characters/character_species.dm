//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//


/datum/controller/subsystem/characters
	//! Species
	/**
	 * character species:
	 *
	 * a system that used to be an abstraction layer around lore species that weren't actually species
	 *
	 * i have however realized it's stupid, as massively overcomplicating the code because lore writers couldn't
	 * make up their minds in the past is an absolutely terrible idea.
	 *
	 * so this is only here as a wrap layer around species lookups during the transition.
	 *
	 * expect character species to be removed.
	 */
	var/list/character_species_lookup
	/**
	 * species ui cache
	 * so we don't rebuild this every time someone makes an ui
	 * list of categories associated to lists
	 * second layer of list contains:
	 * {name: str, desc: str, whitelisted: 1 or 0, id: str}
	 */
	var/list/character_species_cache

/datum/controller/subsystem/characters/proc/rebuild_character_species()
	// make species lookup
	character_species_lookup = list()
	for(var/path in species_paths)
		var/datum/species/S = species_paths[path]
		if(S.species_spawn_flags & (SPECIES_SPAWN_SPECIAL))	// don't bother
			continue
		if(!(S.species_spawn_flags & (SPECIES_SPAWN_CHARACTER))) // don't bother
			continue
		if(!S.uid)
			stack_trace("no species ID on [S.type].")
			continue
		if(character_species_lookup[S.uid])
			stack_trace("species uid collision on [S.uid] from [S.type].")
			continue
		character_species_lookup[S.uid] = S
	tim_sort(character_species_lookup, GLOBAL_PROC_REF(cmp_auto_compare), TRUE)
	rebuild_character_species_ui_cache()

/datum/controller/subsystem/characters/proc/rebuild_character_species_ui_cache()
	// make species data cache
	character_species_cache = list()
	for(var/id in character_species_lookup)
		var/datum/species/S = character_species_lookup[id]
		LAZYINITLIST(character_species_cache[S.category])
		character_species_cache[S.category] += list(list(
			"id" = S.uid,
			"spawn_flags" = S.species_spawn_flags,
			"name" = S.name,
			"desc" = S.blurb,
			"appearance_flags" = S.species_appearance_flags,
			"flags" = S.species_flags,
			"category" = S.category,	// note to self optimize this
		))

/datum/controller/subsystem/characters/proc/resolve_character_species(uid)
	RETURN_TYPE(/datum/species)
	return character_species_lookup[uid]

/datum/controller/subsystem/characters/proc/construct_character_species(uid)
	RETURN_TYPE(/datum/species)
	var/type_to_make = resolve_character_species(uid):type
	return new type_to_make

/datum/controller/subsystem/characters/proc/all_character_species()
	RETURN_TYPE(/list)
	. = list()
	for(var/uid in character_species_lookup)
		. += character_species_lookup[uid]
