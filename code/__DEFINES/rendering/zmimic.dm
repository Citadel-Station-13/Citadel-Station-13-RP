#define ZM_DESTRUCTION_TIMER(TARGET) addtimer(CALLBACK(TARGET, TYPE_PROC_REF(/datum, qdel_self)), 10 SECONDS, TIMER_STOPPABLE)
#define TURF_IS_MIMICKING(T) (isturf(T) && (T:mz_flags & MZ_MIMIC_BELOW))
#define CHECK_OO_EXISTENCE(OO) if (OO && !MOVABLE_IS_ON_ZTURF(OO) && !OO.destruction_timer) { OO.destruction_timer = ZM_DESTRUCTION_TIMER(OO); }
#define UPDATE_OO_IF_PRESENT CHECK_OO_EXISTENCE(bound_overlay); if (bound_overlay) { update_above(); }

// I do not apologize.

// These aren't intended to be used anywhere else, they just can't be undef'd because DM is dum.
#define ZM_INTERNAL_SCAN_LOOKAHEAD(M,VTR,F) ((get_step(M, M:dir)?:VTR & F) || (get_step(M, turn(M:dir, 180))?:VTR & F))
#define ZM_INTERNAL_SCAN_LOOKBESIDE(M,VTR,F) ((get_step(M, turn(M:dir, 90))?:VTR & F) || (get_step(M, turn(M:dir, -90))?:VTR & F))

/// Is this movable visible from a turf that is mimicking below? Note: this does not necessarily mean *directly* below.
#define MOVABLE_IS_BELOW_ZTURF(M) (\
	isturf(M:loc) && (TURF_IS_MIMICKING(M:loc:above) \
	|| ((M:zmm_flags & ZMM_LOOKAHEAD) && ZM_INTERNAL_SCAN_LOOKAHEAD(M, above?:mz_flags, MZ_MIMIC_BELOW))  \
	|| ((M:zmm_flags & ZMM_LOOKBESIDE) && ZM_INTERNAL_SCAN_LOOKBESIDE(M, above?:mz_flags, MZ_MIMIC_BELOW))) \
)
/// Is this movable located on a turf that is mimicking below? Note: this does not necessarily mean *directly* on.
#define MOVABLE_IS_ON_ZTURF(M) (\
	(TURF_IS_MIMICKING(M:loc) \
	|| ((M:zmm_flags & ZMM_LOOKAHEAD) && ZM_INTERNAL_SCAN_LOOKAHEAD(M, mz_flags, MZ_MIMIC_BELOW)) \
	|| ((M:zmm_flags & ZMM_LOOKBESIDE) && ZM_INTERNAL_SCAN_LOOKBESIDE(M, mz_flags, MZ_MIMIC_BELOW))) \
)
#define MOVABLE_SHALL_MIMIC(AM) (!(AM.zmm_flags & ZMM_IGNORE) && MOVABLE_IS_BELOW_ZTURF(AM))

// Turf MZ flags.
#define MZ_MIMIC_BELOW     (1 << 0)	//! If this turf should mimic the turf on the Z below.
#define MZ_MIMIC_OVERWRITE (1 << 1)	//! If this turf is Z-mimicking, overwrite the turf's appearance instead of using a movable. This is faster, but means the turf cannot have its own appearance (say, edges or a translucent sprite).
#define MZ_ALLOW_LIGHTING  (1 << 2)	//! If this turf should permit passage of lighting.
#define MZ_MIMIC_NO_AO     (1 << 3)	//! If the turf shouldn't apply regular turf AO and only do Z-mimic AO.
#define MZ_NO_OCCLUDE     (1 << 4)	//! Don't occlude below atoms if we're a non-mimic z-turf.
#define MZ_OVERRIDE       (1 << 5)	//! Copy only z_appearance or baseturf and bail, do not attempt to copy movables. This is significantly cheaper and allows you to override the mimic, but results in movables not being visible.
#define MZ_NO_SHADOW      (1 << 6)	//! If this turf is being copied, hide the shadower.
#define MZ_TERMINATOR     (1 << 7)	//! Consider this turf the terminus of a Z-group, like the bottom of a Z-group or a MZ_OVERRIDE turf.

#define MZ_OPEN_UP         (1 << 8)  //! Allow atom movement through top.
#define MZ_OPEN_DOWN       (1 << 9)  //! Allow atom movement through bottom.

