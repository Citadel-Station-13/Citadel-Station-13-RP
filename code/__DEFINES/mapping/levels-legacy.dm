
// TODO: don't hard define these, use :: syntax with datums.

/// level is considered main station (if there's two both will have this; adding support for multi-station later)
#define ZTRAIT_STATION "legacy-station"
/// level has innate gravity (planets hello)
#define ZTRAIT_GRAVITY "innate-gravity"
/// level should generate on minimaps
#define ZTRAIT_MINIMAP "generate-minimaps"
/// level is reserved space, we cannot treat the entire level as the same logical level
#define ZTRAIT_RESERVED "system-reserved"
/// level is admin space, don't let people fuck around with it via teleportation/otherwise
#define ZTRAIT_ADMIN "legacy-admin"
/// exploration pinned weapons don't work on this level
#define ZTRAIT_FACILITY_SAFETY "legacy-facility_safety"
/// xenoarcheology shouldn't generate here
#define ZTRAIT_XENOARCH_EXEMPT "legacy-xenoarch_exempt"
/// block all wallhacks that aren't reworked for citrp standards
///
/// * mesons
/// * materials
/// * thermals
/// * sonars
#define ZTRAIT_BLOCK_LEGACY_WALLHACKS "legacy-no-wallhack"

#define ZTRAIT_LEGACY_HOLOMAP_SMOOSH "_holomap_smoosh"
#define ZTRAIT_LEGACY_BELTER_DOCK "_belter_dock"
#define ZTRAIT_LEGACY_BELTER_TRANSIT "_belter_transit"
#define ZTRAIT_LEGACY_BELTER_ACTIVE "_belter_active"
