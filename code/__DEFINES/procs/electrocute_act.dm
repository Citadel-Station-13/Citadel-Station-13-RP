//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Flags for /atom/proc/electrocute_act(). *//

/// Shock comes from within entity. Should not run normal armor.
/// * Implies [ELECTROCUTE_ACT_FLAG_IGNORE_ARMOR]
#define ELECTROCUTE_ACT_FLAG_INTERNAL (1<<0)
/// Should hit whole-body even if zone was specified
#define ELECTROCUTE_ACT_FLAG_DISTRIBUTE (1<<1)
/// Should hit whole-body equally, don't run distribution calculations
/// * Implies [ELECTROCUTE_ACT_FLAG_DISTRIBUTE]
#define ELECTROCUTE_ACT_FLAG_UNIFORM (1<<2)
/// Do not run protection calculations, for when you already calculated it.
#define ELECTROCUTE_ACT_FLAG_IGNORE_ARMOR (1<<3)
/// Do not run VFX, SFX, or message
#define ELECTROCUTE_ACT_FLAG_SILENT (1<<4)
/// Do not emit sparks, ignite things around the entity, etc
#define ELECTROCUTE_ACT_FLAG_CONTAINED (1<<5)
/// Do not apply default combat knockdown
#define ELECTROCUTE_ACT_FLAG_DO_NOT_STUN (1<<6)

//* Arg indices for /atom/proc/electrocute_act() return value list *//

#define ELECTROCUTE_ACT_ARG_EFFICIENCY 1
#define ELECTROCUTE_ACT_ARG_ENERGY 2
#define ELECTROCUTE_ACT_ARG_DAMAGE 3
#define ELECTROCUTE_ACT_ARG_AGONY 4
#define ELECTROCUTE_ACT_ARG_FLAGS 5
#define ELECTROCUTE_ACT_ARG_HIT_ZONE 6
#define ELECTROCUTE_ACT_ARG_SHARED_BLACKBOARD 7
#define ELECTROCUTE_ACT_ARG_OUT_ENERGY_CONSUMED 8
