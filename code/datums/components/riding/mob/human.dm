/datum/component/riding_filter/mob/human
	expected_typepath = /mob/living/carbon/human
	handler_typepath = /datum/component/riding_handler/mob/human
	offhand_requirements_are_rigid = FALSE

	/// offhands required to fireman someone
	var/ridden_offhands_needed_fireman = 1
	/// offhands required on the rider for piggybacking
	var/rider_offhands_needed_piggyback = 1

/datum/component/riding_filter/mob/human/check_mount_attempt(mob/M, buckle_flags, mob/user, semantic)
	if(!ishuman(M))
		return FALSE		// nah
	var/mob/living/carbon/human/H = parent
	var/saddle = H.item_by_slot_id(SLOT_ID_BACK)
	if(saddle && istype(saddle, /obj/item/storage/backpack/saddlebag_common))
		rider_offhands_needed_piggyback = FALSE
	else
		rider_offhands_needed_piggyback = TRUE
	return ..()

/datum/component/riding_filter/mob/human/rider_offhands_needed(mob/rider, semantic)
	return semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN? 0 : rider_offhands_needed_piggyback

/datum/component/riding_filter/mob/human/ridden_offhands_needed(mob/rider, semantic)
	. = ..()
	if(!rider)
		var/atom/movable/AM = parent
		var/tally = 0
		for(var/i in AM.buckled_mobs)
			if(AM.buckled_mobs[i] == BUCKLE_SEMANTIC_HUMAN_FIREMAN)
				tally = 1
				break
		return max(., tally)
	. = max(., semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN? ridden_offhands_needed_fireman : 0)

/datum/component/riding_handler/mob/human
	expected_typepath = /mob/living/carbon/human
	riding_handler_flags = CF_RIDING_HANDLER_EPHEMERAL
	ridden_check_flags = CF_RIDING_CHECK_INCAPACITATED | CF_RIDING_CHECK_LYING
	rider_offsets = list(
		list(0, 6, 1, null),
		list(-8, 6, -1, null),
		list(0, 6, -1, null),
		list(8, 6, -1, null)
	)
	rider_offset_format = CF_RIDING_OFFSETS_DIRECTIONAL
	var/taur_handling = FALSE

/datum/component/riding_handler/mob/human/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	var/mob/living/carbon/human/H = parent
	taur_handling = isTaurTail(H.tail_style)


/datum/component/riding_handler/mob/human/rider_offsets(mob/rider, pos, semantic, list/default, dir)
	. = ..()
	if(taur_handling)//Already centering on it
		.[1] = 0
		.[2] = 3 //Also don't climb too high
	if(semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN)
		.[1] = -2
		.[2] = 6
		switch(dir)
			if(NORTH)
				.[3] = -1
			if(EAST)
				if(taur_handling)
					.[1] = 6 //8 to remove the taur offset, the -2 of the fireman carry
			if(SOUTH)
				.[3] = 1
			if(WEST)
				if(taur_handling)
					.[1] = -10

/datum/component/riding_handler/mob/human/controllable
	riding_handler_flags = CF_RIDING_HANDLER_EPHEMERAL|CF_RIDING_HANDLER_IS_CONTROLLABLE
