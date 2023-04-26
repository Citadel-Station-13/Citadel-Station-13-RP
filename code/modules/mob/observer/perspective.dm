//? Darksight

/mob/observer/proc/assert_innate_darksight()
	if(ispath(innate_darksight))
		innate_darksight = new innate_darksight

/mob/observer/innate_darksight()
	assert_innate_darksight()
	return innate_darksight
