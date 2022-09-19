/datum/component/riding_filter/mob/human
	expected_typepath = /mob/living/carbon/human
	handler_typepath = /datum/component/riding_handler/mob/human



/datum/component/riding_handler/mob/human
	expected_typepath = /mob/living/carbon/human
	riding_handler_flags = CF_RIDING_HANDLER_EPHEMERAL

/datum/component/riding_handler/mob/human/rider_layer_offset(dir, index, semantic)
	. = ..()



// /datum/component/riding_handler/human/handle_vehicle_layer()
// 	var/atom/movable/AM = parent
// 	if(AM.buckled_mobs && AM.buckled_mobs.len)
// 		for(var/mob/M in AM.buckled_mobs) //ensure proper layering of piggyback and carry, sometimes weird offsets get applied
// 			M.layer = MOB_LAYER
// 		if(!AM.buckle_lying)
// 			if(AM.dir == SOUTH)
// 				AM.layer = ABOVE_MOB_LAYER
// 			else
// 				AM.layer = OBJ_LAYER
// 		else
// 			if(AM.dir == NORTH)
// 				AM.layer = OBJ_LAYER
// 			else
// 				AM.layer = ABOVE_MOB_LAYER
// 	else
// 		AM.layer = MOB_LAYER

#warn finish

#warn we can't perfectly do this yet so add a hook that changes buckle_lying on the mob


#warn offsets
#warn how to push peopl eoff?

/datum/component/riding_handler/human/Initialize()
	. = ..()
	RegisterSignal(parent, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, .proc/signal_hook_host_unarmed_melee)

/datum/component/riding_handler/human/proc/signal_hook_host_unarmed_melee(datum/source, ...)
	#warn args?

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
	if(!isTaurTail(H))
		return COMPONENT_BLOCK_BUCKLE_OPERATION
	#warn impl - 2-3 second delay?


// /datum/component/riding_handler/human/proc/on_host_unarmed_melee(atom/target)
// 	var/mob/living/carbon/human/H = parent
// 	if(H.a_intent == INTENT_DISARM && (target in H.buckled_mobs))
// 		force_dismount(target)

// /datum/component/riding_handler/human/force_dismount(mob/living/user)
// 	var/atom/movable/AM = parent
// 	AM.unbuckle_mob(user)
// 	user.Paralyze(60)
// 	user.visible_message("<span class='warning'>[AM] pushes [user] off of [AM.p_them()]!</span>", \
// 						"<span class='warning'>[AM] pushes you off of [AM.p_them()]!</span>")
