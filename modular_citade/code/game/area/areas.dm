/area/proc/are_living_present()
	for(var/mob/living/L in src)
		if(L.stat != DEAD)
			return TRUE
	return FALSE
