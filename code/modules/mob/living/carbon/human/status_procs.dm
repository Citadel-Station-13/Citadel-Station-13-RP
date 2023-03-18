/mob/living/carbon/human/afflict_stun(amount)
	if(MUTATION_HULK in mutations)
		return FALSE
	return ..()

/mob/living/carbon/human/Weaken(amount)
	if(MUTATION_HULK in mutations)
		return
	..()

/mob/living/carbon/human/Unconscious(amount)
	if(MUTATION_HULK in mutations)
		return
	// Notify our AI if they can now control the suit.
	if(wearing_rig && !stat && paralysis < amount) //We are passing out right this second.
		wearing_rig.notify_ai("<span class='danger'>Warning: user consciousness failure. Mobility control passed to integrated intelligence system.</span>")
	..()
