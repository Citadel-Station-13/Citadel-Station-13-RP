/mob/living/silicon/reset_perspective(datum/perspective/P, apply = TRUE, forceful = TRUE, no_optimizations)
	. = ..()
	cameraFollow = null

/mob/living/silicon/make_perspective()
	. = ..()
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/augmented, INNATE_TRAIT)

/mob/living/silicon/innate_vision()
	return vision_override || GLOB.silicon_darksight
