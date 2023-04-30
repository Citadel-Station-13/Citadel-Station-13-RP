//? darksight

/**
 * instantiates our darksight datum if it isn't
 */
/mob/living/simple_mob/proc/assert_innate_darksight()
	if(ispath(vision_innate))
		vision_innate = new vision_innate

/mob/living/simple_mob/innate_darksight()
	assert_innate_darksight()
	return vision_override || vision_innate
