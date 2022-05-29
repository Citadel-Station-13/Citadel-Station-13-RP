/datum/species/vetala_ruddy
	name = SPECIES_VETALA_RUDDY
	name_plural = "Vetalan"
	default_language = LANGUAGE_GALCOM
	language = LANGUAGE_GALCOM
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws, /datum/unarmed_attack/bite)
	rarity_value = 4

	blurb = "The Vetalan are not a unified race, per se. Each Vetalan is genetically a member of another species. \
	At some point during their former life, each Vetalan was exposed to an aggressive and highly adaptable \
	pathogen. Although the source of the pathogen remains unclear, its ability to jump across species and its \
	methodical transmissibility vectors suggest an artificial origin. Vetalans are divided into two primary \
	categories, although how this is determined is unknown. Ruddy Vetalans experience acute haemophilia and \
	experience difficulty naturally replenishing their blood supply. The pathogen enables the processing of blood \
	from external sources as the sole means of nutrition. Ruddy Vetalan are generally fast and aggressive, though \
	they remain coherent and are generally capable of coexisting in modern society."
	catalogue_data = list(/datum/category_item/catalogue/fauna/vetala_ruddy)

	slowdown = -0.5

	scream_verb = "wails"

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	spawn_flags = SPECIES_CAN_JOIN
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult = 1
	icobase = 'icons/mob/human_races/r_human_vr.dmi'
	deform = 'icons/mob/human_races/r_def_human_vr.dmi'
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	blood_color = "#ce4a4a"
	base_color = "#EECEB3"

	max_age = 200

	//Nocturnal and photosensitive.
	darksight = 7
	flash_mod = 3.0
	flash_burn = 5
	has_glowing_eyes = 1

	//Physical resistances and weaknesses.
	total_health = 75
	item_slowdown_mod = 1.5
	brute_mod = 0.75
	toxins_mod = 0.75
	burn_mod = 1.5

	//Appetite
	metabolic_rate = 1.2
	hunger_factor = 0.2
	metabolism = 0.06

	//Thin blood and a higher core temperature.
	minimum_breath_pressure = 20
	oxy_mod = 1.25
	bloodloss_rate = 2
	heat_discomfort_level = T0C+19

	inherent_verbs = list(
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/carbon/human/proc/bloodsuck,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/lick_wounds)

/datum/species/vetala_pale
	name = SPECIES_VETALA_PALE
	name_plural = "Vetalan"
	default_language = LANGUAGE_GALCOM
	language = LANGUAGE_GALCOM
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws, /datum/unarmed_attack/bite)
	rarity_value = 4

	blurb =	"The Vetalan are not a unified race, per se. Each Vetalan is genetically a member of another species. \
	At some point during their former life, each Vetalan was exposed to an aggressive and highly adaptable \
	pathogen. Although the source of the pathogen remains unclear, its ability to jump across species and its \
	methodical transmissibility vectors suggest an artificial origin. Vetalans are divided into two primary \
	categories, although how this is determined is unknown. Pale Vetalans are sturdy, yet sluggish creatures. \
	Their blood has nearly congealed and grown thick, decreasing their core temperature. In spite of their \
	often lethargic nature, or perhaps due to it, Pale Vetalan do not feed directly off of blood, but instead \
	siphon warmth and life energy from other living creatures to survive. Pale Vetalan are typically cold, \
	in more ways than one, but are generally able to integrate into civlized society."

	catalogue_data = list(/datum/category_item/catalogue/fauna/vetala_pale)

//	taste_sensitivity = TASTE_DULL

	slowdown = 0.5

	scream_verb = "wails"

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	spawn_flags = SPECIES_CAN_JOIN
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult = 1
	icobase = 'icons/mob/human_races/r_human_vr.dmi'
	deform = 'icons/mob/human_races/r_def_human_vr.dmi'
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	blood_color = "#720d0d"
	base_color = "#EECEB3"

	max_age = 200

	//Nocturnal and photosensitive.
	darksight = 7
	flash_mod = 3.0
	flash_burn = 5
	has_glowing_eyes = 1

	//Physical resistances and weaknesses.
	total_health = 110
	item_slowdown_mod = 0.5
	brute_mod = 0.75
	toxins_mod = 0.75
	burn_mod = 1.5
	radiation_mod = 1.5

	//Appetite
	metabolic_rate = 0.8
	hunger_factor = 0.04
	metabolism = 0.0012

	//Thick blood and a lower core temperature.
	minimum_breath_pressure = 20
	oxy_mod = 1.25
	bloodloss_rate = 0.75
	cold_discomfort_level = T0C+21

	inherent_verbs = list(
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/lick_wounds)
