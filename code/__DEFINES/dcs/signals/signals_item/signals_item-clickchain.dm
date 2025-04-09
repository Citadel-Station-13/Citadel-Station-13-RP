//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * From base of /obj/item melee_attack(): (args)
 * * args are indexed according to CLICKCHAIN_MELEE_ARG_* defines.
 */
#define COMSIG_ITEM_MELEE_ATTACK_HOOK "item-melee-attack"

// legacy below //

// todo: how to handle 'handled' state? we dont' want double-interactions if something 'consumes' the click.

//* All of these return CLICKCHAIN_* flags. *//

/// from /obj/item/proc/item_attack_chain(): (datum/event_args/actor/clickchain/e_args, clickchain_flags)
#define COMSIG_ITEM_USING_AS_ITEM "using_as_item"
