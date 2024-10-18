//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* rendering enums - /obj/item/gun/ballistic *//

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
