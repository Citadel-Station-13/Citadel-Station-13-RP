/datum/species/nevrean
	uid = SPECIES_ID_NEVREAN
	id = SPECIES_ID_NEVREAN
	name = SPECIES_NEVREAN
	name_plural = "Nevreans"
	primitive_form = SPECIES_MONKEY_NEVREAN
	default_bodytype = BODYTYPE_NEVREAN

	icobase      = 'icons/mob/species/nevrean/body.dmi'
	deform       = 'icons/mob/species/nevrean/deformed_body.dmi'
	preview_icon = 'icons/mob/species/nevrean/preview.dmi'
	husk_icon    = 'icons/mob/species/nevrean/husk.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/nevrean,
	)

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
	vision_organ = O_EYES

	color_mult = 1
	max_age = 80

	species_spawn_flags = SPECIES_SPAWN_SECRET
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color  = "#333333"

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

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)
	abilities = list(
		/datum/ability/species/toggle_flight
	)
