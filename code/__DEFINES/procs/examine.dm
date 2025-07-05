//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/// get name / visual first-glance identity
#define EXAMINE_FOR_NAME (1<<0)
/// get short / visual description
#define EXAMINE_FOR_DESC (1<<1)
/// get render; usually this is just 'src'
/// * Omitting this will omit all renders, including on nested examines like clothing / equipment.
#define EXAMINE_FOR_RENDER (1<<2)
/// get worn + held entries
#define EXAMINE_FOR_WORN (1<<3)
/// get attached entries on things like clothing
#define EXAMINE_FOR_ATTACHED (1<<4)
/// get everything not currently in the new examine system
#define EXAMINE_FOR_REST (1<<5)

/// examining something on a turf
#define EXAMINE_FROM_TURF (1<<0)
/// examining something when looking at a human's inventory
#define EXAMINE_FROM_WORN (1<<1)
/// examining something when looking at a human's strip menu
#define EXAMINE_FROM_STRIP (1<<2)
