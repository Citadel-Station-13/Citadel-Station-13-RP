//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Called to initiate a melee attack as ourselves.
 *
 * * This is a melee attack. This is not a grab, this is not a disarm.
 *   Those should be handled by other parts of the clickchain.
 *   If we are in this proc, it's because we're punching something or someone.
 *
 * @params
 * * e_args - the clickchain data, including who's doing the interaction
 * * clickchain_flags - the clickchain flags given
 *
 * @return CLICKCHAIN_* flags. These are added / interpreted by the caller.
 */
/mob/proc/melee_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)


#warn deal with this trainwreck
