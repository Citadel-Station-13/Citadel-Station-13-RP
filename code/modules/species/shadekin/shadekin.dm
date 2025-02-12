//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/physiology_modifier/intrinsic/species/shadekin

/**
 * Shadekin; anomalous, naturally void-borne creatures capable of manipulating the lack of energy.
 */
/datum/species/shadekin
	uid = "shadekin"
	id = "shadekin"

	name = "Shadekin"

	mob_physiology_modifier = /datum/physiology_modifier/intrinsic/species/shadekin

	// immune to pressure
	hazard_low_pressure = -1
	hazard_high_pressure = INFINITY

	// immune to cold, but not heat
	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1

	// dont' breathe
	breath_type = null
	poison_type = null

	// immune to radiation
	radiation_mod = 0

	// very subtle damage mitigation
	brute_mod = 0.975
	burn_mod = 0.975

	#warn vision + EM vision system

	// minor skin armoring, foreign biology
	#warn need an alternative way to revive them
	species_flags = NO_MINOR_CUT | NO_PAIN | NO_POISON | NO_EMBED | NO_HALLUCINATION | NO_BLOOD | NO_INFECT | NO_DEFIB

	// requires ghostrole
	species_spawn_flags = SPECIES_SPAWN_RESTRICTED | SPECIES_SPAWN_CHARACTER

	// you can choose anything you want
	genders = list(
		MALE,
		FEMALE,
		PLURAL,
		NEUTER,
		HERM,
	)

	// they don't cough
	// todo: biology should handle this
	male_cough_sounds   = null
	female_cough_sounds = null
	male_sneeze_sound   = null
	female_sneeze_sound = null

	// give them a spooky speech bubble
	speech_bubble_appearance = "ghost"

	// let them wear everything
	// TODO: underwear should be loadout
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_UNDERWEAR

	#warn organ / limbs

	abilities = list(
		/datum/ability/species/shadekin/light_suppression,
		/datum/ability/species/shadekin/phase_shift,
	)

#warn impl
