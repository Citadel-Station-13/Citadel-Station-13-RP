
/obj/machinery/resleeving/body_printer/grower_pod
	name = "grower pod"
	catalogue_data = list(///datum/category_item/catalogue/information/organization/vey_med,
						/datum/category_item/catalogue/technology/resleeving)
	circuit = /obj/item/circuitboard/transhuman_clonepod

// TODO: this should be clone_pod or a subtype
//A full version of the pod
/obj/machinery/resleeving/body_printer/grower_pod/full/Initialize(mapload)
	. = ..()
	for(var/i = 1 to container_limit)
		containers += new /obj/item/reagent_containers/glass/bottle/biomass(src)

/obj/machinery/resleeving/body_printer/grower_pod/growclone(datum/resleeving_body_backup/current_project)
	//Manage machine-specific stuff.
	if(mess || attempting)
		return 0
	attempting = 1 //One at a time!!
	locked = 1
	eject_wait = 1
	spawn(30)
		eject_wait = 0

	// Remove biomass when the cloning is started, rather than when the guy pops out
	remove_biomass(CLONE_BIOMASS)

	//Get the DNA and generate a new mob
	var/datum/dna2/record/R = current_project.legacy_dna
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)
	H.set_species(R.dna.species)
	H.dna.base_species = R.dna.base_species //! Hacky way to get the DNA to work.

	//Fix the external organs
	for(var/part in current_project.legacy_limb_data)

		var/status = current_project.legacy_limb_data[part]
		if(status == null) continue //Species doesn't have limb? Child of amputated limb?

		var/obj/item/organ/external/O = H.organs_by_name[part]
		if(!O) continue //Not an organ. Perhaps another amputation removed it already.

		if(status == 1) //Normal limbs
			continue
		else if(status == 0) //Missing limbs
			O.remove_rejuv()
		else if(status) //Anything else is a manufacturer
			O.remove_rejuv() //Don't robotize them, leave them removed so robotics can attach a part.

	//Look, this machine can do this because [reasons] okay?!
	for(var/part in current_project.legacy_organ_data)

		var/status = current_project.legacy_organ_data[part]
		if(status == null) continue //Species doesn't have organ? Child of missing part?

		var/obj/item/organ/I = H.internal_organs_by_name[part]
		if(!I) continue//Not an organ. Perhaps external conversion changed it already?

		if(status == 0) //Normal organ
			continue
		else if(status == 1) //Assisted organ
			I.mechassist()
		else if(status == 2) //Mechanical organ
			I.robotize()
		else if(status == 3) //Digital organ
			I.digitize()

	occupant = H

	//Set the name or generate one
	if(!R.dna.real_name)
		R.dna.real_name = "clone ([rand(0,999)])"
	H.real_name = R.dna.real_name

	//Apply DNA
	H.dna = R.dna.Clone()
	for(var/trait in H.dna.species_traits)
		if(!all_traits[trait])
			continue
		var/datum/trait/T = all_traits[trait]
		T.apply(H.species, H)

	//Apply genetic modifiers
	for(var/modifier_type in R.genetic_modifiers)
		H.add_modifier(modifier_type)

	//Apply damage
	H.adjustCloneLoss((H.getMaxHealth() - H.getMinHealth())*-0.75)
	H.afflict_unconscious(20 * 4)
	H.update_health()

	//Grower specific mutations
	if(heal_level < 60)
		randmutb(H)
		H.dna.UpdateSE()
		H.dna.UpdateUI()

	//Update appearance, remake icons
	H.UpdateAppearance()
	H.sync_organ_dna()
	H.regenerate_icons()

	H.ooc_notes = current_project.legacy_ooc_notes
	H.flavor_texts = current_project.legacy_dna.flavor.Copy()
	H.resize(current_project.legacy_sizemult, FALSE)
	H.weight = current_project.legacy_weight
	// place mind lock to prevent body impersonation
	H.resleeving_place_mind_lock(current_project.mind_ref)
	if(current_project.legacy_custom_species_name)
		H.custom_species = current_project.legacy_custom_species_name

	//Suiciding var
	H.suiciding = 0

	//Making double-sure this is not set
	H.mind = null

	//Machine specific stuff at the end
	update_icon()
	attempting = 0
	return 1

/obj/machinery/resleeving/body_printer/grower_pod/process(delta_time)
	if(machine_stat & NOPOWER)
		if(occupant)
			locked = 0
			go_out()
		return

	if((occupant) && (occupant.loc == src))
		if(occupant.stat == DEAD)
			locked = 0
			go_out()
			connected_message("Clone Rejected: Deceased.")
			return

		else if(occupant.health < heal_level && occupant.getCloneLoss() > 0)

			 //Slowly get that clone healed and finished.
			occupant.adjustCloneLoss(-2 * heal_rate)

			//Premature clones may have brain damage.
			occupant.adjustBrainLoss(-(CEILING((0.5*heal_rate), 1)))

			//So clones don't die of oxyloss in a running pod.
			if(occupant.reagents.get_reagent_amount("inaprovaline") < 30)
				occupant.reagents.add_reagent("inaprovaline", 60)

			//Also heal some oxyloss ourselves because inaprovaline is so bad at preventing it!!
			occupant.adjustOxyLoss(-4)

			use_power(7500) //This might need tweaking.
			return

		else if(((occupant.health >= heal_level) || (occupant.health == occupant.maxHealth)) && (!eject_wait))
			playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
			audible_message("\The [src] signals that the growing process is complete.")
			connected_message("Growing Process Complete.")
			locked = 0
			go_out()
			return

	else if((!occupant) || (occupant.loc != src))
		occupant = null
		if(locked)
			locked = 0
		return
