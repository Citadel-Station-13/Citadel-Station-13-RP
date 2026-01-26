
#warn below

/obj/machinery/resleeving/body_printer
	/// Need to clean out it if it's full of exploded clone.
	var/mess = FALSE
	/// Don't eject them as soon as they are created.
	var/eject_wait = FALSE

/obj/machinery/resleeving/body_printer/grower_pod/process(delta_time)
	if(((occupant.health >= heal_level) || (occupant.health == occupant.maxHealth)) && (!eject_wait))
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		audible_message("\The [src] signals that the growing process is complete.")
		connected_message("Growing Process Complete.")
		locked = 0
		go_out()
		return

/// Start growing a human clone in the pod!
/obj/machinery/resleeving/body_printer/proc/growclone(var/datum/dna2/record/R)
	var/datum/mind/clonemind = locate(R.mind)
	locked = TRUE
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.dna.species)
	occupant = H

	if(!R.dna.real_name) // To prevent null names
		R.dna.real_name = "clone ([rand(0,999)])"
	H.real_name = R.dna.real_name
	H.descriptors = R.body_descriptors

	if(!R.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	else
		H.dna = R.dna
	H.set_cloned_appearance()
	return 1

	// //Get the DNA and generate a new mob
	// var/datum/dna2/record/R = current_project.legacy_dna
	// var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)

	// //Set the name or generate one
	// if(!R.dna.real_name)
	// 	R.dna.real_name = "clone ([rand(0,999)])"
	// H.real_name = R.dna.real_name

	// //Apply DNA
	// H.dna = R.dna.Clone()
	// for(var/trait in H.dna.species_traits)
	// 	if(!all_traits[trait])
	// 		continue
	// 	var/datum/trait/T = all_traits[trait]
	// 	T.apply(H.species, H)

/obj/machinery/resleeving/body_printer/verb/eject()
	set name = "Eject Cloner"
	set category = VERB_CATEGORY_OBJECT
	set src in oview(1)

	if(usr.stat != 0)
		return
	go_out()
	add_fingerprint(usr)

/obj/machinery/resleeving/body_printer/proc/go_out()
	if(locked)
		return

	if(mess) //Clean that mess and dump those gibs!
		mess = 0
		gibs(src.loc)
		update_icon()
		return

	if(!occupant)
		return

	occupant.forceMove(loc)
	occupant.update_perspective()

	eject_wait = 0 //If it's still set somehow.

	occupant = null

	update_icon()
	return

// Empties all of the beakers from the cloning pod, used to refill it
/obj/machinery/resleeving/body_printer/verb/empty_beakers()
	set name = "Eject Beakers"
	set category = VERB_CATEGORY_OBJECT
	set src in oview(1)

	if(usr.stat != 0)
		return

	add_fingerprint(usr)
	drop_beakers()
	return

// Actually does all of the beaker dropping
// Returns 1 if it succeeds, 0 if it fails. Added in case someone wants to add messages to the user.
/obj/machinery/resleeving/body_printer/proc/drop_beakers()
	if(LAZYLEN(containers))
		var/turf/T = get_turf(src)
		if(T)
			for(var/obj/item/reagent_containers/glass/G in containers)
				G.forceMove(T)
				containers -= G
		return	1
	return 0

/obj/machinery/resleeving/body_printer/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()

/obj/machinery/resleeving/body_printer/update_icon()
	..()
	icon_state = "pod_0"
	if(occupant && !(machine_stat & NOPOWER))
		icon_state = "pod_1"
	else if(mess)
		icon_state = "pod_g"
