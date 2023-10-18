/mob/living/silicon/ai/set_stat(new_stat, update_mobility)
	. = ..()
	if(!.)
		return
	GLOB.cameranet.updateVisibility(src, FALSE)
