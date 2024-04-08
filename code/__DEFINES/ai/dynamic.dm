//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn anything?

//* state var

/// currently disabled
#define AI_DYNAMIC_STATE_DISABLED 0
/// idle; might be wandering
#define AI_DYNAMIC_STATE_IDLE 1
/// engaged in primary ranged combat
#define AI_DYNAMIC_STATE_RANGED_ENGAGEMENT 2
/// engaged in primary melee combat
#define AI_DYNAMIC_STATE_MELEE_ENGAGEMENT 3
/// engaged in guarding behavior
#define AI_DYNAMIC_STATE_HOLD_POSITION 4
/// engaged in COWARDICE
#define AI_DYNAMIC_STATE_FLEE_AND_RECOVER 5
/// engaged in patrolling
#define AI_DYNAMIC_STATE_PATROL_ROUTE 6

//* mode var

/// disabled
#define AI_DYNAMIC_MODE_DISABLED 0
/// noncombat - slow ticking, behaviors swapped to noncombat
#define AI_DYNAMIC_MODE_NONCOMBAT 1
/// combat - heightened ticking, behaviors swapped to combat
#define AI_DYNAMIC_MODE_COMBAT 2

//* Aiming *//

#define AI_DYNAMIC_AIM_TRUE 0
#define AI_DYNAMIC_AIM_FALSE 1
#define AI_DYNAMIC_AIM_MISS 2

//* Communication *//

/// silenced
#define AI_DYNAMIC_COMMUNICATION_NONE 0
/// "help dying maint"
#define AI_DYNAMIC_COMMUNICATION_BASIC 1
/// "help being killed by the secret lore police at 170, 131, 2"
#define AI_DYNAMIC_COMMUNICATION_FULL 2
