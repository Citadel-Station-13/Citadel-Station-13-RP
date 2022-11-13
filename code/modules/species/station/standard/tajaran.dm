/datum/species/tajaran
	uid = SPECIES_ID_TAJARAN
	name = SPECIES_TAJ
	name_plural = "Tajaran"
	category = "Tajaran"
	default_bodytype = BODYTYPE_TAJARAN

	icobase      = 'icons/mob/species/tajaran/body_greyscale.dmi'
	deform       = 'icons/mob/species/tajaran/deformed_body_greyscale.dmi'
	preview_icon = 'icons/mob/species/tajaran/preview.dmi'
	husk_icon    = 'icons/mob/species/tajaran/husk.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail_greyscale.dmi'

	max_additional_languages = 3
	name_language = LANGUAGE_ID_TAJARAN
	intrinsic_languages = LANGUAGE_ID_TAJARAN
	whitelist_languages = list(
		LANGUAGE_ID_TAJARAN,
		LANGUAGE_ID_TAJARAN_ALT,
		LANGUAGE_ID_TAJARAN_SIGN
	)

	darksight = 8
	slowdown  = -0.5
	snow_movement = -1 //Ignores half of light snow

	brute_mod = 1.15
	burn_mod  = 1.15
	flash_mod = 1.1

	metabolic_rate = 1.1
	gluttonous = 0

	color_mult = 1
	health_hud_intensity = 2.5

	max_age = 80

	economic_modifier = 10

	blurb = {"
	The Tajaran are a mammalian species resembling roughly felines, hailing from Meralar in the Rarkajar system.

	While reaching to the stars independently from outside influences, the humans engaged them in peaceful trade contact
	and have accelerated the fledgling culture into the interstellar age. Their history is full of war and highly fractious
	governments, something that permeates even to today's times. They prefer colder, tundra-like climates, much like their
	home worlds and speak a variety of languages, especially Siik and Akhani.
	"}
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Tajarans"
	catalogue_data = list(/datum/category_item/catalogue/fauna/tajaran)

	body_temperature = 320.15 //Even more cold resistant, even more flammable

	cold_level_1 = 200
	cold_level_2 = 140
	cold_level_3 = 80

	breath_cold_level_1 = 180
	breath_cold_level_2 = 100
	breath_cold_level_3 = 60

	heat_level_1 = 330
	heat_level_2 = 380
	heat_level_3 = 800

	breath_heat_level_1 = 360
	breath_heat_level_2 = 430
	breath_heat_level_3 = 1000

	primitive_form = SPECIES_MONKEY_TAJ

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color  = "#333333"

	reagent_tag = IS_TAJARA

	move_trail = /obj/effect/debris/cleanable/blood/tracks/paw

	heat_discomfort_level   = 295 //Prevents heat discomfort spam at 20c
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches.",
	)

	cold_discomfort_level = 275

	has_organ = list( //No appendix.
		O_HEART     = /obj/item/organ/internal/heart,
		O_LUNGS     = /obj/item/organ/internal/lungs,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
	)

	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair,
	)

/datum/species/tajaran/equip_survival_gear(mob/living/carbon/human/H)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), SLOT_ID_SHOES)
