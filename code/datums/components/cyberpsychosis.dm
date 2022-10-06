/*
Following a resurgence in interest regarding cybernetics, augments, and general Cyberpunk themes, I was asked if I could make Cyberpsychosis viable.
This is an attempt at that. It isn't intended to produce any serious long-term effects, so much as provide some internal feedback to Role-Play off of.
This feature is WIP. Here are my current wants/to-dos:
[]Occasional visual glitching, similar to hallucinations, but less pervasive.
[]Occasional audio glitching, as above.
[]Messages posted in the user's chat randomly. (Snippets of memories, visual glitching descriptions, intrusive thoughts, etc.)
[X]The creation of a specialized drug that can reduce the above symptoms when ingested.
[X]Related to the drug, some form of *temporarily* extending the time between symptom firing while the chem is in-system.
[]Some form of system that calculates "instability" based off of prosthetics, augments, and implants at spawn, that also increases when more are added.

The primary interest at the moment is getting this system functional so it can be added as a Neutral trait selection.
*/


//Author's Note: This trait should only be referred to as cyberpsychosis in code as easy reference shorthand.
//In-game it's known as Cybernetic Rejection Syndrome.

/datum/component/cyberpsychosis


/datum/component/cyberpsychosis/Initialize(radius)
	 if(!istype(parent))
		return COMPONENT_INCOMPATIBLE

	START_PROCESSING(SSobj, src)

/datum/component/cyberpsychosis/process()
	check_capacity()
	symptoms()

//This proc will tabulate the number of prosthetic limbs, organs, augments, and implants into a number, and subtract that from var/capacity, which is set to 100 by default.
/datum/component/cyberpsychosis/proc/check_capacity()

//This proc will provide different symptoms, with the frequency inversely related to the value of capacity.
//This is basically the one that all the above checkboxes will address.

//Credit to either Keek or Hati for this one. Gonna add it as a symptom message:
//"A point on the horizon, a melting scene from your memory, a frantic drift towards nothing. Machine, doomed to an infinite recursive loop. Teeth with teeth with teeth. This is where you abandon your dreams. You are a vortex of divine insolence. Cracks start to show. You're hurting."
/datum/component/cyberpsychosis/proc/symptoms()

/datum/component/cyberpsychosis/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
