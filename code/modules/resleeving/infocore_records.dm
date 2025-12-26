/datum/transhuman/mind_record

/datum/transhuman/mind_record/New(var/datum/mind/mind, var/mob/living/carbon/human/M, var/add_to_db = TRUE, var/one_time = FALSE)
	ASSERT(mind)
	//Mental stuff the game doesn't keep mentally
	if(istype(M) || istype(M,/mob/living/carbon/brain/caught_soul))
		languages = M.languages.Copy()

/datum/transhuman/body_record/proc/init_from_mob(var/mob/living/carbon/human/M, var/add_to_db = 0, var/ckeylock = 0)

	//Probably should
	M.dna.check_integrity()

	//The DNA2 stuff
	mydna = new ()
	mydna.dna = M.dna.Clone()
	mydna.ckey = M.ckey
	mydna.id = copytext(md5(M.real_name), 2, 6)
	mydna.name = M.dna.real_name
	mydna.types = DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	mydna.flavor = M.flavor_texts.Copy()

	//My stuff
	client_ref = M.client
	ckey = M.ckey
	mind_ref = M.mind

	//External organ status. 0:gone, 1:normal, "string":manufacturer
	for(var/limb in limb_data)
		var/obj/item/organ/external/O = M.organs_by_name[limb]

		//Missing limb.
		if(!O)
			limb_data[limb] = 0

		//Has model set, is pros.
		else if(O.model)
			limb_data[limb] = O.model

		//Nothing special, present and normal.
		else
			limb_data[limb] = 1

	//Internal organ status
	for(var/org in organ_data)
		var/obj/item/organ/I = M.internal_organs_by_name[org]

		 //Who knows? Missing lungs maybe on synths, etc.
		if(!I)
			continue

		//This needs special handling because brains never think they are 'robotic', even posibrains
		if(org == O_BRAIN)
			switch(I.type)
				if(/obj/item/organ/internal/mmi_holder) //Assisted
					organ_data[org] = 1
				if(/obj/item/organ/internal/mmi_holder/posibrain) //Mechanical
					organ_data[org] = 2
				if(/obj/item/organ/internal/mmi_holder/robot) //Digital
					organ_data[org] = 3
				else //Anything else just give a brain to
					organ_data[org] = 0
			continue

		//Just set the data to this. 0:normal, 1:assisted, 2:mechanical, 3:digital
		organ_data[org] = I.robotic

	//Genetic modifiers
	for(var/modifier in M.modifiers)
		var/datum/modifier/mod = modifier
		if(mod.flags & MODIFIER_GENETIC)
			genetic_modifiers.Add(mod.type)

	if(add_to_db)
		SStranscore.add_body(src)
