/datum/species/hi_zoxxen
	name = SPECIES_ZORREN_HIGH
	name_plural = "Zorren"
	icobase = 'icons/mob/human_races/r_fox_vr.dmi'
	deform = 'icons/mob/human_races/r_def_fox.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	inherent_verbs = list(/mob/living/carbon/human/proc/lick_wounds)

	max_age = 80

	description = "The fox-like Zorren are native to Virgo-Prime, however there are two distinct varieties of Zorren one with large ears and shorter fur, \
	and the other with longer fur that is a bit more vibrant. The long-eared, short-furred Zorren have come to be known as Flatland Zorren as that \
	is where most of their settlements are located. The Flatland Zorren are somewhat tribal and shamanistic as they have only recently started to be \
	hired by the Trans-Stellar Corporations. The other variety of Zorren are known as Highland Zorren as they frequently settle in hilly and/or \
	mountainous areas, they have a differing societal structure than the Flatland Zorren having a more feudal social structure, like the Flatland Zorren, \
	the Highland Zorren have also only recently been hired by the Trans-Stellar Corporations, but thanks to the different social structure they seem to \
	have adjusted better to their new lives. Though similar fox-like beings have been seen they are different than the Zorren."
	wikilink="https://citadel-station.net/wikiRP/index.php?title=Zorren#Royal_Zorren"

	catalogue_data = list(/datum/category_item/catalogue/fauna/zorren,
						/datum/category_item/catalogue/fauna/highzorren)

	//primitive_form = "" //We don't have fox-monkey sprites.

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	flesh_color = "#AFA59E"
	base_color = "#333333"
	blood_color = "#240bc4"
	color_mult = 1

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)
	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair
		)


	max_languages = 4
	//secondary_langs = list(LANGUAGE_TERMINUS)
	//name_language = LANGUAGE_TERMINUS


	available_cultural_info = list(
		TAG_CULTURE = list(
			TEMP_CULTURE_ZORREN
		),
		TAG_HOMEWORLD = list(
		),
		TAG_FACTION = list(
		)
	)


/datum/species/fl_zorren
	name = SPECIES_ZORREN_FLAT
	name_plural = "Zorren"
	icobase = 'icons/mob/human_races/r_fennec_vr.dmi'
	deform = 'icons/mob/human_races/r_def_fennec.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	inherent_verbs = list(/mob/living/carbon/human/proc/lick_wounds)

	max_age = 80

	description = "The fox-like Zorren are native to Virgo-Prime, however there are two distinct varieties of Zorren one with large ears and shorter fur, \
	and the other with longer fur that is a bit more vibrant. The long-eared, short-furred Zorren have come to be known as Flatland Zorren as that is \
	where most of their settlements are located. The Flatland Zorren are somewhat tribal and shamanistic as they have only recently started to be \
	hired by the Trans-Stellar Corporations. The other variety of Zorren are known as Highland Zorren as they frequently settle in hilly and/or \
	mountainous areas, they have a differing societal structure than the Flatland Zorren having a more feudal social structure, like the Flatland Zorren, \
	the Highland Zorren have also only recently been hired by the Trans-Stellar Corporations, but thanks to the different social structure they \
	seem to have adjusted better to their new lives. Though similar fox-like beings have been seen they are different than the Zorren."
	wikilink="https://citadel-station.net/wikiRP/index.php?title=Zorren#Free_Tribe_Zorren"

	catalogue_data = list(/datum/category_item/catalogue/fauna/zorren,
						/datum/category_item/catalogue/fauna/flatzorren)

	//primitive_form = "" //We don't have fennec-monkey sprites.
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"
	blood_color = "#240bc4"
	color_mult = 1
	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair
		)

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)


	max_languages = 4
	//secondary_langs = list(LANGUAGE_TERMINUS)
	//name_language = LANGUAGE_TERMINUS


	available_cultural_info = list(
		TAG_CULTURE = list(
			TEMP_CULTURE_ZORREN
		),
		TAG_HOMEWORLD = list(
		),
		TAG_FACTION = list(
		)
	)
