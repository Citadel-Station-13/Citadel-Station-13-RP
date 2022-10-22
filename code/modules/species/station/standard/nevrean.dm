/datum/species/nevrean
	uid = SPECIES_ID_NEVREAN
	name = SPECIES_NEVREAN
	name_plural = "Nevreans"
	primitive_form = SPECIES_MONKEY_NEVREAN
	default_bodytype = BODYTYPE_NEVREAN

	icobase      = 'icons/mob/species/nevrean/body.dmi'
	deform       = 'icons/mob/species/nevrean/deformed_body.dmi'
	preview_icon = 'icons/mob/species/nevrean/preview.dmi'
	husk_icon    = 'icons/mob/species/nevrean/husk.dmi'
	tail = "tail"
	icobase_tail = 1

	blurb = {"
	Nevreans are a race of avian and dinosaur-like creatures living on Tal. They belong to a group of races that hails from Eltus,
	in the Vilous system. Unlike sergals whom they share a star system with, their species is a very peaceful one. They possess remarkable
	intelligence and very skillful hands that are put use for constructing precision instruments, but tire-out fast when repeatedly working
	over and over again. Consequently, they struggle to make copies of same things. Both genders have a voice that echoes a lot. Their natural
	tone oscillates between tenor and soprano. They are excessively noisy when they quarrel in their native language.
	"}

	catalogue_data = list(/datum/category_item/catalogue/fauna/nevrean)

	max_additional_languages = 3
	name_language = LANGUAGE_ID_BIRDSONG
	intrinsic_languages = LANGUAGE_ID_BIRDSONG

	//darksight = 8
	//slowdown = -0.5
	//brute_mod = 1.15
	//burn_mod =  1.15
	//gluttonous = 1

	color_mult = 1
	max_age = 80

	species_spawn_flags = SPECIES_SPAWN_ALLOWED
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color  = "#333333"

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches.",
	)

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair,
	)
