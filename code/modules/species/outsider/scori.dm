/datum/species/scori
	name = "Scorian"
	name_plural = SPECIES_SCORI
	default_language = LANGUAGE_EVENT1
	language = LANGUAGE_EVENT1
	num_alternate_languages = 2
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/bite)
	rarity_value = 4

	blurb = "The Scori are the native inhabitants of Surt. Much of their history has been lost,	save for artistic \
	depictions sometimes recovered on archaeological digs. Insular and deeply xenophobic, the Scori are more commonly \
	known as Ashlanders. Until recently, the Scori were believed to have gone extinct some tens of thousands of years ago \
	when Surt underwent an as yet unknown cataclysm. Instead, the modern Scori seem to have descended from the cataclysm's \
	survivors. Dwelling deep underground in caves, or travelling across the planet's surface in nomadic caravans, sightings \
	of Scori tribesmen were treated as hoaxes. NanoTrasen pathfinding teams operating in the wake of the expedition to Kristen's \
	Harmony have since confirmed the presence of a nearby Scori tribe."
	catalogue_data = list(/datum/category_item/catalogue/fauna/ashlander)

	spawn_flags = SPECIES_IS_RESTRICTED
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	color_mult = 1
	flesh_color = "#5a5979"
	base_color = "#373652"
	blood_color = "#3c6d45"

	flags = NO_MINOR_CUT
	siemens_coefficient = 1.5

	max_age = 200

	//Adapted to overcast skies and caverns.
	darksight = 5
	flash_mod = 2.0

	//Physical resistances and weaknesses.
	brute_mod = 0.85
	burn_mod = 0.15
	radiation_mod = 0.5
	toxins_mod = 0.5

	//Adapted to Surt's hot, thin atmosphere.
	breath_type = /datum/gas/carbon_dioxide
	exhale_type = /datum/gas/oxygen
	minimum_breath_pressure = 11
	oxy_mod = 0.25
	heat_discomfort_level = T0C+10
	warning_low_pressure = 10
	hazard_low_pressure  = 5
	safe_pressure = 18

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair
		)

/datum/species/scori/equip_survival_gear()
	return
