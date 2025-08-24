//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/ai/double_click_on(atom/target, location, control, raw_params)
	. = ..()

/mob/living/silicon/ai/silicon_control_interaction_allowed(atom/target, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(!IS_CONSCIOUS(src))
		#warn feedback
		return FALSE
	if(control_disabled)
		#warn feedback
		return FALSE

/mob/living/silicon/ai/click_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/active_item)


#warn impl all; double_click_on

