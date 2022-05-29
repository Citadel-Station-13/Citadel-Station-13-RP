/datum/category_item/catalogue/fauna/brain
	name = "Heuristic Processor"
	desc = "Sapient life in all of its many forms requires some version \
	of heuristic learning mechanism. From organic neural tissue to silicon \
	chips with personality matrices, this processor may take any number of \
	forms."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/brain)

// Obtained by scanning all Brains.
/datum/category_item/catalogue/fauna/all_brains
	name = "Collection - Heuristics"
	desc = "You have scanned a large array of different types of heuristic \
	processor, and therefore you have been granted a fair sum of points, \
	through this entry."
	value = CATALOGUER_REWARD_EASY
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/brain/organic,
		/datum/category_item/catalogue/fauna/brain/assisted,
		/datum/category_item/catalogue/fauna/brain/posibrain,
		/datum/category_item/catalogue/fauna/brain/robotic
		)

/datum/category_item/catalogue/fauna/brain/organic
	name = "Heuristics - Organic"
	desc = "Generally the most recognizable form of processor, the brain \
	is a densely packed network of neurons which fire electrical impulses \
	between themselves in a complex pseudo-quantum method of rapid computation. \
	Although other organic life forms possess similar analogues, the Galactic \
	community refers to the organic processor by the human term: 'brain'."
	value = CATALOGUER_REWARD_TRIVIAL

//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"
	no_vore = TRUE
	catalogue_data = list(/datum/category_item/catalogue/fauna/brain/organic)

/mob/living/carbon/brain/Initialize(mapload)
	. = ..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

/mob/living/carbon/brain/Destroy()
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat!=DEAD)	//If not dead.
			death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	return ..()

/mob/living/carbon/brain/update_canmove()
	if(in_contents_of(/obj/mecha) || istype(loc, /obj/item/mmi))
		canmove = 1
		use_me = 1
	else
		canmove = 0
	return canmove

/mob/living/carbon/brain/isSynthetic()
	return istype(loc, /obj/item/mmi)

///mob/living/carbon/brain/binarycheck()//No binary without a binary communication device
//	return isSynthetic()
