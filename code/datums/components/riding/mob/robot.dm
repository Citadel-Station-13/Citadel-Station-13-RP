/datum/component/riding_filter/mob/robot
	expected_typepath = /mob/living/silicon/robot
	handler_typepath = /datum/component/riding_handler/mob/robot
	offhands_needed_rider = 1
	offhand_requirements_are_rigid = FALSE

/datum/component/riding_filter/mob/robot/check_mount_attempt(mob/M, buckle_flags, mob/user, semantic)
	if(!ishuman(M))
		return FALSE		// nah
	return ..()

/datum/component/riding_handler/mob/robot
	expected_typepath = /mob/living/silicon/robot
	riding_handler_flags = CF_RIDING_HANDLER_EPHEMERAL
	rider_check_flags = CF_RIDING_CHECK_INCAPACITATED
	rider_offsets = list(
		list(0, 6, 1, null),
		list(-8, 6, 1, null),
		list(0, 6, -1, null),
		list(8, 6, 1, null)
	)
	rider_offset_format = CF_RIDING_OFFSETS_DIRECTIONAL
