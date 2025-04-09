/mob/observer
	name = "observer"
	desc = "This shouldn't appear"
	density = 0
	mobility_flags = NONE
	cached_hyperbolic_slowdown = 0.5 // 20 tiles per second
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER
	atom_flags = ATOM_NONWORLD | ATOM_HEAR

	/// Our darksight
	var/datum/vision/baseline/vision_innate = /datum/vision/baseline/observer
