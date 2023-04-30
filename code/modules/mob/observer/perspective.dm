//? Darksight

/mob/observer/proc/assert_innate_darksight()
	if(ispath(vision_innate))
		vision_innate = new vision_innate

/mob/observer/innate_darksight()
	assert_innate_darksight()
	return vision_override || vision_innate
