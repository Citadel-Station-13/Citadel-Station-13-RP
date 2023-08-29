//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// Enable debugging mode. This enables the AI debug interface, but will generally cause a small bit of overhead/lag.
#define AI_DEBUGGING

#ifdef AI_DEBUGGING
	#define AI_DEBUGGING_ENABLED TRUE
#else
	#define AI_DEBUGGING_ENABLED FALSE
#endif

//* /datum/ai_holder ai_cheat_flag
/// Ignore vision range. This + xray is very dangerous.
#define AI_CHEAT_FARSIGHT (1<<0)
/// Ignore walls opacity. This + farsight is very dangerous.
#define AI_CHEAT_XRAY (1<<1)
/// Ignore luminosity / darksight restrictions of our mob.
#define AI_CHEAT_NIGHTVISION (1<<2)
/// Ignore communications jamming, barriers, etc
#define AI_CHEAT_HIVEMIND (1<<3)
/// Unlimited ammo for those that support ammo
#define AI_CHEAT_UNLIMITED_AMMO (1<<4)
/// No reloading required for those that support reloading
#define AI_CHEAT_INSTANT_RELOAD (1<<5)
/// For those that support non-instant reflexes, do not simulate human reaction time
#define AI_CHEAT_MACHINE_REFLEXES (1<<6)
/// Unlimited healing for those that support limited healing usages/items
#define AI_CHEAT_UNLIMITED_HEALING (1<<7)
/// Unlimited consumables like grenades for those that support limited consumables
#define AI_CHEAT_UNLIMITED_ITEMS (1<<8)
/// Can tell details of a target like how damaged/hurt someone is without needing physical signs of it, for those that support it.
#define AI_CHEAT_OMNISCIENT_INSIGHT (1<<9)
/// For those that support it, maximize offensive 'health trading' (aka be the average murderhobo)
#define AI_CHEAT_NO_ROLEPLAYING (1<<10)

DEFINE_BITFIELD(ai_cheat_flags, list(
	BITFIELD(AI_CHEAT_FARSIGHT),
	BITFIELD(AI_CHEAT_XRAY),
	BITFIELD(AI_CHEAT_NIGHTVISION),
	BITFIELD(AI_CHEAT_HIVEMIND),
	BITFIELD(AI_CHEAT_MACHINE_REFLEXES),
	BITFIELD(AI_CHEAT_INSTANT_RELOAD),
	BITFIELD(AI_CHEAT_UNLIMITED_AMMO),
	BITFIELD(AI_CHEAT_UNLIMITED_HEALING),
	BITFIELD(AI_CHEAT_UNLIMITED_ITEMS),
	BITFIELD(AI_CHEAT_OMNISCIENT_INSIGHT),
	BITFIELD(AI_CHEAT_NO_ROLEPLAYING),
))

//* /datum/ai_holder intelligence var
/// dumb as a rock
#define AI_INTELLIGENCE_ROCK 1
/// basic non-sapient animals
#define AI_INTELLIGENCE_BASIC 2
/// monkies, etc
#define AI_INTELLIGENCE_ADVANCED 3
/// humans
#define AI_INTELLIGENCE_SAPIENT 4
/// superhuman
#define AI_INTELLIGENCE_SUPERHUMAN 5
