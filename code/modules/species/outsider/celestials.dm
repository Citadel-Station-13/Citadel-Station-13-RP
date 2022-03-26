/datum/species/auril
	name = SPECIES_AURIL
	name_plural = "Auril"
	default_language = LANGUAGE_GALCOM
	language = LANGUAGE_ENOCHIAN
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)

	blurb = "The Auril are humanoids that resemble the angelic figures of Old Earth Christian myth. The resemblance, however, \
	is surface-level. Auril are an alien species from the Daedal system, which is the only system in the galaxy inhabited to a \
	major scale by the Auril. They are perfectionists, conformists, and obedient to authority - in that order. Their high-pressure \
	society on Sanctum, their homeworld, leads to some abandoning this mindset entirely, however, which in turn causes them to \
	seek out a new identity beyond their homeworld."
	catalogue_data = list(/datum/category_item/catalogue/fauna/auril)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult = 1
	icobase = 'icons/mob/human_races/r_human_vr.dmi'
	deform = 'icons/mob/human_races/r_def_human_vr.dmi'
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	base_color = "#EECEB3"

	blood_color = "#856A16"
	base_color = "#DED2AD"

	min_age = 18

	//Angels glow in the dark.
	has_glowing_eyes = 1

	//Physical resistances and Weaknesses.
	//item_slowdown_mod = 0.5		//The Hardy debate is not settled yet.
	flash_mod = 0.5
	radiation_mod = 1.25
	toxins_mod = 0.85

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/proc/toggle_pass_table,
		/mob/living/proc/glow_toggle,
		/mob/living/proc/glow_color)

/datum/species/dremachir
	name = SPECIES_DREMACHIR
	name_plural = "Dremachir"
	default_language = LANGUAGE_GALCOM
	language = LANGUAGE_DAEMON
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)

	blurb = "Dremachir lore is still a work in progress. They are not actual supernatural creatures. They are aliens. \
	They are not obsessed human genemodders. They're just a race of aliens that look like demonss. It's a big galaxy."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dremachir)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult = 1
	icobase = 'icons/mob/human_races/r_human_vr.dmi'
	deform = 'icons/mob/human_races/r_def_human_vr.dmi'
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	base_color = "#EECEB3"

	blood_color = "#27173D"
	base_color = "#580412"

	min_age = 18

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
