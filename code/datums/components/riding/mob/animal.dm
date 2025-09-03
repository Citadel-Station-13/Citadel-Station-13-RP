/datum/component/riding_filter/mob/animal
	expected_typepath = /mob/living/simple_mob
	handler_typepath = /datum/component/riding_handler/mob/animal

/datum/component/riding_handler/mob/animal
	expected_typepath = /mob/living/simple_mob

/datum/component/riding_handler/mob/animal/controllable
	riding_handler_flags = CF_RIDING_HANDLER_IS_CONTROLLABLE
