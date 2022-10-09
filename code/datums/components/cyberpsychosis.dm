/*
Following a resurgence in interest regarding cybernetics, augments, and general Cyberpunk themes, I was asked if I could make Cyberpsychosis viable.
This is an attempt at that. It isn't intended to produce any serious long-term effects, so much as provide some internal feedback to Role-Play off of.
This feature is WIP. Here are my current wants/to-dos:
[]Occasional visual glitching, similar to hallucinations, but less pervasive.
[]Occasional audio glitching, as above.
[]Messages posted in the user's chat randomly. (Snippets of memories, visual glitching descriptions, intrusive thoughts, etc.)
[/]The creation of a specialized drug that can reduce the above symptoms when ingested.
[/]Related to the drug, some form of *temporarily* extending the time between symptom firing while the chem is in-system.
[X]Some form of system that calculates "instability" based off of prosthetics, augments, and implants at spawn, that also increases when more are added.

The primary interest at the moment is getting this system functional so it can be added as a Neutral trait selection.
*/

/datum/component/cyberpsychosis
	//var/capacity = 100
	var/cybernetics_count = 0
	var/counted = 0
	var/adjusted = 0

/datum/component/cyberpsychosis/Initialize(radius)
	if(!istype(parent))
		return COMPONENT_INCOMPATIBLE
	else
		START_PROCESSING(SSobj, src)

/datum/component/cyberpsychosis/process()
	update_cybernetics_count()
	update_capacity()
	symptoms()

//This proc will tabulate the number of prosthetic limbs, organs, augments, and implants into a number.
/datum/component/cyberpsychosis/proc/update_cybernetics_count()
	var/mob/living/carbon/human/H = parent
	. = 0
	if(counted)
		return
	else
		for(var/obj/item/organ/O in H.organs)
			if(O.robotic < ORGAN_ROBOT)
				cybernetics_count++
				counted = 1

//This subtracts the above sum from var/capacity, which is set to 100 by default.
/datum/component/cyberpsychosis/proc/update_capacity()
	var/mob/living/carbon/human/H = parent
	if(adjusted)
		return
	else if(cybernetics_count >= 1)
		H.capacity -= cybernetics_count*5
		adjusted = 1

//This proc will provide different symptoms, with the frequency inversely related to the value of capacity.
//This is basically the one that all the above checkboxes will address.
/datum/component/cyberpsychosis/proc/symptoms(var/mob/living/carbon/human/H)
	if(H.capacity >= 90)
		return

/*
/datum/reagent/paroxetine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>Your mind feels much less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, "<span class='notice'>Your mind feels much more stable.</span>")
			else
				to_chat(M, "<span class='warning'>Your mind breaks apart...</span>")
				M.hallucination += 200
*/





/datum/component/cyberpsychosis/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/*
//Subsystem for CRS
SUBSYSTEM_DEF(cyberpsychosis)
	name = "Cyernetics Rejection Syndrome"
	wait = 7

/datum/controller/subsystem/cyberpsychosis/fire(var/datum/component/cyberpsychosis/CRS)
	CRS.process()
*/
