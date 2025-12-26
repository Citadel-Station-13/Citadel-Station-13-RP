////////////////////////////////
//// Mind/body data storage system
//// for the resleeving tech
////////////////////////////////

/mob/living/carbon/human/var/resleeve_lock
/mob/living/carbon/human/var/original_player

/////// Mind-backup record ///////
/datum/transhuman/mind_record
	//User visible
	var/mindname = "!!ERROR!!"


	//Backend
	var/id_gender = MALE

/datum/transhuman/mind_record/New(var/datum/mind/mind, var/mob/living/carbon/human/M, var/add_to_db = TRUE, var/one_time = FALSE)
	ASSERT(mind)

	src.one_time = one_time

	//The mind!
	mind_ref = mind
	mindname = mind.name
	ckey = mind.ckey

	cryo_at = 0

	//Mental stuff the game doesn't keep mentally
	if(istype(M) || istype(M,/mob/living/carbon/brain/caught_soul))
		id_gender = M.identifying_gender
		languages = M.languages.Copy()
		mind_oocnotes = M.ooc_notes
		if(M.nif)
			nif_path = M.nif.type
			nif_durability = M.nif.durability
			var/list/nifsofts = list()
			for(var/N in M.nif.nifsofts)
				if(N)
					var/datum/nifsoft/nifsoft = N
					nifsofts += nifsoft.type
			nif_software = nifsofts
			nif_savedata = M.nif.save_data.Copy()

	last_update = world.time

	if(add_to_db)
		SStranscore.add_backup(src)

/datum/transhuman/body_record/New(var/copyfrom, var/add_to_db = 0, var/ckeylock = 0)
	..()
	if(istype(copyfrom, /datum/transhuman/body_record))
		init_from_br(copyfrom)
	else if(ishuman(copyfrom))
		init_from_mob(copyfrom, add_to_db, ckeylock)

/datum/transhuman/body_record/proc/init_from_mob(var/mob/living/carbon/human/M, var/add_to_db = 0, var/ckeylock = 0)
	ASSERT(!QDELETED(M))
	ASSERT(istype(M))

	//Person OOCly doesn't want people impersonating them
	locked = ckeylock

	//Prevent people from printing restricted and whitelisted species
	var/datum/species/S = SScharacters.resolve_species_name(M.dna.species)
	if(S)
		toocomplex = (S.species_spawn_flags & SPECIES_SPAWN_WHITELISTED) || (S.species_spawn_flags & SPECIES_SPAWN_SPECIAL)

	//General stuff about them
	synthetic = M.isSynthetic()
	speciesname = M.custom_species ? M.custom_species : null
	bodygender = M.gender
	body_oocnotes = M.ooc_notes
	sizemult = M.size_multiplier
	weight = M.weight
	aflags = M.appearance_flags

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


/**
 * Make a deep copy of this record so it can be saved on a disk without mofidications
 * to the original affecting the copy.
 * Just to be clear, this has nothing to do do with acutal biological cloning, body printing, resleeving,
 * or anything like that! This is the computer science concept of "cloning" a data structure!
 */
/datum/transhuman/body_record/proc/init_from_br(var/datum/transhuman/body_record/orig)
	ASSERT(!QDELETED(orig))
	ASSERT(istype(orig))
	src.mydna = new ()
	src.mydna.dna = orig.mydna.dna.Clone()
	src.mydna.ckey = orig.mydna.ckey
	src.mydna.id = orig.mydna.id
	src.mydna.name = orig.mydna.name
	src.mydna.types = orig.mydna.types
	src.mydna.flavor = orig.mydna.flavor.Copy()
	src.ckey = orig.ckey
	src.locked = orig.locked
	src.client_ref = orig.client_ref
	src.mind_ref = orig.mind_ref
	src.synthetic = orig.synthetic
	src.speciesname = orig.speciesname
	src.bodygender = orig.bodygender
	src.body_oocnotes = orig.body_oocnotes
	src.limb_data = orig.limb_data.Copy()
	src.organ_data = orig.organ_data.Copy()
	src.genetic_modifiers = orig.genetic_modifiers.Copy()
	src.toocomplex = orig.toocomplex
	src.sizemult = orig.sizemult
	src.aflags = orig.aflags
