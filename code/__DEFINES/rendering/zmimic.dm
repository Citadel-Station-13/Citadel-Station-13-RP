#define TURF_IS_MIMICKING(T) (isturf(T) && (T:z_flags & ZM_MIMIC_BELOW))
#define CHECK_OO_EXISTENCE(OO) if (OO && !TURF_IS_MIMICKING(OO.loc)) { qdel(OO); }
#define UPDATE_OO_IF_PRESENT CHECK_OO_EXISTENCE(bound_overlay); if (bound_overlay) { update_above(); }

//! Turf MZ flags.
#define ZM_MIMIC_BELOW     (1<<0) /// If this turf should mimic the turf on the Z below.
#define ZM_MIMIC_OVERWRITE (1<<1) /// If this turf is Z-mimicing, overwrite the turf's appearance instead of using a movable. This is faster, but means the turf cannot have its own appearance (say, edges or a translucent sprite).
#define ZM_ALLOW_LIGHTING  (1<<2) /// If this turf should permit passage of lighting.
#define ZM_ALLOW_ATMOS     (1<<3) /// If this turf permits passage of air.
#define ZM_MIMIC_NO_AO     (1<<4) /// If the turf shouldn't apply regular turf AO and only do Z-mimic AO.
#define ZM_NO_OCCLUDE      (1<<5) /// Don't occlude below atoms if we're a non-mimic z-turf.
#define ZM_MIMIC_BASETURF  (1<<6) /// Mimic baseturf instead of the below atom. Sometimes useful for elevators.

//! Convenience flag.
#define ZM_MIMIC_DEFAULTS (ZM_MIMIC_BELOW|ZM_ALLOW_LIGHTING)

/// For debug purposes, should contain the above defines in ascending order.
var/list/mimic_defines = list(
	"ZM_MIMIC_BELOW",
	"ZM_MIMIC_OVERWRITE",
	"ZM_ALLOW_LIGHTING",
	"ZM_ALLOW_ATMOS",
	"ZM_MIMIC_NO_AO",
	"ZM_NO_OCCLUDE",
	"ZM_MIMIC_BASETURF",
)

DEFINE_BITFIELD(z_flags, list(
	BITFIELD(ZM_MIMIC_BELOW),
	BITFIELD(ZM_MIMIC_OVERWRITE),
	BITFIELD(ZM_ALLOW_LIGHTING),
	BITFIELD(ZM_ALLOW_ATMOS),
	BITFIELD(ZM_MIMIC_NO_AO),
	BITFIELD(ZM_NO_OCCLUDE),
	BITFIELD(ZM_MIMIC_BASETURF),
))

// /turf/z_flags
/// Allow atom movement through top
#define Z_OPEN_UP			(1<<2)
/// Allow atom movement through bottom
#define Z_OPEN_DOWN			(1<<3)


//! Movable z_flags.
#define ZMM_IGNORE         1 /// Do not copy this movable.
#define ZMM_MANGLE_PLANES  2 /// Check this movable's overlays/underlays for explicit plane use and mangle for compatibility with Z-Mimic. If you're using emissive overlays, you probably should be using this flag. Expensive, only use if necessary.
