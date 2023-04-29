//? darksight

/**
 * instantiates our darksight datum if it isn't
 */
/mob/living/simple_mob/proc/assert_innate_darksight()
	if(ispath(darksight_innate))
		darksight_innate = new darksight_innate

/mob/living/simple_mob/innate_darksight()
	assert_innate_darksight()
	return darksight_override || darksight_innate
