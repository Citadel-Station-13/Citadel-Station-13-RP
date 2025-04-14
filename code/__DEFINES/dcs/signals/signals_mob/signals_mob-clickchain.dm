//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Fired with (clickchain, intent)
 */
#define COMSIG_
	#define

//* COMSIG_MOB_MELEE_*_HOOK's *//

/**
 * From base of /mob melee_attack(): (args)
 * * args are indexed according to CLICKCHAIN_MELEE_ARG_* defines.
 * * This fires before target runs melee_act.
 */
#define COMSIG_MOB_MELEE_ATTACK_HOOK "mob-melee-attack"

/**
 * From base of /mob melee_impact(): (args)
 * * args are indexed according to CLICKCHAIN_MELEE_ARG_* defines.
 */
#define COMSIG_MOB_MELEE_IMPACT_HOOK "mob-melee-impact"

//* used for all COMSIG_MOB_MELEE_*_HOOK's *//

/// skip default of current proc being hooked
#define RAISE_MOB_MELEE_SKIP (1<<0)
