//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	// todo: add clickchain flags to on attack hand and return flags properly..
	if(clickchain.performer.can_clickchain_unarmed_interact_with_mob(clickchain, NONE, src))
		. = handle_inbound_clickchain_unarmed_interaction(clickchain, NONE)
		if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
			return

/**
 * Called when about to **send** a clickchain interaction
 */
/mob/proc/can_clickchain_unarmed_interact_with_mob(datum/event_args/actor/clickchain/clickchain, clickchain_flags, mob/target, silent)
	return TRUE

/**
 * Called when receiving a clickchain interaction.
 *
 * * Called only when clickchain has proximity.
 * * Called before shieldcalls, so make sure to handle those.
 * * Routes to on_clickchain_x_interaction by default.
 *
 * @return clickchain_flags
 */
/mob/proc/handle_inbound_clickchain_unarmed_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	switch(clickchain.using_intent)
		if(INTENT_HELP)
			return handle_inbound_clickchain_help_interaction(clickchain, clickchain_flags)
		if(INTENT_DISARM)
			return handle_inbound_clickchain_disarm_interaction(clickchain, clickchain_flags)
		if(INTENT_GRAB)
			return handle_inbound_clickchain_grab_interaction(clickchain, clickchain_flags)
		if(INTENT_HARM)
			return handle_inbound_clickchain_harm_interaction(clickchain, clickchain_flags)

/**
 * Called when receiving a clickchain interaction.
 *
 * * This is called on the receiving (being attacked) side.
 * * Called only when clickchain has proximity.
 * * Called before shieldcalls, so make sure to handle those.
 *
 * @return clickchain flags
 */
/mob/proc/handle_inbound_clickchain_help_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = clickchain_flags
	var/intentful_hook_results = SEND_SIGNAL(clickchain.performer, COMSIG_MOB_MELEE_INTENTFUL_HOOK, clickchain, .)
	if(intentful_hook_results & RAISE_MOB_MELEE_INTENTFUL_SKIP)
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(intentful_hook_results & RAISE_MOB_MELEE_INTENTFUL_ACTION)
			. |= CLICKCHAIN_DID_SOMETHING

/**
 * Called when receiving a clickchain interaction.
 *
 * * This is called on the receiving (being attacked) side.
 * * Called only when clickchain has proximity.
 * * Called before shieldcalls, so make sure to handle those.
 *
 * @return clickchain flags
 */
/mob/proc/handle_inbound_clickchain_disarm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = clickchain_flags
	var/intentful_hook_results = SEND_SIGNAL(clickchain.performer, COMSIG_MOB_MELEE_INTENTFUL_HOOK, clickchain, .)
	if(intentful_hook_results & RAISE_MOB_MELEE_INTENTFUL_SKIP)
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(intentful_hook_results & RAISE_MOB_MELEE_INTENTFUL_ACTION)
			. |= CLICKCHAIN_DID_SOMETHING

/**
 * Called when receiving a clickchain interaction.
 *
 * * This is called on the receiving (being attacked) side.
 * * Called only when clickchain has proximity.
 * * Called before shieldcalls, so make sure to handle those.
 *
 * @return clickchain flags
 */
/mob/proc/handle_inbound_clickchain_grab_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = clickchain_flags
	var/intentful_hook_results = SEND_SIGNAL(clickchain.performer, COMSIG_MOB_MELEE_INTENTFUL_HOOK, clickchain, .)
	if(intentful_hook_results & RAISE_MOB_MELEE_INTENTFUL_SKIP)
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(intentful_hook_results & RAISE_MOB_MELEE_INTENTFUL_ACTION)
			. |= CLICKCHAIN_DID_SOMETHING

/**
 * Called when receiving a clickchain interaction.
 *
 * * This is called on the receiving (being attacked) side.
 * * Called only when clickchain has proximity.
 * * Called before shieldcalls, so make sure to handle those.
 *
 * @return clickchain flags
 */
/mob/proc/handle_inbound_clickchain_harm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = clickchain_flags
	var/intentful_hook_results = SEND_SIGNAL(clickchain.performer, COMSIG_MOB_MELEE_INTENTFUL_HOOK, clickchain, .)
	if(intentful_hook_results & RAISE_MOB_MELEE_INTENTFUL_SKIP)
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(intentful_hook_results & RAISE_MOB_MELEE_INTENTFUL_ACTION)
			. |= CLICKCHAIN_DID_SOMETHING
