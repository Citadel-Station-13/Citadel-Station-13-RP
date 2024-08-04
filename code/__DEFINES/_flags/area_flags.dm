//! Bitflags for /area/var/area_flags
// todo: re-evaluate this
#define AREA_RAD_SHIELDED  (1<<0) /// Radiation shielded.
// todo: kill this with fire
#define AREA_FLAG_BLUE_SHIELDED (1<<1) /// Bluespace shielded.
// todo: better documentation
#define AREA_FLAG_EXTERNAL      (1<<2) /// External as in exposed to space, not outside in a nice, green, forest.
/// considered a volatile-changing area by persistence, which means things like trash and debris won't stay here
#define AREA_FLAG_ERODING       (1<<3)

DEFINE_BITFIELD(area_flags, list(
	BITFIELD(AREA_RAD_SHIELDED),
	BITFIELD(AREA_FLAG_BLUE_SHIELDED),
	BITFIELD(AREA_FLAG_EXTERNAL),
	BITFIELD_NAMED("Eroding", AREA_FLAG_ERODING),
))
