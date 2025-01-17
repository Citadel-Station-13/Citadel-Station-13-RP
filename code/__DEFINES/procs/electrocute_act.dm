//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Flags for /atom/proc/electrocute_act(). *//

/// Shock comes from within entity. Should not run normal armor.
#define ELECTROCUTE_ACT_FLAG_INTERNAL (1<<0)
/// Should hit whole-body even if zone was specified
#define ELECTROCUTE_ACT_FLAG_DISTRIBUTE (1<<1)
/// Should hit whole-body equally, don't run distribution calculations
/// * Implies [ELECTROCUTE_ACT_FLAG_DISTRIBUTE]
#define ELECTROCUTE_ACT_FLAG_UNIFORM (1<<2)

//* Arg indices for /atom/proc/electrocute_act() return value list *//

#define ELECTROCUTE_ACT_ARG_EFFICIENCY 1
#define ELECTROCUTE_ACT_ARG_ENERGY 2
#define ELECTROCUTE_ACT_ARG_DAMAGE 3
#define ELECTROCUTE_ACT_ARG_AGONY 4
#define ELECTROCUTE_ACT_ARG_FLAGS 5
#define ELECTROCUTE_ACT_ARG_HIT_ZONE 6
#define ELECTROCUTE_ACT_ARG_SHARED_BLACKBOARD 7
#define ELECTROCUTE_ACT_ARG_OUT_ENERGY_CONSUME 8
