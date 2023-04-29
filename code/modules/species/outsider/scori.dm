/datum/species/scori
	uid = SPECIES_ID_SCORI
	name = "Scorian"
	name_plural = SPECIES_SCORI
	category = SPECIES_CATEGORY_RESTRICTED
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/bite)
	//rarity_value = 4

	blurb = "The Scori are the native inhabitants of Surt. Much of their history has been lost,	save for artistic \
	depictions sometimes recovered on archaeological digs. Insular and xenophobic, the Scori are more commonly \
	known as Ashlanders. Until recently, the Scori were believed to have gone extinct some tens of thousands of years ago \
	when Surt underwent an as yet unknown cataclysm. Instead, the modern Scori seem to have descended from the cataclysm's \
	survivors. Dwelling deep underground in caves, or travelling across the planet's surface in nomadic caravans, sightings \
	of Scori tribesmen were historically treated as hoaxes. NanoTrasen pathfinding teams operating in the wake of the expedition \
	to Kristen's Harmony have since confirmed the presence of a nearby Scori tribe."
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Scori"
	catalogue_data = list(/datum/category_item/catalogue/fauna/ashlander)

	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	color_mult = 1
	flesh_color = "#5a5979"
	base_color = "#373652"
	blood_color = "#3c6d45"

	max_age = 200

	galactic_language = FALSE
	default_language = LANGUAGE_ID_SCORI
	intrinsic_languages = list(LANGUAGE_ID_SCORI,LANGUAGE_ID_SIGN)
	max_additional_languages = 0

	species_flags = NO_MINOR_CUT
	species_spawn_flags = SPECIES_SPAWN_RESTRICTED | SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	//Physical resistances and weaknesses.
	burn_mod = 0.25
	radiation_mod = 1.5
	toxins_mod = 1.5

	darksight_innate = /datum/darksight/baseline/species_tier_3

	//Adapted to overcast skies and caverns.
	flash_mod = 3.0

	siemens_coefficient = 1.5

	//Adapted to Surt's hot, thin atmosphere.
	breath_type = /datum/gas/carbon_dioxide
	exhale_type = /datum/gas/oxygen

	heat_discomfort_level = T0C+20

	warning_low_pressure = 10
	safe_pressure = 18
	hazard_low_pressure  = 5
	minimum_breath_pressure = 11

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair
		)

/datum/species/scori/equip_survival_gear()
	return
