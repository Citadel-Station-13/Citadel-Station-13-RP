/mob/living/carbon/human/afflict_stun(amount)
	if(MUTATION_HULK in mutations)
		return FALSE
	return ..()

/mob/living/carbon/human/afflict_knockdown(20 * amount)
	if(MUTATION_HULK in mutations)
		return FALSE
	return ..()

/mob/living/carbon/human/afflict_unconscious(amount)
	if(MUTATION_HULK in mutations)
		return FALSE
	return ..()
