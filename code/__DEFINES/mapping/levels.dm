//! Everything regarding space levels go in here

//? "linkage"

// Linkage types - Normal linkage variables override these, so don't set them if you use these.
/// Default - don't preprocess for unlinked sides, just leave them empty
#define Z_LINKAGE_NORMAL "normal"
/// Crosslinked - crosslink with other crosslinked zlevels at random using some semblence of continuity
#define Z_LINKAGE_CROSSLINKED "crosslink"
/// Selflooping - automatically link to itself for unlinked sides
#define Z_LINKAGE_SELFLOOP "selfloop"

//? "transition"

// Transition types
/// Default - one from map edge unless there's an indestructible wall *on either side*
#define Z_TRANSITION_DEFAULT "default"
/// Disabled - generate none
#define Z_TRANSITION_DISABLED "disabled"
/// Invisible - generate borders but don't do mirage visuals
#define Z_TRANSITION_INVISIBLE "invisible"
/// Forced - always generate transition borders
#define Z_TRANSITION_FORCED "forced"

#warn above?

//? "attributes"

//? "traits"

/// level is considered main station (if there's two both will have this; adding support for multi-station later)
#define ZTRAIT_STATION "station"
/// level has innate gravity (planets hello)
#define ZTRAIT_GRAVITY "gravity"
/// level should generate on minimaps
#define ZTRAIT_MINIMAP "minimap"
/// level is reserved space, we cannot treat the entire level as the same logical level
#define ZTRAIT_RESERVED "reserved"
/// level is admin space, don't let people fuck around with it via teleportation/otherwise
#define ZTRAIT_ADMIN "admin"
/// exploration pinned weapons don't work on this level
#define ZTRAIT_FACILITY_SAFETY "facility_safety"
/// xenoarcheology shouldn't generate here
#define ZTRAIT_XENOARCH_EXEMPT "xenoarch_exempt"
