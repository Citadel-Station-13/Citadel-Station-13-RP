/datum/lore/character_background/religion
	abstract_type = /datum/lore/character_background/religion

/datum/lore/character_background/religion/check_character_species(datum/character_species/S)
	if(S.species_fluff_flags & SPECIES_FLUFF_PICKY_RELIGION)
		. = (S.uid in allow_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in allow_species))
		if(!.)
			return
	return ..()

/datum/lore/character_background/religion/custom
	name = "Other"
	id = "custom"
	desc = "Whether you're in a small sect of a niche religion, or simply have nonstandard beliefs, you don't fit into any of the above."
