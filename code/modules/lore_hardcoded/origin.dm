/datum/lore/character_background/origin
	abstract_type = /datum/lore/character_background/origin
	/// category
	var/category = "Misc"

/datum/lore/character_background/origion/check_character_species(datum/character_species/S)
	if(S.species_fluff_flags & SPECIES_FLUFF_PICKY_ORIGIN)
		. = (S.uid in allow_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in allow_species))
		if(!.)
			return
	return ..()

/datum/lore/character_background/origin/qerrbalak
	name = "Qerr'Balak"
	id = "qerrbalak"
	desc = "Be it from the expansive jungle-wrapped arcologies of the skrellian continents, or the colder teshari territories of the polar tundras, you are from the Vikara Combine's shared capital planet of Qerr'Balak."

/datum/lore/character_background/origin/custom
	name = "Other"
	id = "custom"
	desc = "Whether it may be a frontier planet, some backwater asteroid mining colony, or simply somewhere not mentioned otherwise, you didn't come from any of the above."
	category = "Misc"
