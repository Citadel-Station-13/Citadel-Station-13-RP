//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//*                               rendering system                                     *//
//* this is currently only used on ammo magazines, as guns use composition of datums   *//
//*                    to determine their renderers instead.                           *//

/// no automatic rendering
#define GUN_RENDERING_DISABLED "disabled"
/// overlay rendering
#define GUN_RENDERING_OVERLAYS "overlays"
/// state rendering
#define GUN_RENDERING_STATES "states"
/// for some guns, we render segmented overlays with offsets
#define GUN_RENDERING_SEGMENTS "segments"
