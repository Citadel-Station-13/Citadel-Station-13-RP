/*
Following a resurgence in interest regarding cybernetics, augments, and general Cyberpunk themes, I was asked if I could make Cyberpsychosis viable.
This is an attempt at that. It isn't intended to produce any serious long-term effects, so much as provide some internal feedback to Role-Play off of.
This feature is WIP. Here are my current wants/to-dos:
[]Occasional visual glitching, similar to hallucinations, but less pervasive.
[]Occasional audio glitching, as above.
[]Messages posted in the user's chat randomly. (Snippets of memories, visual glitching descriptions, intrusive thoughts, etc.)
[X]The creation of a specialized drug that can reduce the above symptoms when ingested.
[X]Related to the drug, some form of *temporarily* extending the time between symptom firing while the chem is in-system.
[/]Some form of system that calculates "instability" based off of prosthetics, augments, and implants at spawn, that also increases when more are added.

The primary interest at the moment is getting this system functional so it can be added as a Neutral trait selection.
*/

/datum/component/cyberpsychosis
	var/capacity = 100
	var/cybernetics_count = 0

/datum/component/cyberpsychosis/Initialize(radius)
	if(!istype(parent))
		return COMPONENT_INCOMPATIBLE
	else
		START_PROCESSING(SSobj, src)

/datum/component/cyberpsychosis/process(times_fired)
	if(!(times_fired % 60))
		update_cybernetics_count()
		update_capacity()
		symptoms()

//This proc will tabulate the number of prosthetic limbs, organs, augments, and implants into a number.
/datum/component/cyberpsychosis/proc/update_cybernetics_count()
	. = 0
	var/mob/living/carbon/human/H = parent
	for(var/obj/item/organ/O in H.organs)
		if(O.robotic < ORGAN_ROBOT)
			cybernetics_count++

//This subtracts the above sum from var/capacity, which is set to 100 by default.
/datum/component/cyberpsychosis/proc/update_capacity()
	if(cybernetics_count >= 1)
		capacity -= min(100, (cybernetics_count*10))

//This proc will provide different symptoms, with the frequency inversely related to the value of capacity.
//This is basically the one that all the above checkboxes will address.
/datum/component/cyberpsychosis/proc/symptoms()
	if(capacity >= 90)
		return

/datum/component/cyberpsychosis/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

//Subsystem for CRS
SUBSYSTEM_DEF(cyberpsychosis)
	name = "Cyernetics Rejection Syndrome"
	wait = 7

/datum/controller/subsystem/cyberpsychosis/fire(var/datum/component/cyberpsychosis/CRS)
	CRS.process()
