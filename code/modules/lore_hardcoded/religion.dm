/datum/lore/character_background/religion
	abstract_type = /datum/lore/character_background/religion

/datum/lore/character_background/religion/check_species(datum/species/S)
	if(S.species_fluff_flags & SPECIES_FLUFF_PICKY_RELIGION)
		. = (S.uid in allow_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in allow_species))
		if(!.)
			return
	return ..()

/datum/lore/character_background/religion/alverrtcheff
	name = "Alverrtcheff"
	id = "alverrtcheff"
	desc = "Alverrtcheff, or The Grand Founder, is the name of both the deity and the religion associated with it. A type of deism, it was founded by the Vulpkanin under the belief that Alverrtcheff created the universe but does not meddle in it."
	category = "Misc"

/datum/lore/character_background/religion/custom
	name = "Other"
	id = "custom"
	desc = "Whether you're in a small sect of a niche religion, or simply have nonstandard beliefs, you don't fit into any of the above."
	category = "Misc"
