// flags for /area/var/area_flags
/// Radiation shielded
#define AREA_RAD_SHIELDED			(1<<0)
/// bluespace shielded
#define AREA_BLUE_SHIELDED			(1<<1)
/// allow deepmaint to trample this
#define AREA_ALLOW_DEEPMAINT		(1<<2)
/// considered an abstract meta-area of "there's no area", so blueprints and create new area can trample this
#define AREA_ABSTRACT				(1<<3)

DEFINE_BITFIELD(area_flags, list(
	BITFIELD(AREA_RAD_SHIELDED),
	BITFIELD(AREA_BLUE_SHIELDED),
	BITFIELD(AREA_ALLOW_DEEPMAINT),
	BITFIELD(AREA_ABSTRACT),
))
