/datum/species/rapala
	name = SPECIES_RAPALA
	name_plural = "Rapalans"
	uid = SPECIES_ID_RAPALA

	icobase      = 'icons/mob/species/rapala/body.dmi'
	deform       = 'icons/mob/species/rapala/deformed_body.dmi'
	preview_icon = 'icons/mob/species/rapala/preview.dmi'
	husk_icon    = 'icons/mob/species/rapala/husk.dmi'
	tail = "tail"
	icobase_tail = 1

	max_additional_languages = 3
	name_language = null
	intrinsic_languages = LANGUAGE_ID_BIRDSONG

	color_mult = 1
	max_age = 80

	base_color = "#EECEB3"

	blurb = {"
	An Avian species, coming from a distant planet, the Rapalas are the very proud race.  Sol researchers have commented
	on them having a very close resemblance to the mythical race called 'Harpies', who are known for having massive winged
	arms and talons as feet.  They've been clocked at speeds of over 35 miler per hour chasing the planet's many fish-like
	fauna.

	The Rapalan's home-world 'Verita' is a strangely habitable gas giant, while no physical earth exists, there are
	fertile floating islands orbiting around the planet from past asteroid activity.
	"}

	// wikilink = ""
	catalogue_data = list(/datum/category_item/catalogue/fauna/rapala)

	species_spawn_flags = SPECIES_SPAWN_ALLOWED
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches.",
	)

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite,
	)

	inherent_verbs = list(
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair,
	)
