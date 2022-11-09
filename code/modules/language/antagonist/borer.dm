/datum/language/corticalborer
	id = LANGUAGE_ID_BORER
	name = "Cortical Link"
	desc = "Cortical borers possess a strange link between their tiny minds."
	speech_verb = "sings"
	ask_verb = "sings"
	exclaim_verb = "sings"
	colour = "alien"
	key = "" //!! THIS DOES NOT HAVE A LANGUAGE KEY IF YOU SOMEHOW MIRACULOUSLY GET ANTAGS WORKING ON RP BEFORE WE TRANSITION TO SS14 IN LIKE 2025 PUT ONE IN.
	machine_understands = 0
	language_flags = RESTRICTED | HIVEMIND

/datum/language/corticalborer/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	var/mob/living/simple_mob/animal/borer/B

	if(istype(speaker,/mob/living/carbon))
		var/mob/living/carbon/M = speaker
		B = M.has_brain_worms()
	else if(istype(speaker,/mob/living/simple_mob/animal/borer))
		B = speaker

	if(B)
		speaker_mask = B.true_name
	..(speaker,message,speaker_mask)
