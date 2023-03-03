/datum/lore/character_background/faction
	abstract_type = /datum/lore/character_background/faction

/datum/lore/character_background/citizenship
	abstract_type = /datum/lore/character_background/citizenship

/datum/lore/character_background/origin
	abstract_type = /datum/lore/character_background/origin

/datum/lore/character_background/religion
	abstract_type = /datum/lore/character_background/religion

#define SPECIES_LOCKED_BACKGROUND_ROOTS_SINGLE(speciespath, speciesid, category) \
/datum/lore/character_background/faction/##speciespath { \
	abstract_type = /datum/lore/character_background/faction/##speciespath; \
	allow_species = list( ##speciesid ); \
	category = #category ; \
} \
/datum/lore/character_background/origin/##speciespath { \
	abstract_type = /datum/lore/character_background/origin/##speciespath; \
	allow_species = list( ##speciesid ); \
	category = #category ; \
} \
/datum/lore/character_background/religion/##speciespath { \
	abstract_type = /datum/lore/character_background/religion/##speciespath; \
	allow_species = list( ##speciesid ); \
	category = #category ; \
} \
/datum/lore/character_background/citizenship/##speciespath { \
	abstract_type = /datum/lore/character_background/citizenship/##speciespath; \
	allow_species = list( ##speciesid ); \
	category = #category ; \
}
