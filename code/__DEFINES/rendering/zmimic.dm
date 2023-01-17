#define TURF_IS_MIMICKING(T) (isturf(T) && (T:mz_flags & MZ_MIMIC_BELOW))
#define CHECK_OO_EXISTENCE(OO) if (OO && !MOVABLE_IS_ON_ZTURF(OO) && !OO.destruction_timer) { OO.destruction_timer = addtimer(CALLBACK(OO, /datum/.proc/qdel_self), 10 SECONDS, TIMER_STOPPABLE); }
#define UPDATE_OO_IF_PRESENT CHECK_OO_EXISTENCE(bound_overlay); if (bound_overlay) { update_above(); }

// I do not apologize.
#define MOVABLE_IS_BELOW_ZTURF(M) (isturf(loc) && ((M:zmm_flags & ZMM_LOOKAHEAD) ? ((get_step(M, M:dir)?:above?:mz_flags & MZ_MIMIC_BELOW) || (loc:above?:mz_flags & MZ_MIMIC_BELOW) || (get_step(M, GLOB.reverse_dir[M:dir])?:above?:mz_flags & MZ_MIMIC_BELOW)) : TURF_IS_MIMICKING(loc:above)))
#define MOVABLE_IS_ON_ZTURF(M) (isturf(loc) && ((M:zmm_flags & ZMM_LOOKAHEAD) ? ((get_step(M, M:dir)?:mz_flags & MZ_MIMIC_BELOW) || (loc:mz_flags & MZ_MIMIC_BELOW) || (get_step(M, GLOB.reverse_dir[M:dir])?:mz_flags & MZ_MIMIC_BELOW)) : TURF_IS_MIMICKING(loc:above)))

//# Turf Multi-Z flags.
#define MZ_MIMIC_BELOW     (1<<0)  //! If this turf should mimic the turf on the Z below.
#define MZ_MIMIC_OVERWRITE (1<<1)  //! If this turf is Z-mimicing, overwrite the turf's appearance instead of using a movable. This is faster, but means the turf cannot have its own appearance (say, edges or a translucent sprite).
#define MZ_MIMIC_NO_AO     (1<<2)  //! If the turf shouldn't apply regular turf AO and only do Z-mimic AO.
#define MZ_MIMIC_BASETURF  (1<<3)  //! Mimic baseturf instead of the below atom. Sometimes useful for elevators.

#define MZ_ALLOW_LIGHTING  (1<<4)  //! If this turf should permit passage of lighting.
#define MZ_NO_OCCLUDE      (1<<5)  //! Don't occlude below atoms if we're a non-mimic z-turf.

#define MZ_OPEN_UP         (1<<6)  //! Allow atom movement through top.
#define MZ_OPEN_DOWN       (1<<7)  //! Allow atom movement through bottom.

#define MZ_ATMOS_UP        (1<<8)  //! Allow atmos passage through top.
#define MZ_ATMOS_DOWN      (1<<9)  //! Allow atmos passage through bottom.

//# Convenience flags.
#define MZ_MIMIC_DEFAULTS (MZ_MIMIC_BELOW|MZ_ALLOW_LIGHTING)
#define MZ_ATMOS_BOTH (MZ_ATMOS_UP|MZ_ATMOS_DOWN)
#define MZ_OPEN_BOTH  (MZ_OPEN_UP|MZ_OPEN_DOWN)

/// For debug purposes, should contain the above defines in ascending order.
// TODO: Make it just print mz_flags bitfield. @Zandario
var/list/mimic_defines = list(
	"MZ_MIMIC_BELOW",
	"MZ_MIMIC_OVERWRITE",
	"MZ_MIMIC_NO_AO",
	"MZ_MIMIC_BASETURF",

	"MZ_ALLOW_LIGHTING",
	"MZ_NO_OCCLUDE",

	"MZ_OPEN_UP",
	"MZ_OPEN_DOWN",

	"MZ_ATMOS_UP",
	"MZ_ATMOS_DOWN",
)

DEFINE_BITFIELD(mz_flags, list(
	BITFIELD(MZ_MIMIC_BELOW),
	BITFIELD(MZ_MIMIC_OVERWRITE),
	BITFIELD(MZ_MIMIC_NO_AO),
	BITFIELD(MZ_MIMIC_BASETURF),

	BITFIELD(MZ_ALLOW_LIGHTING),
	BITFIELD(MZ_NO_OCCLUDE),

	BITFIELD(MZ_OPEN_UP),
	BITFIELD(MZ_OPEN_DOWN),

	BITFIELD(MZ_ATMOS_UP),
	BITFIELD(MZ_ATMOS_DOWN),
))


//# Movable mz_flags.
#define ZMM_IGNORE          (1<<0) //! Do not copy this movable. Atoms with INVISIBILITY_ABSTRACT implicitly do not copy.
#define ZMM_MANGLE_PLANES   (1<<1) //! Check this movable's overlays/underlays for explicit plane use and mangle for compatibility with Z-Mimic. If you're using emissive overlays, you probably should be using this flag. Expensive, only use if necessary.
#define ZMM_LOOKAHEAD       (1<<2) //! Look one turf ahead and one turf back when considering z-turfs that might be seeing this atom. Cheap, but not free.
#define ZMM_AUTOMANGLE_NRML (1<<3) //! Behaves the same as ZMM_MANGLE_PLANES, but is automatically applied by SSoverlays. Do not manually use.
#define ZMM_AUTOMANGLE_PRI  (1<<4) //! Behaves the same as ZMM_MANGLE_PLANES, but is automatically applied by SSoverlays. Do not manually use.

#define ZMM_AUTOMANGLE (ZMM_AUTOMANGLE_NRML|ZMM_AUTOMANGLE_PRI)	// convenience

DEFINE_BITFIELD(zmm_flags, list(
	BITFIELD(ZMM_IGNORE),
	BITFIELD(ZMM_MANGLE_PLANES),
	BITFIELD(ZMM_LOOKAHEAD),
	BITFIELD(ZMM_AUTOMANGLE_NRML),
	BITFIELD(ZMM_AUTOMANGLE_PRI)
))

/*
On ZMM_AUTOMANGLE_*:
	So, it's possible for both normal and priority overlays to contain mangle targets.
	Tracking them separately means that the logic in SSoverlays can avoid additional iterations of overlays.
	They're also separate from ZMM_MANGLE_PLANES so SSoverlays doesn't disable mangling on a manually flagged atom.
*/
