//? darksight

/**
 * instantiates our darksight datum if it isn't
 */
/mob/living/simple_mob/proc/assert_innate_vision()
	if(ispath(vision_innate))
		vision_innate = new vision_innate

/mob/living/simple_mob/innate_vision()
	assert_innate_vision()
	return vision_override || vision_innate
