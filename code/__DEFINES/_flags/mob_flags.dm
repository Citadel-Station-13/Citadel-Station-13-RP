//? mob_flags bitmask
/// we're registered to a world_sector
#define MOB_SECTOR_REGISTERED (1<<0)

DEFINE_BITFIELD(mob_flags, list(
	BITFIELD(MOB_SECTOR_REGISTERED),
))
