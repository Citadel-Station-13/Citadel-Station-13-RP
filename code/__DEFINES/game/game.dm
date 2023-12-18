//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Objective completion status

/// got the target/whatever
#define GAME_OBJECTIVE_SUCCESS 1
/// didn't yet get the target/whatever
#define GAME_OBJECTIVE_INCOMPLETE 2
/// failed to get the target (e.g. not physically able to anymore)
#define GAME_OBJECTIVE_FAILURE 3
/// target is no longer valid, but it isn't a failure
#define GAME_OBJECTIVE_VOIDED 4
/// cataclysmic failure
#define GAME_ObJECTIVE_BACKFIRED 5
