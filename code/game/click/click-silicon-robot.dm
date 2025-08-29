//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/robot/melee_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	clickchain.target.attack_robot(src)
	// TODO: better hiddenprint/tracing system that's actor-aware
	clickchain.target.add_hiddenprint(usr)
	return CLICKCHAIN_DO_NOT_PROPAGATE

/mob/living/silicon/robot/ranged_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	clickchain.target.attack_robot(src)
	// TODO: better hiddenprint/tracing system that's actor-aware
	clickchain.target.add_hiddenprint(usr)
	return CLICKCHAIN_DO_NOT_PROPAGATE

/mob/living/silicon/robot/silicon_control_interaction_allowed(atom/target, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// sigh. rework bolts when?
	if(bolt && !bolt.malfunction)
		actor?.chat_feedback(
			SPAN_WARNING("Your restraining bolt prevents you from doing that."),
			target = src,
		)
		return FALSE
	return TRUE
