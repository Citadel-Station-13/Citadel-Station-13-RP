//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Called when trying to click something that the user can Reachability() to,
 * to allow for the tool system to intercept the attack as a tool action.
 */
/obj/item/proc/tool_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	SHOULD_NOT_OVERRIDE(TRUE)
	// are we on harm intent? if so, lol no
	if(clickchain.initiator?.a_intent == INTENT_HARM)
		return NONE
	return clickchain.target.tool_interaction(src, clickchain, clickchain_flags | CLICKCHAIN_TOOL_ACT)
