//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: how to handle 'handled' state? we dont' want double-interactions if something 'consumes' the click.

//* All of these return CLICKCHAIN_* flags. *//

/// from /obj/item/proc/item_attack_chain(): (atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
#define COMSIG_ITEM_USING_AS_ITEM "using_as_item"
