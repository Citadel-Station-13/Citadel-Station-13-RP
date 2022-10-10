/*
Following a resurgence in interest regarding cybernetics, augments, and general Cyberpunk themes, I was asked if I could make Cyberpsychosis viable.
This is an attempt at that. It isn't intended to produce any serious long-term effects, so much as provide some internal feedback to Role-Play off of.
Initial Design Goals (X = Complete, / = WIP):
[/]Occasional visual glitching, similar to hallucinations, but less pervasive.
[/]Occasional audio glitching, as above.
[/]Messages posted in the user's chat randomly. (Snippets of memories, visual glitching descriptions, intrusive thoughts, etc.)
[X]The creation of a specialized drug that can reduce the above symptoms when ingested.
[X]Related to the drug, some form of temporarily extending the time between symptom firing while the chem is in-system.
[X]Some form of system that calculates "instability" based off of prosthetics, augments, and implants at spawn, that also increases when more are added.
*/

/datum/component/cyberpsychosis
	var/capacity = 100
	var/cybernetics_count = 0
	var/counted = 0
	var/adjusted = 0
	var/medicated = 0

/datum/component/cyberpsychosis/Initialize(radius)
	if(!istype(parent))
		return COMPONENT_INCOMPATIBLE
	else
		START_PROCESSING(SSobj, src)

/datum/component/cyberpsychosis/process()
	count_cybernetics()
	update_capacity()
	update_medication()
	//symptoms()

//This proc will tabulate the number of prosthetic limbs, organs, augments, and implants into a number.
/datum/component/cyberpsychosis/proc/count_cybernetics()
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
	if(adjusted)
		return
	if(!adjusted && cybernetics_count >= 1)
		capacity -= cybernetics_count*5
		adjusted = 1

/datum/component/cyberpsychosis/proc/update_medication()
	var/mob/living/carbon/human/H = parent
	if(!medicated && H.reagents.has_reagent("neuratrextate", 1))
		medicated = 1
	if(medicated && !H.reagents.has_reagent("neuratrextate", 1))
		medicated = 0

//Dynamically changing the Capacity of a cyberware user isn't really working out.
//So instead I think we can just flag them as medicated, and use that as a check in rendering symptoms.
//This proc will provide different symptoms, with the frequency inversely related to the value of capacity.
//This is basically the one that all the above checkboxes will address.
/*
/datum/component/cyberpsychosis/proc/symptoms(var/mob/living/carbon/human/H)
	if(capacity >= 90)
		return //This level is benign in terms of capacity loss. Don't want to just dump symptoms on them in the daily.
	if(capacity < 90)
		//At this level, we just want snippets of memories and audible hallucinations.
	if(capacity < 70)
		//At this level, the user starts to get snippets and messages reminding them of past memories. If this is coded right, they cascade down to the bottom.
	if(capacity < 40)
		//At this level, the victim begins to have more pronounced visual hallucinations, on top of the stacking symptoms above.
	if(capacity < 20)
		//The user's condition is rapidly degrading. More aggressive and intrusive messages come into play. Paranoia and aggravation increases.
	if(capacity < 10)
		//This is the most critical level. On top of stacking everything above, this should be pretty critical in some way.
		//Deafness? Berserk?

//Examples?
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
