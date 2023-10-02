//! Bitflags for /area/var/area_flags
#define AREA_RAD_SHIELDED  (1<<0) /// Radiation shielded.
#define AREA_FLAG_BLUE_SHIELDED (1<<1) /// Bluespace shielded.
#define AREA_FLAG_EXTERNAL      (1<<2) /// External as in exposed to space, not outside in a nice, green, forest.

DEFINE_BITFIELD(area_flags, list(
	BITFIELD(AREA_RAD_SHIELDED),
	BITFIELD(AREA_FLAG_BLUE_SHIELDED),
	BITFIELD(AREA_FLAG_EXTERNAL),
))
