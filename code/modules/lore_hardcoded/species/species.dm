/datum/lore/character_background/faction/species
	abstract_type = /datum/lore/character_background/faction/species

/datum/lore/character_background/citizenship/species
	abstract_type = /datum/lore/character_background/citizenship/species

/datum/lore/character_background/origin/species
	abstract_type = /datum/lore/character_background/origin/species

/datum/lore/character_background/religion/species
	abstract_type = /datum/lore/character_background/religion/species

/datum/lore/character_background/culture/species
	abstract_type = /datum/lore/character_background/culture/species


#define SPECIES_LOCKED_BACKGROUND_ROOTS_SINGLE(speciespath, speciesid, __category) \
/datum/lore/character_background/faction/species/##speciespath { \
	abstract_type = /datum/lore/character_background/faction/species/##speciespath; \
	allow_species = list( ##speciesid ); \
	category = __category; \
} \
/datum/lore/character_background/religion/species/##speciespath { \
	abstract_type = /datum/lore/character_background/religion/species/##speciespath; \
	allow_species = list( ##speciesid ); \
	category = __category; \
} \
/datum/lore/character_background/citizenship/species/##speciespath { \
	abstract_type = /datum/lore/character_background/citizenship/species/##speciespath; \
	allow_species = list( ##speciesid ); \
	category = __category; \
} \
/datum/lore/character_background/origin/species/##speciespath { \
	abstract_type = /datum/lore/character_background/origin/species/##speciespath; \
	allow_species = list( ##speciesid ); \
	category = __category; \
} \
/datum/lore/character_background/culture/species/##speciespath { \
	abstract_type = /datum/lore/character_background/culture/species/##speciespath; \
	allow_species = list( ##speciesid ); \
	category = __category; \
}
