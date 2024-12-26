//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Called when trying to click something that the user can Reachability() to,
 * to allow for the tool system to intercept the attack as a tool action.
 *
 * todo: should only have e_args and clickchain_flags as params.
 */
/obj/item/proc/tool_attack_chain(atom/target, mob/user, clickchain_flags, list/params)
	SHOULD_NOT_OVERRIDE(TRUE)
	// are we on harm intent? if so, lol no
	if(user && (user.a_intent == INTENT_HARM))
		return NONE
	return target.tool_interaction(src, new /datum/event_args/actor/clickchain(user, target = target, params = params), clickchain_flags | CLICKCHAIN_TOOL_ACT)
