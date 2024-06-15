//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Global balancing numbers; everything should derive off of these so we can adjust everything at once.
/// global default multiplier for falloff factor
#define EXPLOSION_FALLOFF_FACTOR 1
/// global default multiplier for bypass factor
#define EXPLOSION_BYPASS_FACTOR 1

/// global default "nominal" maxcap power; being hit by this is what causes the most severe effects like turfs completely peeling away, people gibbing, etc.
#define EXPLOSION_POWER_DEVASTATING 1000
/// global default "nominal" heavy power; being hit by this is what causes things like turfs exploding, people taking immediately lethal damage/devastating damage, etc.
#define EXPLOSION_POWER_SEVERE (EXPLOSION_POWER_DEVASTATING * 0.5)
/// global default "nominal" minor power; being hit by this is what causes minor wounds
#define EXPLOSION_POWER_MINOR  (EXPLOSION_POWER_DEVASTATING * 0.25)
/// below this explosions are considered so trivial we just drop the wave
#define EXPLOSION_POWER_DROPPED 50
