//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* old - pending update *//

/// from /obj/item/proc/item_attack_chain(): (datum/event_args/actor/clickchain/e_args, clickchain_flags)
/// * returns CLICKCHAIN_FLAG's
#define COMSIG_ITEM_USING_AS_ITEM "using_as_item"

//* melee_attack_chain *//

/**
 * From base of /item melee_impact(): (args)
 * * args are indexed according to CLICKCHAIN_MELEE_ATTACK_ARG_* defines.
 */
#define COMSIG_ITEM_MELEE_IMPACT_HOOK "item-melee-impact"
	#define RAISE_ITEM_MELEE_IMPACT_SKIP (1<<0)
