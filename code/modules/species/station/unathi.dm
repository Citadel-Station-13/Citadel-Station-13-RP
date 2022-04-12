/datum/species/unathi
	name = SPECIES_UNATHI
	name_plural = "Unathi"
	icobase = 'icons/mob/human_races/r_lizard_vr.dmi'
	deform = 'icons/mob/human_races/r_def_lizard_vr.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail_vr.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	primitive_form = SPECIES_MONKEY_UNATHI
	ambiguous_genders = TRUE
	gluttonous = 1
	slowdown = 0.5
	total_health = 125
	brute_mod = 0.85
	burn_mod = 1
	metabolic_rate = 0.85
	item_slowdown_mod = 0.25
	mob_size = MOB_LARGE
	blood_volume = 840
	health_hud_intensity = 2.5

	max_age = 260

	description = "A heavily reptillian species, Unathi hail from the \
	Uuosa-Eso system, which roughly translates to 'burning mother'.<br/><br/>Coming from a harsh, inhospitable \
	planet, they mostly hold ideals of honesty, virtue, proficiency and bravery above all \
	else, frequently even their own lives. They prefer warmer temperatures than most species and \
	their native tongue is a heavy hissing laungage called Sinta'Unathi."
	catalogue_data = list(/datum/category_item/catalogue/fauna/unathi)

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	breath_cold_level_1 = 260	//Default 240 - Lower is better
	breath_cold_level_2 = 200	//Default 180
	breath_cold_level_3 = 120	//Default 100

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	breath_heat_level_1 = 450	//Default 380 - Higher is better
	breath_heat_level_2 = 530	//Default 450
	breath_heat_level_3 = 1400	//Default 1250

	minimum_breath_pressure = 18	//Bigger, means they need more air

	body_temperature = T20C

	spawn_flags = SPECIES_CAN_JOIN //Species_can_join is the only spawn flag all the races get, so that none of them will be whitelist only if whitelist is enabled.
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34AF10"
	blood_color = "#b3cbc3"
	base_color = "#066000"

	reagent_tag = IS_UNATHI

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	has_limbs = list(
		BP_TORSO = list("path" = /obj/item/organ/external/chest/unathi),
		BP_GROIN = list("path" = /obj/item/organ/external/groin/unathi),
		BP_HEAD = list("path" = /obj/item/organ/external/head/unathi),
		BP_L_ARM = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	//No kidneys or appendix
	has_organ = list(
		O_HEART = /obj/item/organ/internal/heart/unathi,
		O_LUNGS = /obj/item/organ/internal/lungs/unathi,
		O_LIVER = /obj/item/organ/internal/liver/unathi,
		O_BRAIN = /obj/item/organ/internal/brain/unathi,
		O_EYES = /obj/item/organ/internal/eyes,
		O_STOMACH = /obj/item/organ/internal/stomach/unathi,
		O_INTESTINE = /obj/item/organ/internal/intestine/unathi
		)


	heat_discomfort_level = 295
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 292
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)


	color_mult = 1
	gluttonous = 0
	wikilink="https://citadel-station.net/wikiRP/index.php?title=Unathi"
	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair
		)


	max_languages = 4
	//secondary_langs = list(LANGUAGE_UNATHI)
	//name_language = LANGUAGE_UNATHI
	//species_language = LANGUAGE_UNATHI

	descriptors = list(
		/datum/mob_descriptor/height = 2,
		/datum/mob_descriptor/build = 2
		)

	available_lore_info = list(
		TAG_CULTURE = list(
			CULTURE_UNATHI
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_MOGHES
		),
		TAG_FACTION = list(
			FACTION_UNATHI_POLAR,
			FACTION_UNATHI_DESERT,
			FACTION_UNATHI_SAVANNAH,
			FACTION_UNATHI_DIAMOND_PEAK,
			FACTION_UNATHI_SALT_SWAMP
		),
		TAG_RELIGION =  list(
			RELIGION_UNATHI_STRATAGEM,
			RELIGION_UNATHI_PRECURSOR,
			RELIGION_UNATHI_VINE,
			RELIGION_UNATHI_LIGHTS,
			RELIGION_OTHER
		)
	)


/datum/species/unathi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)
