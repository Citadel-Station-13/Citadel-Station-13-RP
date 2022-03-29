/datum/species/tajaran
	name = SPECIES_TAJ
	name_plural = "Tajaran"
	icobase = 'icons/mob/human_races/r_tajaran_vr.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran_vr.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail_vr.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 8
	slowdown = -0.5
	snow_movement = -1		//Ignores half of light snow
	brute_mod = 1.15
	burn_mod =  1.15
	flash_mod = 1.1
	metabolic_rate = 1.1
	gluttonous = 0
	health_hud_intensity = 2.5

	max_age = 80

	description = "The Tajaran are a mammalian species resembling roughly felines, hailing from Meralar in the Rarkajar system. \
	While reaching to the stars independently from outside influences, the humans engaged them in peaceful trade contact \
	and have accelerated the fledgling culture into the interstellar age. Their history is full of war and highly fractious \
	governments, something that permeates even to today's times. They prefer colder, tundra-like climates, much like their \
	home worlds and speak a variety of languages, especially Siik and Akhani."
	catalogue_data = list(/datum/category_item/catalogue/fauna/tajaran)

	body_temperature = 320.15	//Even more cold resistant, even more flammable

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	breath_cold_level_1 = 180	//Default 240 - Lower is better
	breath_cold_level_2 = 100	//Default 180
	breath_cold_level_3 = 60	//Default 100

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	breath_heat_level_1 = 360	//Default 380 - Higher is better
	breath_heat_level_2 = 430	//Default 450
	breath_heat_level_3 = 1000	//Default 1250

	primitive_form = SPECIES_MONKEY_TAJ

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"

	reagent_tag = IS_TAJARA

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	heat_discomfort_level = 295 //Prevents heat discomfort spam at 20c
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

	cold_discomfort_level = 275

	has_organ = list( //No appendix. :(
		O_HEART = /obj/item/organ/internal/heart,
		O_LUNGS = /obj/item/organ/internal/lungs,
		O_VOICE = /obj/item/organ/internal/voicebox,
		O_LIVER = /obj/item/organ/internal/liver,
		O_KIDNEYS = /obj/item/organ/internal/kidneys,
		O_BRAIN = /obj/item/organ/internal/brain,
		O_EYES = /obj/item/organ/internal/eyes,
		O_STOMACH = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine
		)

	color_mult = 1
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Tajarans"
	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair
		)


	max_languages = 4
	//economic_power = 10
	//secondary_langs = list(LANGUAGE_SIIK, LANGUAGE_AKHANI, LANGUAGE_SIIK_TAJR)
	//name_language = LANGUAGE_SIIK
	//species_language = LANGUAGE_SIIK


	available_lore_info = list(
		TAG_CULTURE = list(
			CULTURE_TAJARA,
			CULTURE_TAJARA_ZHAN,
			CULTURE_TAJARA_MSAI,
			CULTURE_TAJARA_NJARIR
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_AHDOMAI,
			HOME_SYSTEM_CCSS,
			HOME_SYSTEM_RASKARA,
			HOME_SYSTEM_HROZAMAL
		),
		TAG_FACTION = list(
			FACTION_TAJARA,
			FACTION_TAJARA_PRA,
			FACTION_TAJARA_DPRA,
			FACTION_TAJARA_NKA,
			FACTION_TAJARA_FC,
			FACTION_TAJARA_SPACER
		),
		TAG_RELIGION = list(
			RELIGION_TAJARA_SRANDARR,
			RELIGION_TAJARA_MESSA
		)
	)


/datum/species/tajaran/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)
