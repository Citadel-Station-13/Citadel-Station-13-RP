/datum/species/skrell
	uid = SPECIES_ID_SKRELL
	name = SPECIES_SKRELL
	name_plural = SPECIES_SKRELL
	primitive_form = SPECIES_MONKEY_SKRELL
	icobase = 'icons/mob/species/skrell/body_greyscale.dmi'
	deform = 'icons/mob/species/skrell/deformed_body_greyscale.dmi'

	blurb = {"
	An amphibious species, Skrell come from the star system known as Qerr'Vallis, which translates
	to 'Star of the royals' or 'Light of the Crown'.

	Skrell are a highly advanced and logical race who live under the rule  of the Qerr'Katish, a
	caste within their society which keeps the empire of the Skrell running smoothly.  Skrell are
	herbivores on the whole and tend to be co-operative with the other species of the galaxy, although
	they rarely reveal the secrets of their empire to their allies.
	"}

	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Skrell"
	catalogue_data = list(/datum/category_item/catalogue/fauna/skrell)

	max_additional_languages = 3
	name_language    = LANGUAGE_ID_SKRELL
	intrinsic_languages = LANGUAGE_ID_SKRELL
	whitelist_languages = list(
		LANGUAGE_ID_SKRELL,
		LANGUAGE_ID_SKRELL_ALT,
		LANGUAGE_ID_TESHARI
	)
	assisted_langs   = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)

	color_mult = 1
	health_hud_intensity = 2

	water_movement = -3

	max_age = 130

	economic_modifier = 10

	darksight  = 4
	flash_mod  = 1.2
	chemOD_mod = 0.9

	bloodloss_rate = 1.5

	ambiguous_genders = TRUE

	species_spawn_flags = SPECIES_SPAWN_ALLOWED
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR

	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	base_color  = "#006666"

	cold_level_1 = 280
	cold_level_2 = 220
	cold_level_3 = 130

	breath_cold_level_1 = 250
	breath_cold_level_2 = 190
	breath_cold_level_3 = 120

	heat_level_1 = 420
	heat_level_2 = 480
	heat_level_3 = 1100

	breath_heat_level_1 = 400
	breath_heat_level_2 = 500
	breath_heat_level_3 = 1350

	reagent_tag = null

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/skrell),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

	unarmed_types = list(
		/datum/unarmed_attack/punch,
	)


/datum/species/skrell/can_breathe_water()
	return TRUE
