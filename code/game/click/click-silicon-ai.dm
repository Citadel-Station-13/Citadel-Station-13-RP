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


/mob/living/silicon/ai/melee_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	clickchain.target.attack_ai(src)
	// TODO: better hiddenprint/tracing system that's actor-aware
	clickchain.target.add_hiddenprint(usr)
	return CLICKCHAIN_DO_NOT_PROPAGATE

/mob/living/silicon/ai/ranged_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	clickchain.target.attack_ai(src)
	// TODO: better hiddenprint/tracing system that's actor-aware
	clickchain.target.add_hiddenprint(usr)
	return CLICKCHAIN_DO_NOT_PROPAGATE

#warn impl all; double_click_on

