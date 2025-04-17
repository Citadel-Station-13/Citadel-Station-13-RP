//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * Called only when clickchain has proximity.
 * * Called before shieldcalls, so make sure to handle those.
 *
 * @return clickchain flags
 */
/mob/proc/clickchain_help_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return NONE

/**
 * * Called only when clickchain has proximity.
 * * Called before shieldcalls, so make sure to handle those.
 *
 * @return clickchain flags
 */
/mob/proc/clickchain_disarm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return NONE

/**
 * * Called only when clickchain has proximity.
 * * Called before shieldcalls, so make sure to handle those.
 *
 * @return clickchain flags
 */
/mob/proc/clickchain_grab_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return NONE

/**
 * * Called only when clickchain has proximity.
 * * Called before shieldcalls, so make sure to handle those.
 *
 * @return clickchain flags
 */
/mob/proc/clickchain_harm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return NONE


#warn hook these in
