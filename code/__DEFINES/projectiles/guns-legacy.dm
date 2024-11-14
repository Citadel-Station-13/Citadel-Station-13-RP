//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* firing_flags on gun firing procs *//

/// perform pointblanking
#define GUN_FIRING_POINT_BLANK (1<<0)
/// track the target instead of just using angle
#define GUN_FIRING_TRACK_TARGET (1<<1)
/// this is a reflex fire by aiming
#define GUN_FIRING_BY_REFLEX (1<<2)
/// do not log
///
/// * This is an extremely dangerous flag. Do not use unless you are already logging it somewhere else.
/// * "This happens all the time" is not a valid excuse to not log a gunshot.
#define GUN_FIRING_NO_LOGGING (1<<3)
/// do not call default click empty
#define GUN_FIRING_NO_CLICK_EMPTY (1<<4)
/// suppressed shot
#define GUN_FIRING_SUPPRESSED (1<<5)

//*            firing result from firing procs                 *//
//* these are flags but should be returned only one at a time. *//
//*            they are flags for fast comparisons.            *//

/// fired
#define GUN_FIRED_SUCCESS 0
/// unknown failure
#define GUN_FIRED_FAIL_UNKNOWN (1<<0)
/// failed - round wasn't live or the right primer type
#define GUN_FIRED_FAIL_INERT (1<<1)
/// failed - out of ammo
#define GUN_FIRED_FAIL_EMPTY (1<<2)
/// failed - we're no longer being held / mounted / whatever
#define GUN_FIRED_FAIL_UNMOUNTED (1<<3)
