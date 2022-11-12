/datum/species/auril
	name = SPECIES_AURIL
	name_plural = SPECIES_AURIL
	uid = SPECIES_ID_AURIL
	category = SPECIES_CATEGORY_ANGEL

	blurb = {"
	The Auril are humanoids that resemble the angelic figures of Old Earth Christian myth.  The resemblance, however,
	is surface-level.  Auril are an alien species from the Daedal system, which is the only system in the galaxy inhabited to a
	major scale by the Auril.  They are perfectionists, conformists, and obedient to authority - in that order.  Their high-pressure
	society on Sanctum, their homeworld, leads to some abandoning this mindset entirely, however, which in turn causes them to
	seek out a new identity beyond their homeworld.
	"}
	catalogue_data = list(/datum/category_item/catalogue/fauna/auril)

	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	intrinsic_languages = LANGUAGE_ID_DAEDAL_AURIL
	max_additional_languages = 3

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult  = 1
	base_color  = "#EECEB3"
	blood_color = "#856A16"
	base_color  = "#DED2AD"


	//Angels glow in the dark.
	has_glowing_eyes = TRUE

	//Physical resistances and Weaknesses.
	//item_slowdown_mod = 0.5 //The Hardy debate is not settled yet.
	flash_mod = 0.5
	radiation_mod = 1.25
	toxins_mod = 0.85

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/proc/toggle_pass_table,
		/mob/living/proc/glow_toggle,
		/mob/living/proc/glow_color)

/datum/species/dremachir
	uid = SPECIES_ID_DREMACHIR
	name = SPECIES_DREMACHIR
	name_plural = SPECIES_DREMACHIR
	category = SPECIES_CATEGORY_ANGEL

	blurb = {"
	Dremachir lore is still a work in progress.  They are not actual supernatural creatures.  They are aliens.
	They are not obsessed human genemodders.  They're just a race of aliens that look like demonss.  It's a big galaxy.
	"}
	catalogue_data = list(/datum/category_item/catalogue/fauna/dremachir)

	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	intrinsic_languages = LANGUAGE_ID_DAEDAL_DREMACHIR
	max_additional_languages = 3

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult  = 1
	base_color  = "#EECEB3"
	blood_color = "#27173D"
	base_color  = "#580412"


	//Demons glow in the dark.
	has_glowing_eyes = TRUE
	darksight = 7

	//Physical resistances and Weaknesses.
	flash_mod = 3.0
	brute_mod = 0.85

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
	)
