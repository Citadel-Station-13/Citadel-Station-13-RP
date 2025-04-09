//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* COMSIG_ITEM_MELEE_*_HOOK's *//

/**
 * From base of /item melee_impact(): (args)
 * * args are indexed according to CLICKCHAIN_MELEE_ARG_* defines.
 */
#define COMSIG_ITEM_MELEE_IMPACT_HOOK "item-melee-impact"

//* used for all COMSIG_ITEM_MELEE_*_HOOK's *//

/// skip default of current proc being hooked
#define RAISE_ITEM_MELEE_SKIP (1<<0)

// todo: legacy below
// todo: don't use clickchain flags for them, have a way for a component to tell others to stop handling
//* All of these return CLICKCHAIN_* flags. *//
/// from /obj/item/proc/item_attack_chain(): (datum/event_args/actor/clickchain/e_args, clickchain_flags)
#define COMSIG_ITEM_USING_AS_ITEM "using_as_item"
