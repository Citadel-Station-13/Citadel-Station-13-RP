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

/datum/component/riding_handler/mob/robot/controllable
	riding_handler_flags = CF_RIDING_HANDLER_EPHEMERAL|CF_RIDING_HANDLER_IS_CONTROLLABLE

/mob/living/silicon/robot/verb/toggle_rider_control()

	set name = "Give Reins"
	set desc = "Give or take the person riding on you control of your movement."
	set category = VERB_CATEGORY_IC
	var/datum/component/riding_filter/mob/robot/riding_filter = GetComponent(/datum/component/riding_filter/mob/robot)
	if(!riding_filter)
		to_chat(src, "<span class='warning'>Your form is incompatible with being ridden</warning>")
		return
	if(riding_filter.handler_typepath == /datum/component/riding_handler/mob/robot)
		riding_filter.handler_typepath = /datum/component/riding_handler/mob/robot/controllable
		to_chat(src, "<span class='notice'>You can now be controlled")
	else
		riding_filter.handler_typepath = /datum/component/riding_handler/mob/robot
		to_chat(src, "<span class='notice'>You can no longer be controlled")
	var/datum/component/riding_handler/mob/robot/riding_handler = GetComponent(/datum/component/riding_handler/mob/robot)
	if(!riding_handler)
		//No need to update the handler if it doesn't exist.
		return
	riding_handler.riding_handler_flags ^= CF_RIDING_HANDLER_IS_CONTROLLABLE

