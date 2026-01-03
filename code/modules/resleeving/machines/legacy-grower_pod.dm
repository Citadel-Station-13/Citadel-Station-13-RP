
#warn below

/obj/machinery/resleeving/body_printer/grower_pod/growclone(datum/resleeving_body_backup/current_project)
	locked = 1
	eject_wait = 1
	spawn(30)
		eject_wait = 0

	// Remove biomass when the cloning is started, rather than when the guy pops out
	remove_biomass(CLONE_BIOMASS)

	//Get the DNA and generate a new mob
	var/datum/dna2/record/R = current_project.legacy_dna
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)

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

	return 1

/obj/machinery/resleeving/body_printer/grower_pod/process(delta_time)
	if(((occupant.health >= heal_level) || (occupant.health == occupant.maxHealth)) && (!eject_wait))
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		audible_message("\The [src] signals that the growing process is complete.")
		connected_message("Growing Process Complete.")
		locked = 0
		go_out()
		return
