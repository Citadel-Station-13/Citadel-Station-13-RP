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

/mob/living/silicon/robot/verb/toggle_rider_control()

	set name = "Give Reins"
	set desc = "Give or take the person riding on you control of your movement."
	set category = VERB_CATEGORY_IC
	var/datum/component/riding_handler/mob/robot/riding_handler = GetComponent(/datum/component/riding_handler/mob/robot)
	if(!riding_handler)
		to_chat(src, "<span class='notice'>No one is riding you.</span>")
		return
	riding_handler.riding_handler_flags ^= CF_RIDING_HANDLER_IS_CONTROLLABLE
	to_chat(src, "<span class='notice'>You can [(riding_handler.riding_handler_flags & CF_RIDING_HANDLER_IS_CONTROLLABLE)? "now" : "no longer"] be controlled")
