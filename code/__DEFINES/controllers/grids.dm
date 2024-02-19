//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? grid_flags arg in motion procs

// none yet

//? motion_flags arg in motion procs

/// move area instance to new turf
/// this, as of time of writing, will completely trample the existing area where the new turf is
#define GRID_MOVE_AREA (1<<0)
/// move turf data to new turf
/// this, as of time of writing, will place on top if a baseturf boundary is provided
/// if a boundary was not provided, this will rip the source turf down to its bottom baseturf,
/// and replace the destination's baseturf stack with it.
#define GRID_MOVE_TURF (1<<1)
/// move movables to new turf
#define GRID_MOVE_MOVABLES (1<<2)
