/datum/lore/character_background/origin/hegemony/naramadi
 	abstract_type = /datum/lore/character_background/origin/hegemony/naramadi

/datum/lore/character_background/origin/hegemony/naramadi/houses
	name = "Naramadi Houses"
	id = "naramadihouses"
	desc = "The upper class of the Naramadi Ascendancy, the Houses, are what is considered a 'citizen class' of their society. \
	While House members enjoy certain rights that others do not, the main difference is that Houses are allowed to dictate the direction of the Ascendancy \
	through the Landsmeet. As well as owning land, industry and agricultural sites, Houses provide the majority of military and logistical power to the Ascendancy. "
	innate_languages = list(
		LANGUAGE_ID_UNATHI,
		LANGUAGE_ID_NARAMADI
	)
	language_amount_mod = -1
	economy_payscale = 1.2

/datum/lore/character_background/origin/hegemony/naramadi/nameless
	name = "Nameless"
	id = "nameless"
	desc = "While the Houses are the most well known part of the Naramadi Society, and the only ones considered true citizens, \
	the so-called Nameless form a majority of the Ascendancy. While lacking certain rights within the Naramadi Ascendancy, \
	such as the right to vote and freedom of movement, they are encouraged to 'ascend' and attempt to join a House through rites appropriate to said House."
	innate_languages = list(
		LANGUAGE_ID_NARAMADI,
		LANGUAGE_ID_UNATHI
	)
	language_amount_mod = -1
	economy_payscale = 1.05

/datum/lore/character_background/origin/hegemony/naramadi/exiles
	name = "Naramadi Exiles"
	id = "naramadi_exiles"
	desc = "Exile is considered the last course for punishments' within the isolationist Ascendancy. \
	Houses are always tight-knit, and being removed from them is like loosing a limb for many of the House Members. \
	The majority of the Exiles that were present in the Ascendancy hated their brethren, which lead to the attempted uprising. \
	After which, the failed majority of the Exiles left for Orion Confederacy to shape their own way, away from the isolated Naramadi Home."
	allow_species = list(
		SPECIES_ID_NARAMADI
	)
	innate_languages = list(
		LANGUAGE_ID_NARAMADI
	)
	economy_payscale = 0.95
