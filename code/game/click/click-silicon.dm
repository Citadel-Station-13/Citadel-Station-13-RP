//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/click_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/active_item)
	// first, the camera hook
	if(aiCamera?.in_camera_mode)
		aiCamera.camera_mode_off()
		aiCamera.captureimage(clickchain.target, src, clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	// The hooks to perform AI control are before 'ranged_interaction_chain'
	// as I don't know if we will at some point add, oh, I don't know, modules that let AIs
	// fire lasers out of their core or something.
	if(!active_item)
		. = silicon_control_interaction_chain(clickchain.target, clickchain, clickchain, clickchain_flags)
		if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
			return
	return . | ..()

/**
 * Notice how weird the proc args are? That's because this can be called with a variety of manners,
 * and clickchain data isn't always available.
 *
 * If you have a function that should require clickchain, like a lot of the default functions,
 * simply do nothing. The default function for this should be to open an UI anyways.
 *
 * Unfortunately, this entire system does not support admin AI interact; this was deemed
 * acceptable because admin AI interact should probably be a sideband from actual AI interact
 * in the first place, with all the AI reworks planned for this codebase.
 */
/mob/living/silicon/proc/silicon_control_interaction_chain(atom/target, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	if(!silicon_control_interaction_allowed(target, actor, clickchain, clickchain_flags))
		return clickchain_flags | CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	var/list/click_params = clickchain.click_params
	var/executed_something
	if(click_params["shift"])
		if(click_params["ctrl"])
			executed_something = target.on_silicon_control_ctrl_shift_click(src, actor, clickchain, clickchain_flags) && "ctrl-shift"
		else
			executed_something = target.on_silicon_control_shift_click(src, actor, clickchain, clickchain_flags) && "shift"
	else if(click_params["ctrl"])
		executed_something = target.on_silicon_control_ctrl_click(src, actor, clickchain, clickchain_flags) && "ctrl"
	else if(click_params["alt"])
		executed_something = target.on_silicon_control_alt_click(src, actor, clickchain, clickchain_flags) && "alt"
	else if(click_params["button"] == "middle")
		executed_something = target.on_silicon_control_middle_click(src, actor, clickchain, clickchain_flags) && "middle"
	if(executed_something)
		clickchain.data[ACTOR_DATA_SILICON_CONTROL_LOG] ||= executed_something
		// TODO: better hiddenprint/tracing system that's actor-aware
		target?.add_hiddenprint(usr)
		return clickchain_flags | CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return clickchain_flags

/**
 * This proc is never silent and should always tell the user what's wrong. This should not be called
 * outside of user invocations. Do not overload this proc with snowflake behavior if you can help it.
 * * Entities can still do their own checks down the line; this checks if we're allowed to interact at all.
 */
/mob/living/silicon/proc/silicon_control_interaction_allowed(atom/target, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	return TRUE

/**
 * * User argument provided for easy handling. Please emit feedback via actor.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_ctrl_shift_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE

/**
 * * User argument provided for easy handling. Please emit feedback via actor.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_shift_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE

/**
 * * User argument provided for easy handling. Please emit feedback via actor.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_ctrl_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE

/**
 * * User argument provided for easy handling. Please emit feedback via actor.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_alt_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE

/**
 * * Please do not put important functions on this. For accessibility reasons, we cannot assume the middle button exists for all users.
 * * User argument provided for easy handling. Please emit feedback via actor.bubble_feedback() and similar procs.
 * @return TRUE to prevent propagation of the click normally.
 */
/atom/proc/on_silicon_control_middle_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE
