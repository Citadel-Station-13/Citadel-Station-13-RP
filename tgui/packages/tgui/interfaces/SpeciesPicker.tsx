import { useBackend } from '../backend';

type SpeciesPickerContext = {

};

export const SpeciesPicker = (props, context) => {
  const { act, data } = useBackend<SpeciesPickerContext>(context);

  return (
    "TESTING CODE"
  );
};


// /datum/tgui_species_picker/ui_static_data(mob/user)
// . = ..()
// .["whitelisted"] = whitelisted
// .["species"] = SScharacters.character_species_cache
// .["default"] = default


// /datum/controller/subsystem/characters/proc/rebuild_character_species()
// 	// make species lookup
// 	character_species_lookup = list()
// 	for(var/path in species_paths)
// 		var/datum/species/S = species_paths[path]
// 		if(!(S.species_spawn_flags & SPECIES_SPAWN_ALLOWED))		// don't bother lmao
// 			continue
// 		if(character_species_lookup[S.uid])
// 			stack_trace("species uid collision on [S.uid] from [S.type].")
// 			continue
// 		character_species_lookup[S.uid] = S.construct_character_species()
// 	for(var/path in subtypesof(/datum/character_species))
// 		var/datum/character_species/S = path
// 		if(initial(S.abstract_type) == path)
// 			continue
// 		S = new path
// 		if(character_species_lookup[S.uid])
// 			stack_trace("ignoring custom character species path [path] - collides on uid [S.uid]")
// 			continue
// 		character_species_lookup[S.uid] = S

// 	// make species data cache
// 	character_species_cache = list()
// 	for(var/id in character_species_lookup)
// 		var/datum/character_species/S = character_species_lookup[id]
// 		LAZYINITLIST(character_species_cache[S.category])
// 		character_species_cache[S.category] += list(list(
// 			"id" = S.uid,
// 			"whitelisted" = S.whitelisted,
// 			"name" = S.name,
// 			"desc" = S.desc,
// 			"appearance_flags" = S.species_appearance_flags,
// 			"flags" = S.species_flags
// 		))
