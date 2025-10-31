//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* fall_flags *//

/// Falling should ignore anchored status
#define FALL_IGNORE_ANCHORED		(1<<0)
/// this fall shouldn't incur any sort of self-damage for hitting the ground
#define FALL_CUSHIONED_FALLER		(1<<1)
/// this fall shouldn't damage anything we're falling on
#define FALL_CUSHIONED_IMPACTED		(1<<2)
/// fall got interrupted by something blocking
#define FALL_BLOCKED				(1<<3)
/// fall got interrupted by the atom regaining its footing/gravity overcame
#define FALL_RECOVERED				(1<<4)
/// kill fall entirely, no handling for impacts/recovery
#define FALL_TERMINATED				(1<<5)
/// don't make fall feedback
#define FALL_SILENT					(1<<6)
/// allow default fall (used by can fall to determine if atom can support itself under its own power)
#define FALL_ALLOWED				(1<<7)

/// these flags mean a fall should stop
#define FALL_FLAGS_STOP				(FALL_BLOCKED | FALL_RECOVERED | FALL_TERMINATED)

/// there's a level above
/// * This works as long as SSmapping has its rebuild proc called after a load; given this is enforced
///   by SSmapping most of the time, this is usually fine.
#define Z_HAS_ABOVE(z) (!isnull(SSmapping.cached_level_up[z]))
/// there's a level below
/// * This works as long as SSmapping has its rebuild proc called after a load; given this is enforced
///   by SSmapping most of the time, this is usually fine.
#define Z_HAS_BELOW(z) (!isnull(SSmapping.cached_level_down[z]))

/// get turf below this turf, if any
/// * this is a guesstimation
/// * we are at the mercy of zmimic when we do this. do not use in critical maploader code.
#define TURF_BELOW_ISH(T) (T.below || T.below())
/// get turf above this turf, if any
/// * this is a guesstimation
/// * we are at the mercy of zmimic when we do this. do not use in critical maploader code.
#define TURF_ABOVE_ISH(T) (T.above || T.above())

/// Checks if we're right next to the map transition border.
/// * Only valid for something on a turf.
///
/// todo: support multi-tile objects
#define AT_MAP_BORDER(A) (A.x == 2 || A.y == 2 || A.x == world.maxx - 1 || A.y == world.maxy - 1)
