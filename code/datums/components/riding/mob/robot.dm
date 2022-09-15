/datum/component/riding_filter/mob/robot
	expected_typepath = /mob/living/silicon/robot
	handler_typepath = /datum/component/riding_handler/mob/robot
	offhands_needed_rider = 1
	offhand_requirements_are_rigid = FALSE

/datum/component/riding_handler/mob/robot
	expected_typepath = /mob/living/silicon/robot
	riding_handler_flags = CF_RIDING_HANDLER_EPHEMERAL
	rider_check_flags = CF_RIDING_CHECK_INCAPACITATED
