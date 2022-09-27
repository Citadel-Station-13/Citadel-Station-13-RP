/datum/component/riding_filter/mob/human
	expected_typepath = /mob/living/carbon/human
	handler_typepath = /datum/component/riding_handler/mob/human
	offhand_requirements_are_rigid = FALSE

	/// offhands required to fireman someone
	var/ridden_offhands_needed_fireman = 1
	/// offhands required on the rider for piggybacking
	var/rider_offhands_needed_piggyback = 1

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

/datum/component/riding_handler/human/signal_hook_pre_buckle_mob(atom/movable/source, mob/M, flags, mob/user, semantic)
	var/mob/living/carbon/human/H = parent
	if(!isliving(M))
		return COMPONENT_BLOCK_BUCKLE_OPERATION
	var/mob/living/L = M
	var/size_difference = L.get_effective_size() - H.get_effective_size()
	if(size_difference >= 0.5)
		// too big rider
		to_chat(user, SPAN_WARNING("How do you intend on mounting [H] when you are that big?"))
		return COMPONENT_BLOCK_BUCKLE_OPERATION
	if(semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN || semantic == BUCKLE_SEMANTIC_HUMAN_PIGGYBACK)
		return NONE
	// try to climb onto taur
	if(user != M)
		return COMPONENT_BLOCK_BUCKLE_OPERATION
	if(!isTaurTail(H))
		return COMPONENT_BLOCK_BUCKLE_OPERATION
	user.visible_message(
		SPAN_NOTICE("[user] starts climbing up onto [H]..."),
		SPAN_NOTICE("You start climbing onto [H]...")
	)
	if(!do_after(user, 3 SECONDS, src))
		return
	user.visible_message(
		SPAN_NOTICE("[user] climbs up onto [H]."),
		SPAN_NOTICE("You climb onto [H].")
	)
	return COMPONENT_FORCE_BUCKLE_OPERATION
