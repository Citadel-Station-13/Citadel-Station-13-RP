/datum/lore/character_background/culture/species/auril
	name = "Auraborn Exile"
	id = "culture_auril_main"
	category = "Species -- Auril"
	innate_languages = list(
		/datum/language/angel,
	)
	desc = "Aurils who were born and grew up on the lush, tropical homeworld of Aura. They were taught the virtues and values of Aura -- diligence, responsibility, and to think ahead for the overall good of the species. In spite of this, the pressures of society, or other factors have led them to abandon the homeworld."

/datum/lore/character_background/culture/species/auril/prideborn
	name = "Prideborn Exile"
	id = "culture_auril_pride"
	innate_languages = list(
		/datum/language/angel,
		/datum/language/demon,
	)
	language_amount_mod = -1
	desc = "Aurils who were originating from the Auril Enclave on the Dremachir homeworld -- City of Pride, as named by humans. Its pearlescent, high altitude platform city shined like a beacon in the dusty plains of Drema, and both of the species intermingled amongst each other, leading to a far less homogenous ideals and beliefs."

/datum/lore/character_background/culture/species/auril/outsider
	name = "Outsider"
	id = "culture_auril_outsider"
	language_amount_mod = 1
	desc = "Aurils who were born or grew up outside of Daedal entirely. Their innate genetic disposition granted them easier ability to learn any given language while growing up. They may share any set of ideals or beliefs from their extraneous homeworld."
