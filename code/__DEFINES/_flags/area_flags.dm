// flags for /area/var/area_flags
/// Radiation shielded
#define AREA_RAD_SHIELDED (1<<0)
/// Bluespace shielded
#define AREA_BLUE_SHIELDED (1<<1)
/// Ignore unit tests for atmos
#define AREA_NO_ATMOS_TEST (1<<2)
/// Ignore unit tests for poewr
#define AREA_NO_POWER_TEST (1<<3)

DEFINE_BITFIELD(area_flags, list(
	BITFIELD(AREA_RAD_SHIELDED),
	BITFIELD(AREA_BLUE_SHIELDED),
	BITFIELD(AREA_NO_ATMOS_TEST),
	BITFIELD(AREA_NO_POWER_TEST),
))
