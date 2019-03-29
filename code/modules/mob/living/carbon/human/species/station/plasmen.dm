/datum/species/plasmaman
	name = SPECIES_PLASMAMAN
	name_plural = "Phoronoids"
	icobase = 'icons/mob/human_races/r_plasmaman_sb.dmi'
	primitive_form = null
	language = LANGUAGE_GALCOM
	species_language = LANGUAGE_BONES
	num_alternate_languages = 1
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)	//Bones are pointy, fight me.
	blurb = "Filler Description, replace later."
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	min_age = 18
	max_age = 110
	health_hud_intensity = 1.5

	flags = NO_SCAN | NO_MINOR_CUT
	spawn_flags = SPECIES_IS_WHITELISTED
	appearance_flags = null

	show_ssd = null

	blood_volume = null
	taste_sensitivity = TASTE_DULL
	hunger_factor = 0
	metabolic_rate = 0

	virus_immune = 1

	brute_mod =     1
	burn_mod =      1
	oxy_mod =       2
	toxins_mod =    1
	radiation_mod = 1
	flash_mod =     1
	chemOD_mod =	1

	breath_type = "phoron"
	poison_type = "oxygen"
	siemens_coefficient = 0.5

	death_message = "falls over and stops moving!"
	knockout_message = "falls over and stops moving!"

	has_organ = list()

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	body_temperature = T20C