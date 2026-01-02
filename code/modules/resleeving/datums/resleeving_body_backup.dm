/**
 * * Considered immutable once created; many datums may be shared!
 */
/datum/resleeving_body_backup
	/// mind ref.
	/// * used to prevent impersonation; printed bodies get imprinted with this
	var/datum/mind_ref/mind_ref

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
	// key: BP_XYZ tag
	// value: 0 for missing, 1 for present, text string for /datum/robolimb company
	var/list/legacy_limb_data = list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO)
	// key: O_XYZ tag
	// value: 0 for normal, 1 for assisted, 2 for mechanical, 3 for digital, 4 for nanite
	var/list/legacy_organ_data = list(O_HEART, O_EYES, O_LUNGS, O_BRAIN)
	var/list/legacy_genetic_modifiers = list()
	var/legacy_sizemult
	var/legacy_weight
	var/legacy_custom_species_name

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

	// mind ref only gets set if the body has a mind.
	mind_ref = from_human.mind?.get_mind_ref()

	legacy_synthetic = from_human.isSynthetic()
	legacy_species_uid = from_human.species.uid
	legacy_gender = from_human.gender
	legacy_sizemult = from_human.size_multiplier
	legacy_weight = from_human.weight
	legacy_ooc_notes = from_human.ooc_notes
	legacy_custom_species_name = from_human.custom_species

	var/datum/dna2/record/cloning_dna = new
	legacy_dna = cloning_dna

	cloning_dna.dna = from_human.dna.Clone()
	cloning_dna.ckey = from_human.ckey
	// what the hell is this??? just for old cloners, really
	cloning_dna.id = copytext(md5(from_human.real_name), 2, 6)
	cloning_dna.name = from_human.dna.real_name
	cloning_dna.types = DNA2_BUF_SE | DNA2_BUF_UE | DNA2_BUF_UI
	cloning_dna.flavor = from_human.flavor_texts.Copy()

	for(var/datum/modifier/modifier in from_human.modifiers)
		if(modifier.flags & MODIFIER_GENETIC)
			legacy_genetic_modifiers += modifier.type

	for(var/legacy_bodypart_tag in legacy_limb_data)
		var/obj/item/organ/external/found = from_human.organs_by_name[legacy_bodypart_tag]
		if(!found)
			// gone, set to 0
			legacy_limb_data[legacy_bodypart_tag] = 0
		else if(found.model)
			// set to model for prosthetic
			legacy_limb_data[legacy_bodypart_tag] = found.model
		else
			legacy_limb_data[legacy_bodypart_tag] = 1

	for(var/legacy_organ_tag in legacy_organ_data)
		var/obj/item/organ/internal/found = from_human.internal_organs_by_name[legacy_organ_tag]
		if(!found)
			// don't override
			continue
		// snowflake handling for brains
		if(legacy_organ_tag == O_BRAIN)
			switch(found.type)
				if(/obj/item/organ/internal/mmi_holder)
					legacy_organ_data[legacy_organ_tag] = ORGAN_ASSISTED
				if(/obj/item/organ/internal/mmi_holder/posibrain)
					legacy_organ_data[legacy_organ_tag] = ORGAN_ROBOT
				if(/obj/item/organ/internal/mmi_holder/posibrain/nano)
					legacy_organ_data[legacy_organ_tag] = ORGAN_NANOFORM
				if(/obj/item/organ/internal/mmi_holder/robot)
					// this is technically wrong as originally '3' was 'digital',
					// whatever the fuck that means
					legacy_organ_data[legacy_organ_tag] = ORGAN_LIFELIKE
				else
					legacy_organ_data[legacy_organ_tag] = ORGAN_FLESH
		else
			legacy_organ_data[legacy_organ_tag] = found.robotic


