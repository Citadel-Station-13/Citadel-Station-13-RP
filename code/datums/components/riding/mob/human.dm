/datum/component/riding_filter/mob/human
	expected_typepath = /mob/living/carbon/human
	handler_typepath = /datum/component/riding_handler/mob/human
	offhand_requirements_are_rigid = FALSE

/datum/component/riding_filter/mob/human/rider_offhands_needed(semantic)
	return semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN? 0 : 1

/datum/component/riding_filter/mob/human/ridden_offhands_needed(semantic)
	return semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN? 1 : 0

/datum/component/riding_handler/mob/human
	expected_typepath = /mob/living/carbon/human
	riding_handler_flags = CF_RIDING_HANDLER_EPHEMERAL
	rider_check_flags = CF_RIDING_CHECK_INCAPACITATED
	ridden_check_flags = CF_RIDING_CHECK_INCAPACITATED | CF_RIDING_CHECK_LYING
	rider_offsets = list(
		list(0, 8, 1, null),
		list(0, 8, -1, null),
		list(4, 8, 1, null),
		list(-4, 8, 1, null)
	)
	rider_offset_format = CF_RIDING_OFFSETS_DIRECTIONAL

/datum/component/riding_handler/mob/human/rider_offsets(mob/rider, pos, semantic, list/default, dir)
	switch(dir)
		if(NORTH)
			. = default.Copy()
			.[3] = semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN? -1 : 1
		if(SOUTH)
			. = default.Copy()
			.[3] = semantic == BUCKLE_SEMANTIC_HUMAN_FIREMAN? 1 : -1
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
