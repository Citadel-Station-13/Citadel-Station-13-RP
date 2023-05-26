//? Darksight

/mob/observer/proc/assert_innate_vision()
	if(ispath(vision_innate))
		vision_innate = new vision_innate

/mob/observer/innate_vision()
	assert_innate_vision()
	return vision_override || vision_innate