#define MZ_ATMOS_UP        (1 << 10)  //! Allow atmos passage through top.
#define MZ_ATMOS_DOWN      (1 << 11)  //! Allow atmos passage through bottom.


// Convenience flags.
#define MZ_MIMIC_DEFAULTS (MZ_MIMIC_BELOW|MZ_ALLOW_LIGHTING)	//! Common defaults for zturfs.
#define MZ_ATMOS_BOTH (MZ_ATMOS_UP|MZ_ATMOS_DOWN)
#define MZ_OPEN_BOTH  (MZ_OPEN_UP|MZ_OPEN_DOWN)
#define ZMM_WIDE_LOAD (ZMM_LOOKAHEAD | ZMM_LOOKBESIDE)	//! Atom is big and needs to scan one extra turf in both X and Y. This only extends the range by one turf. Cheap, but not free.

// For debug purposes, should contain the above defines in ascending order.
var/global/list/mimic_defines = list(
	"MZ_MIMIC_BELOW",
	"MZ_MIMIC_OVERWRITE",
	"MZ_ALLOW_LIGHTING",
	"MZ_MIMIC_NO_AO",
	"MZ_NO_OCCLUDE",
	"MZ_OVERRIDE",
	"MZ_NO_SHADOW",
	"MZ_TERMINATOR",

	"MZ_OPEN_UP",
	"MZ_OPEN_DOWN",

	"MZ_ATMOS_UP",
	"MZ_ATMOS_DOWN",
)

DEFINE_BITFIELD(mz_flags, list(
	BITFIELD(MZ_MIMIC_BELOW),
	BITFIELD(MZ_MIMIC_OVERWRITE),
	BITFIELD(MZ_ALLOW_LIGHTING),
	BITFIELD(MZ_MIMIC_NO_AO),
	BITFIELD(MZ_NO_OCCLUDE),
	BITFIELD(MZ_OVERRIDE),
	BITFIELD(MZ_NO_SHADOW),
	BITFIELD(MZ_TERMINATOR),

	BITFIELD(MZ_OPEN_UP),
	BITFIELD(MZ_OPEN_DOWN),

	BITFIELD(MZ_ATMOS_UP),
	BITFIELD(MZ_ATMOS_DOWN),
))


// Movable flags.
#define ZMM_IGNORE          (1 << 0)	//! Do not copy this movable. Atoms may be excluded from copy automatically regardless of this flag.
#define ZMM_MANGLE_PLANES   (1 << 1)	//! Check this movable's overlays/underlays for explicit plane use and mangle for compatibility with Z-Mimic. If you're using emissive overlays, you probably should be using this flag. Expensive, only use if necessary.
#define ZMM_LOOKAHEAD       (1 << 2)	//! Look one turf ahead and one turf back when considering z-turfs that might be seeing this atom. Cheap, but not free.
#define ZMM_LOOKBESIDE      (1 << 3)	//! Look one turf beside (left/right) when considering z-turfs that might be seeing this atom. Cheap, but not free.
#define ZMM_AUTOMANGLE_NRML (1 << 4)	//! Behaves the same as ZMM_MANGLE_PLANES, but is automatically applied by SSoverlays. Do not manually use.
#define ZMM_AUTOMANGLE_PRI  (1 << 5)	//! Behaves the same as ZMM_MANGLE_PLANES, but is automatically applied by SSoverlays. Do not manually use.

#define ZMM_AUTOMANGLE (ZMM_AUTOMANGLE_NRML|ZMM_AUTOMANGLE_PRI)	// convenience

DEFINE_BITFIELD(zmm_flags, list(
	BITFIELD(ZMM_IGNORE),
	BITFIELD(ZMM_MANGLE_PLANES),
	BITFIELD(ZMM_LOOKAHEAD),
	BITFIELD(ZMM_LOOKBESIDE),
	BITFIELD(ZMM_AUTOMANGLE_NRML),
	BITFIELD(ZMM_AUTOMANGLE_PRI)
))

/*
On ZMM_AUTOMANGLE_*:
	So, it's possible for both normal and priority overlays to contain mangle targets.
	Tracking them separately means that the logic in SSoverlays can avoid additional iterations of overlays.
	They're also separate from ZMM_MANGLE_PLANES so SSoverlays doesn't disable mangling on a manually flagged atom.
*/
