/*
Following a resurgence in interest regarding cybernetics, augments, and general Cyberpunk themes, I was asked if I could make Cyberpsychosis viable.
This is an attempt at that. It isn't intended to produce any serious long-term effects, so much as provide some internal feedback to Role-Play off of.
This feature is WIP. Here are my current wants/to-dos:
*Occasional visual glitching, similar to hallucinations, but less pervasive.
*Occasional audio glitching, as above.
*Messages posted in the user's chat randomly. (Snippets of memories, visual glitching descriptions, intrusive thoughts, etc.)
*The creation of a specialized drug that can reduce the above symptoms when ingested.
*Related to the drug, some form of *temporarily* extending the time between symptom firing while the chem is in-system.
*Some form of system that calculates "instability" based off of prosthetics, augments, and implants at spawn, that also increases when more are added.

The primary interest at the moment is getting this system functional so it can be added as a Neutral trait selection.
*/

/datum/component/cyberpsychosis

/datum/component/cyberpsychosis/Initialize(radius)
	if(!istype(parent))
		return COMPONENT_INCOMPATIBLE
	else
		START_PROCESSING(SSobj, src)

/datum/component/cyberpsychosis/process()
	check_capacity()
	symptoms()

//This proc will tabulate the number of prosthetic limbs, organs, augments, and implants into a number, and subtract that from var/capacity, which is set to 100 by default.
/datum/component/cyberpsychosis/proc/check_capacity(var/mob/living/carbon/human/H)
	/*
	if(ishuman(H))
		if(H.internal_organs.len)
			for(var/obj/item/organ/external/E in H.organs)
				if(E.robotic >= ORGAN_ROBOT)
					H.capacity--
		if(H.internal_organs.len)
			for(var/obj/item/organ/O in H.internal_organs)
				if(O.robotic >= ORGAN_ROBOT)
					H.capacity--
	*/
	H.capacity -= H.robolimb_count*10-max(0,H.robolimb_count*10-30)

//This proc will provide different symptoms, with the frequency inversely related to the value of capacity.
//This is basically the one that all the above checkboxes will address.
/datum/component/cyberpsychosis/proc/symptoms(var/mob/living/carbon/human/H)
	if(H.capacity >= 90)
		return

/datum/component/cyberpsychosis/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
