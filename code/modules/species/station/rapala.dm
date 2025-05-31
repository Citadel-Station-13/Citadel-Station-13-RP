/datum/species/rapala
	uid = SPECIES_ID_RAPALA
	id = SPECIES_ID_RAPALA
	name = SPECIES_RAPALA
	name_plural = "Rapalans"

	icobase      = 'icons/mob/species/rapala/body.dmi'
	deform       = 'icons/mob/species/rapala/deformed_body.dmi'
	preview_icon = 'icons/mob/species/rapala/preview.dmi'
	husk_icon    = 'icons/mob/species/rapala/husk.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/rapala,
	)

	max_additional_languages = 3
	name_language = null
	intrinsic_languages = LANGUAGE_ID_BIRDSONG

	vision_organ = O_EYES

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

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches.",
	)

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/punch,
		/datum/melee_attack/unarmed/bite,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)
	abilities = list(
		/datum/ability/species/toggle_flight
	)
