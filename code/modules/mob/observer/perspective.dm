//? Darksight

/mob/observer/proc/assert_innate_darksight()
	if(ispath(darksight_innate))
		darksight_innate = new darksight_innate

/mob/observer/innate_darksight()
	assert_innate_darksight()
	return darksight_override || darksight_innate
