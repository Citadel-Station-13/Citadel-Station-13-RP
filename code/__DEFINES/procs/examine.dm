//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/// get name / visual first-glance identity
#define EXAMINE_FOR_NAME (1<<0)
/// get short / visual description
#define EXAMINE_FOR_DESC (1<<1)
/// get everything not currently in the new examine system
#define EXAMINE_FOR_REST (1<<2)

/// examining something on a turf
#define EXAMINE_FROM_TURF (1<<0)
/// examining something when looking at a human's inventory
#define EXAMINE_FROM_WORN (1<<1)
/// examining something when looking at a human's strip menu
#define EXAMINE_FROM_STRIP (1<<2)
