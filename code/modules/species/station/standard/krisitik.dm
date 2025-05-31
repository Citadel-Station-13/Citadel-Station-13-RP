/datum/species/krisitik
	uid = SPECIES_ID_KRISITIK
	id = SPECIES_ID_KRISITIK
	name = SPECIES_KRISITIK
	name_plural = SPECIES_KRISITIK
	default_bodytype = BODYTYPE_KRISITIK

	icobase      = 'icons/mob/species/krisitik/body.dmi'
	deform       = 'icons/mob/species/krisitik/body.dmi' // They don't have a proper one for some reason...
	preview_icon = 'icons/mob/species/krisitik/preview.dmi'
	husk_icon    = 'icons/mob/species/krisitik/husk.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/krisitik,
	)

	max_additional_languages = 3
	name_language   = LANGUAGE_ID_SQUEAKISH
	intrinsic_languages = LANGUAGE_ID_SQUEAKISH

	vision_innate = /datum/vision/baseline/species_tier_2
	vision_organ = O_EYES

	color_mult = 1

	blurb = {"
	Krisitik are a race of subterranean murine people from the Perseus Arm. Already significantly advanced
	even before developing FTL, the Krisitik have exploded onto the galaxy using their mastery of nuclear technology
	to bridge the gap between them and the galactic superpowers. The crowding in the massive underground\
	cities of their toxic homeworld of Murith has led many Krisitik to emigrate to their colonies or towards the
	corporate frontier. As their isolationist government becomes more open, this emigration is only increasing.

	The Krisitik are highly varied people owing to their unstable genetics, which can result in lethal defects
	if left untreated. They are a competitive, survivalist, and paranoid people known to stretch, bend, and
	break the rules if it means being prepared for disasters to come, even if they are unlikely."}


	// wikilink = ""
	catalogue_data = list(/datum/category_item/catalogue/fauna/krisitik)

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color  = "B2B2B2"

	brute_mod = 1.1
	burn_mod  = 1.1
	flash_mod = 1.5 //Cave creatures don't like bright lights
	radiation_mod = 0.75 //Hardened Genes

	movement_base_speed = 5.5
	gluttonous    = 1

	max_age = 100

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
