/datum/species/hi_zoxxen
	uid = SPECIES_ID_ZORREN_HIGH
	id = SPECIES_ID_ZORREN_HIGH
	id = SPECIES_ID_ZORREN
	name = SPECIES_ZORREN_HIGH
	name_plural = "Zorren"
	//primitive_form = "" //We don't have fox-monkey sprites.
	default_bodytype = BODYTYPE_ZORREN_HIGH

	icobase = 'icons/mob/species/zorren_hi/body_greyscale.dmi'
	deform  = 'icons/mob/species/zorren_hi/deformed_body.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/zorren_highlander,
	)

	max_additional_languages = 3
	intrinsic_languages = LANGUAGE_ID_TERMINUS
	name_language = LANGUAGE_ID_TERMINUS
	inherent_verbs = list(/mob/living/carbon/human/proc/lick_wounds)

	max_age = 80

	blurb = {"
	The fox-like Zorren are native to Virgo-Prime, however there are two distinct varieties of Zorren one with large ears and shorter fur,
	and the other with longer fur that is a bit more vibrant. The long-eared, short-furred Zorren have come to be known as Flatland Zorren as that
	is where most of their settlements are located. The Flatland Zorren are somewhat tribal and shamanistic as they have only recently started to be
	hired by the Trans-Stellar Corporations. The other variety of Zorren are known as Highland Zorren as they frequently settle in hilly and/or
	mountainous areas, they have a differing societal structure than the Flatland Zorren having a more feudal social structure, like the Flatland Zorren,
	the Highland Zorren have also only recently been hired by the Trans-Stellar Corporations, but thanks to the different social structure they seem to
	have adjusted better to their new lives. Though similar fox-like beings have been seen they are different than the Zorren.
	"}

	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Zorren"
	catalogue_data = list(
		/datum/category_item/catalogue/fauna/zorren,
		/datum/category_item/catalogue/fauna/highzorren,
	)


	species_spawn_flags = SPECIES_SPAWN_SECRET
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color  = "#333333"
	blood_color = "#240bc4"
	color_mult = 1
	vision_organ = O_EYES

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches.",
	)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/claws,
		/datum/melee_attack/unarmed/bite/sharp,
	)

/datum/species/fl_zorren
	uid = SPECIES_ID_ZORREN_FLAT
	id = SPECIES_ID_ZORREN
	name = SPECIES_ZORREN_FLAT
	name_plural = "Zorren"
	//primitive_form = "" //We don't have fennec-monkey sprites.
	default_bodytype = BODYTYPE_ZORREN_FLAT

	icobase = 'icons/mob/species/zorren_fl/body_greyscale.dmi'
	deform  = 'icons/mob/species/zorren_fl/deformed_body.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/zorren_flatlander,
	)

	max_additional_languages = 3
	intrinsic_languages = LANGUAGE_ID_TERMINUS
	name_language = LANGUAGE_ID_TERMINUS
	inherent_verbs = list(/mob/living/carbon/human/proc/lick_wounds)

	max_age = 80

	blurb = {"
	The fox-like Zorren are native to Virgo-Prime, however there are two distinct varieties of Zorren one with large ears and shorter fur,
	and the other with longer fur that is a bit more vibrant. The long-eared, short-furred Zorren have come to be known as Flatland Zorren as that is
	where most of their settlements are located. The Flatland Zorren are somewhat tribal and shamanistic as they have only recently started to be
	hired by the Trans-Stellar Corporations.

	The other variety of Zorren are known as Highland Zorren as they frequently settle in hilly and/or mountainous areas, they have a differing
	societal structure than the Flatland Zorren having a more feudal social structure, like the Flatland Zorren, the Highland Zorren have also
	only recently been hired by the Trans-Stellar Corporations, but thanks to the different social structure they seem to have adjusted better
	to their new lives. Though similar fox-like beings have been seen they are different than the Zorren.
	"}

	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Zorren"
	catalogue_data = list(
		/datum/category_item/catalogue/fauna/zorren,
		/datum/category_item/catalogue/fauna/flatzorren,
	)

	species_spawn_flags = SPECIES_SPAWN_SECRET
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color  = "#333333"
	blood_color = "#240bc4"
	color_mult = 1
	vision_organ = O_EYES

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches.",
	)

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/claws,
		/datum/melee_attack/unarmed/bite/sharp,
	)
