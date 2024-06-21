//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Global balancing numbers; everything should derive off of these so we can adjust everything at once.
/// global default multiplier for falloff exponential
#define EXPLOSION_FALLOFF_BASE_EXPONENT 0.97
/// global default subtractor for falloff linear
#define EXPLOSION_FALLOFF_BASE_LINEAR 10

/// arbitrary value that's semi-equivalent of being in the middle of a 5/10/20 on old explosions
#define EXPLOSION_POWER_MAXCAP_EQUIVALENT 1000
/// arbitrary value that's semi-equivalent of being hit with sev 1 in old explosions
#define EXPLOSION_POWER_APPROXIMATE_DEVASTATE 1000
/// arbitrary value that's semi-equivalent of being hit with a severity 2 explosion on old explosions
#define EXPLOSION_POWER_APPROXIMATE_HEAVY 500
/// arbitrary value that's semi-equivalent of being hit with a sev 3 in old explosions
#define EXPLOSION_POWER_APPROXIMATE_LIGHT 250

/// below this explosions are considered so trivial we just drop the wave
#define EXPLOSION_POWER_DROPPED 50
