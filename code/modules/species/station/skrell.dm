/datum/species/skrell
	name = SPECIES_SKRELL
	name_plural = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell_vr.dmi'
	deform = 'icons/mob/human_races/r_def_skrell_vr.dmi'
	primitive_form = SPECIES_MONKEY_SKRELL
	unarmed_types = list(/datum/unarmed_attack/punch)
	description = "An amphibious species, Skrell come from the star system known as Qerr'Vallis, which translates to 'Star of \
	the royals' or 'Light of the Crown'.<br/><br/>Skrell are a highly advanced and logical race who live under the rule \
	of the Qerr'Katish, a caste within their society which keeps the empire of the Skrell running smoothly. Skrell are \
	herbivores on the whole and tend to be co-operative with the other species of the galaxy, although they rarely reveal \
	the secrets of their empire to their allies."
	catalogue_data = list(/datum/category_item/catalogue/fauna/skrell)
	health_hud_intensity = 2
	genders = list(PLURAL)

	water_movement = -3

	max_age = 130

	//economic_power = 10

	darksight = 4
	flash_mod = 1.2
	chemOD_mod = 0.9

	bloodloss_rate = 1.5

	ambiguous_genders = TRUE

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR

	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	base_color = "#006666"

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	breath_cold_level_1 = 250	//Default 240 - Lower is better
	breath_cold_level_2 = 190	//Default 180
	breath_cold_level_3 = 120	//Default 100

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	breath_heat_level_1 = 400	//Default 380 - Higher is better
	breath_heat_level_2 = 500	//Default 450
	breath_heat_level_3 = 1350	//Default 1250

	reagent_tag = null

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/skrell),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	color_mult = 1
	wikilink="https://citadel-station.net/wikiRP/index.php?title=Skrell"


	max_languages = 4
	//secondary_langs = list(LANGUAGE_SKRELLIAN, LANGUAGE_SCHECHI)
	//name_language = LANGUAGE_SKRELLIAN
	//species_language = LANGUAGE_SKRELLIAN
	//assisted_langs = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)

	descriptors = list(
		/datum/mob_descriptor/height = 1.2,
		/datum/mob_descriptor/build = 0,
		/datum/mob_descriptor/headtail_length = 0
	)

	available_lore_info = list(
		TAG_CULTURE = list(
			CULTURE_SKRELL_QERR,
			CULTURE_SKRELL_MALISH,
			CULTURE_SKRELL_KANIN,
			CULTURE_SKRELL_TALUM,
			CULTURE_SKRELL_RASKINTA
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_QERRBALAK
		),
		TAG_FACTION = list(
			FACTION_OTHER,
			FACTION_EXPEDITIONARY,
			FACTION_NANOTRASEN
		),
		TAG_RELIGION = list(
			RELIGION_OTHER,
			RELIGION_ATHEISM,
			RELIGION_DEISM,
			RELIGION_AGNOSTICISM
		)
	)


/datum/species/skrell/get_sex(var/mob/living/carbon/H)
	return descriptors["headtail length"] == 1 ? MALE : FEMALE


/datum/species/skrell/can_breathe_water()
	return TRUE
