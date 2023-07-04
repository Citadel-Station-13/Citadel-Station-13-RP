/datum/species/skeleton
	uid = SPECIES_ID_SKELETON
	name = SPECIES_SKELETON
	name_plural = "Skeletons"
	primitive_form = SPECIES_MONKEY

	blurb = {"
	Spooky Scary Skeletons!
	"}

	icobase = 'icons/mob/species/human/skeleton.dmi'

	intrinsic_languages = LANGUAGE_ID_HUMAN // todo?
	name_language = null // Use the first-name last-name generator rather than a language scrambler

	max_age = 110
	health_hud_intensity = 1.5

	species_flags = NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON | NO_MINOR_CUT | NO_BLOOD | UNDEAD | NO_DEFIB
	species_spawn_flags = SPECIES_SPAWN_SPECIAL
	species_appearance_flags = null

	show_ssd = null

	blood_volume = null
	taste_sensitivity = TASTE_DULL
	hunger_factor = 0
	metabolic_rate = 0

	virus_immune = TRUE

	brute_mod     = 1
	burn_mod      = 0
	oxy_mod       = 0
	toxins_mod    = 0
	radiation_mod = 0
	flash_mod     = 0
	chemOD_mod    = 0

	siemens_coefficient = 0

	death_message    = "falls over and stops moving!"
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

	unarmed_types = list( //Bones are pointy, fight me.
		/datum/unarmed_attack/claws/strong,
		/datum/unarmed_attack/bite/sharp,
		)
