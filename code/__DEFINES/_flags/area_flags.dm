// flags for /area/var/area_flags
/// Radiation shielded
#define AREA_RAD_SHIELDED				(1<<0)
/// bluespace shielded
#define AREA_BLUE_SHIELDED			(1<<1)

DEFINE_BITFIELD(area_flags, list(
	BITFIELD(AREA_RAD_SHIELDED),
	BITFIELD(AREA_BLUE_SHIELDED),
))
