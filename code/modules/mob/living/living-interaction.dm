//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/handle_inbound_clickchain_harm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	. |= on_receive_clickchain_unarmed_melee_interaction(clickchain, clickchain_flags)
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

/**
 * Called on us when we are being interacted with.
 *
 * @return clickchain flags
 */
/mob/living/proc/on_receive_clickchain_unarmed_melee_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return clickchain.performer.melee_attack_chain(clickchain, clickchain_flags)
