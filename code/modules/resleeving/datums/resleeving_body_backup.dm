//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * Considered immutable once created; many datums may be shared!
 */
/datum/resleeving_body_backup

	//* legacy - in the future we want to have the same structures as prefs *//
	//* it might seem ridiculous to mark an entire datum as legacy but      *//
	//* that is unironically where we're at                                 *//

	var/datum/dna2/record/legacy_dna
	// prevents synthfabs from printing organics and vice versa
	//
	// considered legacy because this shoud realistically just be a torso examination tbh
	// and invalid parts just don't get printed lol lmao
	//
	// or better, put the WIP body in the other machine and have it automatically
	// fabricate the missing things if it's possible for it to print
	var/legacy_synthetic
	// legacy because species should be a /prototype reference once
	// species are made stateless and global singletons
	var/legacy_species_uid
	var/legacy_gender
	var/legacy_ooc_notes
	var/list/legacy_limb_data = list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO)
	var/list/legacy_organ_data = list(O_HEART, O_EYES, O_LUNGS, O_BRAIN)
	var/list/legacy_genetic_modifiers = list()
	var/legacy_sizemult
	var/legacy_weight

/datum/resleeving_body_backup/Destroy()
	// might be referenced by other stuff
	legacy_dna = null
	legacy_limb_data = null
	legacy_organ_data = null
	legacy_genetic_modifiers = null
	return ..()

/datum/resleeving_body_backup/New(mob/from_body)
	if(from_body)
		initialize_from_body(from_body)

/datum/resleeving_body_backup/proc/initialize_from_body(mob/from_body)
	// sorry humans only for now
	if(!ishuman(from_body))
		return

	var/mob/living/carbon/human/from_human = from_body
	legacy_synthetic = from_human.isSynthetic()
	legacy_species_id = from_human.species.uid
	legacy_gender = from_human.gender
	legacy_sizemult = from_human.size_multiplier
	legacy_weight = from_human.weight

