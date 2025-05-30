//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/// Turf crowding limit.
///
/// Modules that move a lot of objects should respect this,
/// as performance falls quadratically as turfs get more full.
#define TURF_CROWDING_SOFT_LIMIT 15
/// Turf catastrophic crowding limit.
///
/// Modules that move a lot of objects should flat out refuse to operate on more objects than this.
#define TURF_CROWDING_HARD_LIMIT 75
