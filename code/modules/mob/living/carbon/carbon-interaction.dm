//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station Developers           *//

/mob/living/carbon/on_clickchain_help_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(iscarbon(clickchain.performer))
		if(attempt_cpr_interaction(clickchain.performer))
			return . | CLICKCHAIN_DID_SOMETHING

/**
 * TODO: attempt_clickchain_cpr
 *
 * call to automatically attepmt a CPR interaction
 * usually done in attack hand for help intent
 *
 * return true to break the rest of the interaction chain (aka don't try to hug, etc)
 */
/mob/living/carbon/proc/attempt_cpr_interaction(mob/user)
	. = TRUE
	// must be in crit or dead
	// crit isn't a stat value so..
	if(!is_in_critical() && !IS_DEAD(src))
		return FALSE
	if(!check_has_mouth())
		to_chat(user, SPAN_WARNING("[src] has no mouth."))
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.check_has_mouth())
		to_chat(user, SPAN_WARNING("You are either not human, or have no mouth."))
		return
	var/obj/item/in_the_way
	for(in_the_way as anything in get_equipped_items_in_slots(
		SLOT_ID_HEAD,
		SLOT_ID_MASK
	))
		if(!(in_the_way.body_cover_flags & FACE))
			continue
		to_chat(user, SPAN_WARNING("[src]'s [in_the_way] is in the way!"))
		return
	for(in_the_way as anything in user.get_equipped_items_in_slots(
		SLOT_ID_HEAD,
		SLOT_ID_MASK
	))
		if(!(in_the_way.body_cover_flags & FACE))
			continue
		to_chat(user, SPAN_WARNING("Your [in_the_way] is in the way!"))
		return
	if(HAS_TRAIT(src, TRAIT_CPR_IN_PROGRESS))
		to_chat(user, SPAN_WARNING("Someone is already doing CPR on [src]!"))
		return
	INVOKE_ASYNC(src, PROC_REF(attempt_cpr), user)
