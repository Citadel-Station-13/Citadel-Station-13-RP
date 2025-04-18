//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/on_clickchain_harm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	. |= attempt_clickchain_harm(clickchain, clickchain_flags)
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

/**
 * @return clickchain flags
 */
/mob/living/proc/attempt_clickchain_harm(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return melee_attack_chain(clickchain, clickchain_flags)
