//? darksight

/**
 * instantiates our darksight datum if it isn't
 */
/mob/living/simple_mob/proc/assert_innate_darksight()
	if(ispath(innate_darksight))
		innate_darksight = new innate_darksight

/mob/living/simple_mob/innate_darksight()
	assert_innate_darksight()
	return innate_darksight
