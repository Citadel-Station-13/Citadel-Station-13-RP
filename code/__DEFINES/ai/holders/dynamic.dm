//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? Definitions for /datum/ai_holder/dynamic.

#warn anything?

//* state var

/// currently disabled
#define AI_DYNAMIC_STATE_DISABLED 0 + 1

/// idle; might be wandering
#define AI_DYNAMIC_STATE_IDLE 10 + 1
/// * under this state, we are using idle loop for movement
/// engaged in patrolling
#define AI_DYNAMIC_STATE_PATROL 10 + 2
/// * under this state, we are using navigation for movement
/// navigating to destination
#define AI_DYNAMIC_STATE_NAVIGATION 10 + 3
/// * under this state, we are using navigation for movement

/// ranged combat; stay at average effective engagement distance and fight
/// * under this state, we are using the combat planner for movement
#define AI_DYNAMIC_STATE_STRAFE 20 + 1
/// melee combat; stay at maximally effective engagement distance and fight
///               melee weapons will be preferred
///               ranged weapons, however, may be chosen to be used instead (point blanking)
/// * under this state, we are using the combat planner for movement
#define AI_DYNAMIC_STATE_CQC 20 + 2
/// hold position at **home**
#define AI_DYNAMIC_STATE_GUARD 20 + 3
/// fleeing towards **home**
/// * under this state, we are using navigation for movement
#define AI_DYNAMIC_STATE_RETREAT 20 + 4
/// fleeing towards somewhere that isn't home
/// * under this state, we are using navigation for movement
#define AI_DYNAMIC_STATE_FLEE 20 + 5
/// move towards somewhere while shooting
/// * under this state, we are using navigation for movement
/// * chase behaviors are also used for this, because chases are highly interruptible.
#define AI_DYNAMIC_STATE_FLANK 20 + 6

//* mode var

/// disabled: disabled
#define AI_DYNAMIC_MODE_DISABLED 0
/// passive: idle, navigation, patrol
#define AI_DYNAMIC_MODE_PASSIVE 1
/// combat: ranged, melee, hold, flee
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

//* Factions *//

/// someone is our teammate
#define AI_DYNAMIC_FACTION_CHECK_GOOD 0
/// someone is getting a little dicey (FF'd, etc; warn them)
#define AI_DYNAMIC_FACTION_CHECK_LOUSY 1
/// dunk that mf
#define AI_DYNAMIC_FACTION_CHECK_TEAMKILLER 2
/// they're not in our faction
#define AI_DYNAMIC_FACTION_CHECK_UNKNOWN 3
/// they're an enemy
#define AI_DYNAMIC_FACTION_CHECK_ENEMY 4

//* Telegraphing *//

/// do not use this as a real telegraph tier; pass this in to never pre-empt; used to check if we're telegraphing
#define AI_DYNAMIC_TELEGRAPH_CHECK -1
/// passive telegraphed action, like RP fluff
#define AI_DYNAMIC_TELEGRAPH_FLUFF 0
/// baseline combat telegraph for things like healing yourself
#define AI_DYNAMIC_TELEGRAPH_OPPORTUNISTIC 1
/// combat telegraph for stuff like performing an aimed shot, throwing a grenade, etc
#define AI_DYNAMIC_TELEGRAPH_OFFENSIVE 2
/// telegraph for stuff like running away / maximally important
#define AI_DYNAMIC_TELEGRAPH_CRITICAL 3
/// do not use this as a real telegraph tier; pass this in to pre-empt the current telegraph
#define AI_DYNAMIC_TELEGRAPH_INTERRUPT 4
