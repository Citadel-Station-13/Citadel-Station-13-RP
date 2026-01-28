//! Bitflags for /area/var/area_flags
/// Are you forbidden from teleporting to the area? (centcom, mobs, wizard, hand teleporter)
#define AREA_NO_TELEPORT (1<<0)
/// Hides area from player Teleport function.
#define AREA_HIDDEN (1<<1)
// todo: re-evaluate this
#define AREA_RAD_SHIELDED  (1<<5) /// Radiation shielded.
// todo: kill this with fire
#define AREA_FLAG_BLUE_SHIELDED (1<<6) /// Bluespace shielded.
// todo: better documentation
#define AREA_FLAG_EXTERNAL      (1<<7) /// External as in exposed to space, not outside in a nice, green, forest.
/// considered a volatile-changing area by persistence, which means things like trash and debris won't stay here
#define AREA_FLAG_ERODING       (1<<8)

DEFINE_BITFIELD(area_flags, list(
	BITFIELD(AREA_NO_TELEPORT),
	BITFIELD(AREA_HIDDEN),
	BITFIELD(AREA_RAD_SHIELDED),
	BITFIELD(AREA_FLAG_BLUE_SHIELDED),
	BITFIELD(AREA_FLAG_EXTERNAL),
	BITFIELD_NAMED("Eroding", AREA_FLAG_ERODING),
))
