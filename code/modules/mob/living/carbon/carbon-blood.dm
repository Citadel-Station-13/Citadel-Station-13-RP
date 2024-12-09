//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/carbon/proc/create_self_blood_data()
	var/datum/blood_data/creating = new
	creating.legacy_blood_dna = dna.unique_enzymes
	creating.legacy_blood_type = dna.b_type
	creating.legacy_donor = src
	creating.legacy_species = isSynthetic() ? "synthetic" : species.name
	#warn how to deal with name / color?
	creating.legacy_name = species.get_blood_name(src)
	creating.color = species.get_blood_colour(src)
	return creating
