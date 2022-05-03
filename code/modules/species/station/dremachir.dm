/datum/species/dremachir
	name = SPECIES_DREMACHIR
	name_plural = SPECIES_DREMACHIR
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)

	blurb = "Dremachir lore is still a work in progress. They are not actual supernatural creatures. They are aliens. \
	They are not obsessed human genemodders. They're just a race of aliens that look like demonss. It's a big galaxy."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dremachir)

	language = LANGUAGE_DAEMON
	default_language = LANGUAGE_GALCOM
	num_alternate_languages = 3

	spawn_flags      = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult = 1
	icobase = 'icons/mob/human_races/r_human_vr.dmi'
	deform = 'icons/mob/human_races/r_def_human_vr.dmi'
	base_color = "#EECEB3"

	blood_color = "#27173D"
	base_color = "#580412"


	//Demons glow in the dark.
	has_glowing_eyes = 1
	darksight = 7

	//Physical resistances and Weaknesses.
	flash_mod = 3.0
	brute_mod = 0.85

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal)
