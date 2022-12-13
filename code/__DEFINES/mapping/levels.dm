//! Everything regarding space levels go in here

//? "linkage"

// Linkage types - Normal linkage variables override these, so don't set them if you use these.
/// Default - don't preprocess for unlinked sides, just leave them empty
#define Z_LINKAGE_NORMAL			"normal"
/// Crosslinked - crosslink with other crosslinked zlevels at random using some semblence of continuity
#define Z_LINKAGE_CROSSLINKED		"crosslink"
/// Selflooping - automatically link to itself for unlinked sides
#define Z_LINKAGE_SELFLOOP			"selfloop"

//? "attributes"
/// general indoors airmix as gas string or atmosphere; if none, defaults to standard station air
#define ZATTRIBUTE_INDOORS_AIR "air_indoors"
/// general outdoors airmix as gas string or atmosphere; if none, defaults to default
#define ZATTRIBUTE_OUTDOORS_AIR "air_outdoors"

//? "traits"
/// level is considered main station (if there's two both will have this; adding support for multi-station later)
#define ZTRAIT_STATION "station"
/// level has innate gravity (planets hello)
#define ZTRAIT_GRAVITY "gravity"
/// level should generate on minimaps
#define ZTRAIT_MINIMAP "minimap"
