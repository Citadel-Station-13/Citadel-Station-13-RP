//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* rendering system
//* this is currently only used on ammo magazines, as guns use composition of datums
//* to determine their renderers instead.

/// no automatic rendering
#define GUN_RENDERING_DISABLED 0
/// overlay rendering
#define GUN_RENDERING_OVERLAYS 1
/// state rendering
#define GUN_RENDERING_STATES 2
/// for some guns, we render segmented overlays with offsets
#define GUN_RENDERING_SEGMENTS 3
