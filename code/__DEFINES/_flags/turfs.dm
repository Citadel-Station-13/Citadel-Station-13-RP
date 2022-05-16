// /turf/z_flags
/// Allow air passage through top
#define Z_AIR_UP			(1<<0)
/// Allow air passage through bottom
#define Z_AIR_DOWN			(1<<1)
/// Allow atom movement through top
#define Z_OPEN_UP			(1<<2)
/// Allow atom movement through bottom
#define Z_OPEN_DOWN			(1<<3)
/// Considered open - below turfs will get the openspace overlay if so
#define Z_CONSIDERED_OPEN	(1<<4)

DEFINE_BITFIELD("z_flags", list(
	"Z_AIR_UP" = Z_AIR_UP,
	"Z_AIR_DOWN" = Z_AIR_DOWN,
	"Z_OPEN_UP" = Z_OPEN_UP,
	"Z_OPEN_DOWN" = Z_OPEN_DOWN,
	"Z_CONSIDERED_OPEN" = Z_CONSIDERED_OPEN,
))
