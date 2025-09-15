//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/ai/double_click_on_special(atom/target, location, control, list/params)
	// TODO: refactor this, kinda funny how I wrote 'silicon control interaction allowed' should be
	//       made generic / not special and then just copypasted it lol
	if(IS_CONSCIOUS(src) && !control_disabled)
	// TODO: refactor both of these; latter uses usr, former idk
		if(ismob(target))
			ai_actual_track(target)
			return TRUE
		else if(isturf(target) || isturf(target.loc))
			target.move_camera_by_click()
			return TRUE
	return ..()

/mob/living/silicon/ai/silicon_control_interaction_allowed(atom/target, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(!IS_CONSCIOUS(src))
		actor.chat_feedback(
			SPAN_WARNING("You are unconscious."),
			target = src,
		)
		return FALSE
	if(control_disabled)
		actor.chat_feedback(
			SPAN_WARNING("Your wireless control is disabled."),
			target = src,
		)
		return FALSE
	return ..()

// this will probably need to be rewritten at some point but like.
// it works, right.
// plus what's the chances we need to implement AIs literally punching people
// haaaah..

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
