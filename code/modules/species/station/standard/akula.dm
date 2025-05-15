/datum/species/akula
	uid = SPECIES_ID_AKULA
	id = SPECIES_ID_AKULA
	name = SPECIES_AKULA
	name_plural = SPECIES_AKULA //It's singular and plural. English is weird.
	primitive_form = SPECIES_MONKEY_AKULA

	icobase      = 'icons/mob/species/akula/body.dmi'
	deform       = 'icons/mob/species/akula/deformed_body.dmi'
	preview_icon = 'icons/mob/species/akula/preview.dmi'
	husk_icon    = 'icons/mob/species/akula/husk.dmi'
	default_bodytype = BODYTYPE_AKULA

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/akula,
	)

	blurb = {"
	The Akula are a species of amphibious humanoids like the Skrell, but have an appearance very similar to that of a shark.
	They were first discovered as a primitive race of underwater dwelling tribal creatures by the Skrell.  At first they were not believed
	to be noteworthy, but the Akula proved to be such swift and clever learners that the Skrell reclassified them as sentients.

	Allegedly, the Akula were also the first sentient life that the Skrell had ever encountered beside themselves, and thus the two species
	became swift allies over the next few hundred years.  With the help of Skrellean technology, the Akula had their genome modified to be
	capable of surviving in open air for long periods of time.  However, Akula even today still require a high humidity environment to avoid
	drying out after a few days, which would make life on an arid world like Virgo-Prime nearly impossible if it were not for Skrellean
	technology to aid them.
	"}

	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Akula"
	catalogue_data = list(/datum/category_item/catalogue/fauna/akula)

	max_additional_languages = 3
	name_language   = LANGUAGE_ID_SKRELL
	intrinsic_languages = LANGUAGE_ID_SKRELL
	assisted_langs  = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_PROMETHEAN)

	// darksight  = 8
	// slowdown   = -0.5
	// brute_mod  = 1.15
	// burn_mod   = 1.15
	// gluttonous = 1

	vision_organ = O_EYES

	color_mult = 1
	water_movement = -4
	max_age = 80

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color  = "#777777"
	blood_color = "#1D2CBF"

	unarmed_types = list(
		/datum/melee_attack/unarmed/stomp,
		/datum/melee_attack/unarmed/kick,
		/datum/melee_attack/unarmed/claws,
		/datum/melee_attack/unarmed/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)

/datum/species/akula/can_breathe_water()
	return TRUE // Surprise, SHERKS.
