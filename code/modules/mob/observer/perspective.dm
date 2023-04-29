//? Darksight

/mob/observer/proc/assert_innate_darksight()
	if(ispath(innate_darksight))
		darksight_innate = new darksight_innate

/mob/observer/innate_darksight()
	assert_innate_darksight()
	return override_darksight || darksight_innate
