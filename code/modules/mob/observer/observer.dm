/mob/observer
	name = "observer"
	desc = "This shouldn't appear"
	density = 0
	mobility_flags = NONE
	cached_multiplicative_slowdown = 0.5 // 20 tiles per second

	/// Our darksight
	var/datum/vision/baseline/vision_innate = /datum/vision/baseline/observer
