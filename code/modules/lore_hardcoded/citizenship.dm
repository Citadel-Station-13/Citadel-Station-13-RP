/datum/lore/character_background/citizenship
	abstract_type = /datum/lore/character_background/citizenship

/datum/lore/character_background/citizenship/check_character_species(datum/character_species/S)
	if(S.species_fluff_flags & SPECIES_FLUFF_PICKY_CITIZENSHIP)
		. = (S.uid in allow_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in allow_species))
		if(!.)
			return
	return ..()

/datum/lore/character_background/citizenship/orionconfederation
	name = "Orion Confederation"
	id = "oricon"
	desc = "Born from the cradle of humanity, the Orion Confederation is a coalition of human worlds spanning much of the space of the Orion Spur. \
	A constitutional government, the Orion Confederation was built from the remains of Terra's pre-space governments, and the semi-independent \
	colonies of Luna and Mars. \
	The largest megacorporations in the galaxy are predominantly human-centric, new frontiers are established on a regular basis by OriCon's \
	explorers, and territories solidify with every passing year. Today the Orion Confederation stands as the cultural center \
	of the galaxy, with it's megacorporations bringing untold prosperity to the galaxy... along with untold toil and struggle. \
	The Orion Confederation's hold on it's native megacorps is always tenuous; these major entities are almost left to their own affairs, \
	especially in the aftermath of the Phoron Wars, in regards to one of it's flagship corporations: NanoTrasen."

/datum/lore/character_background/citizenship/custom
	name = "Other"
	id = "custom"
	desc = "Some individuals are nomadic, or simply, for one reason or another, don't belong to any one government's citizenry. Whatever the case for you, you don't identify with any of the standing governments."
