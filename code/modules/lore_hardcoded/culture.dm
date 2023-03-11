/datum/lore/character_background/culture
	abstract_type = /datum/lore/character_background/culture

/datum/lore/character_background/culture/check_character_species(datum/character_species/S)
	if(S.species_fluff_flags & SPECIES_FLUFF_PICKY_CULTURE)
		. = (S.uid in allow_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in allow_species))
		if(!.)
			return
	return ..()

/datum/lore/character_background/culture/custom
	name = "Other"
	id = "custom"
	desc = "Some individuals don't belong to any of the common cultures around their worlds."
	category = "Misc"
