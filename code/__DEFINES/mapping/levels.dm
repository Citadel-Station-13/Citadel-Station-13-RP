//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* /datum/map_level - `linkage` *//

// Linkage types - Normal linkage variables override these, so don't set them if you use these.

/// Default - don't preprocess for unlinked sides, just leave them empty
#define Z_LINKAGE_NORMAL "normal"
/// Forced - disallow things like maps to set our linkages.
#define Z_LINKAGE_FORCED "forced"

//* /datum/map_level - `transition` */

// Transition types
/// Default - one from map edge unless there's an indestructible wall *on either side*
#define Z_TRANSITION_DEFAULT "default"
/// Disabled - generate none
#define Z_TRANSITION_DISABLED "disabled"
/// Invisible - generate borders but don't do mirage visuals
#define Z_TRANSITION_INVISIBLE "invisible"
/// Forced - always generate transition borders
#define Z_TRANSITION_FORCED "forced"
