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
	rider_check_flags = CF_RIDING_CHECK_INCAPACITATED
	ridden_check_flags = CF_RIDING_CHECK_INCAPACITATED | CF_RIDING_CHECK_LYING
	rider_offsets = list(
		list(0, 6, 1, null),
		list(-8, 6, -1, null),
		list(0, 6, -1, null),
		list(8, 6, -1, null)
	)
	rider_offset_format = CF_RIDING_OFFSETS_DIRECTIONAL

/datum/component/riding_handler/mob/human/rider_offsets(mob/rider, pos, semantic, list/default, dir)
	if(semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN)
		. = default.Copy()
		.[1] = -2
		.[2] = 6
		switch(dir)
			if(NORTH)
				.[3] = -1
			else
				.[3] = 1
	else
		return ..()
