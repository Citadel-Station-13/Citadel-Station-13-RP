//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Stops a thing from falling through this
 *
 * * If said thing is asking while falling, the first thing to return this will be what gets on_z_impacted'd.
 *
 * @params
 * * victim - thing trying to fall through us
 * * levels - levels fallen so far, preventing a fall in the first place has this at 0, breaking a falling object from z2 to z1's floor would be 1, etc.
 * * fall_flags - see __DEFINES/mapping/multiz.dm
 */
/atom/proc/prevent_z_fall(atom/movable/victim, levels = 0, fall_flags)
	return fall_flags

/**
 * Called when a thing falls onto us.
 *
 * * Only called if something is falling; if we prevent the fall in the first place, this never gets called
 *
 * @params
 * * victim - thing trying to fall through us
 * * levels - levels fallen so far, preventing a fall in the first place has this at 0, breaking a falling object from z2 to z1's floor would be 1, etc.
 * * fall_flags - see __DEFINES/mapping/multiz.dm
 * * direct_hit - we're the thing actually landed on.
 */
/atom/proc/on_z_impacted(atom/movable/victim, levels, fall_flags, direct_hit)
	return fall_flags
