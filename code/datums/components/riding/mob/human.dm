/datum/component/riding_filter/mob/human
	expected_typepath = /mob/living/carbon/human
	handler_typepath = /datum/component/riding_handler/mob/human

	#warn how to differentiate modes on filter?

/datum/component/riding_handler/mob/human
	expected_typepath = /mob/living/carbon/human
	riding_handler_flags = CF_RIDING_HANDLER_EPHEMERAL

	/// carry mode
	var/list/modes = list()

/datum/component/riding_handler/mob/human/on_rider_unbuckled(mob/rider)
	. = ..()
	// unref
	modes -= rider

/datum/component/riding_handler/mob/human/on_rider_buckled(mob/rider)
	. = ..()
	#warn impl

/datum/component/riding_handler/mob/human/proc/initiate_piggyback(mob/living/carbon/human/H)

/datum/component/riding_handler/mob/human/proc/initiate_fireman(mob/living/carbon/human/H)






///////Yes, I said humans. No, this won't end well...//////////
/datum/component/riding_handler/human
	del_on_unbuckle_all = TRUE

/datum/component/riding_handler/human/Initialize()
	. = ..()
	RegisterSignal(parent, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, .proc/on_host_unarmed_melee)

/datum/component/riding_handler/human/proc/on_host_unarmed_melee(atom/target)
	var/mob/living/carbon/human/H = parent
	if(H.a_intent == INTENT_DISARM && (target in H.buckled_mobs))
		force_dismount(target)

/datum/component/riding_handler/human/handle_vehicle_layer()
	var/atom/movable/AM = parent
	if(AM.buckled_mobs && AM.buckled_mobs.len)
		for(var/mob/M in AM.buckled_mobs) //ensure proper layering of piggyback and carry, sometimes weird offsets get applied
			M.layer = MOB_LAYER
		if(!AM.buckle_lying)
			if(AM.dir == SOUTH)
				AM.layer = ABOVE_MOB_LAYER
			else
				AM.layer = OBJ_LAYER
		else
			if(AM.dir == NORTH)
				AM.layer = OBJ_LAYER
			else
				AM.layer = ABOVE_MOB_LAYER
	else
		AM.layer = MOB_LAYER

/datum/component/riding_handler/human/force_dismount(mob/living/user)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(user)
	user.Paralyze(60)
	user.visible_message("<span class='warning'>[AM] pushes [user] off of [AM.p_them()]!</span>", \
						"<span class='warning'>[AM] pushes you off of [AM.p_them()]!</span>")
