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
/// don't send back feedback to actor
#define GUN_FIRING_NO_FEEDBACK (1<<6)

//*            firing result from firing procs                 *//
//* these are flags but should be returned only one at a time. *//
//*            they are flags for fast comparisons.            *//

/// fired. this must be false-y.
#define GUN_FIRED_SUCCESS 0
/// unknown failure
#define GUN_FIRED_FAIL_UNKNOWN (1<<0)
/// failed - round wasn't live or the right primer type
#define GUN_FIRED_FAIL_INERT (1<<1)
/// failed - out of ammo
#define GUN_FIRED_FAIL_EMPTY (1<<2)
/// failed - we're no longer being held / mounted / whatever
#define GUN_FIRED_FAIL_UNMOUNTED (1<<3)

//* rendering enums - /obj/item/gun/projectile/ballistic *//

//? render_bolt_overlay

/// do not render bolt state
#define BALLISTIC_RENDER_BOLT_NEVER 0
/// render `[base state]-bolt` if open
#define BALLISTIC_RENDER_BOLT_OPEN 1
/// render `[base state]-bolt` if closed
#define BALLISTIC_RENDER_BOLT_CLOSE 2
/// * render `[base state]-bolt-open` if open
/// * render `[base state]-bolt-close` if closed
#define BALLISTIC_RENDER_BOLT_BOTH 3

//? render_break_overlay

/// do not render break-action state
#define BALLISTIC_RENDER_BREAK_NEVER 0
/// render `[base state]-break` if open
#define BALLISTIC_RENDER_BREAK_OPEN 1
/// render `[base state]-break` if closed
#define BALLISTIC_RENDER_BREAK_CLOSE 2
/// * render `[base state]-break-open` if open
/// * render `[base state]-break-close` if closed
#define BALLISTIC_RENDER_BREAK_BOTH 3

//* rendering enums - /obj/item/gun/projectile/ballistic/magnetic, /obj/item/gun/projectile/magnetic *//

//? render_battery_overlay

/// do not render battery state
#define MAGNETIC_RENDER_BATTERY_NEVER 0
/// render `[base state]-battery` if in
#define MAGNETIC_RENDER_BATTERY_IN 1
/// render `[base state]-battery` if out
#define MAGNETIC_RENDER_BATTERY_OUT 2
/// * render `[base state]-battery-in` if in
/// * render `[base state]-battery-out` if out
#define MAGNETIC_RENDER_BATTERY_BOTH 3
