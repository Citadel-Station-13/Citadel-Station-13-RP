//! hair flags
#define HAIR_VERY_SHORT (1<<0)
#define HAIR_TIEABLE (1<<1)

DEFINE_BITFIELD(hair_flags, list(
	BITFIELD(HAIR_VERY_SHORT),
	BITFIELD(HAIR_TIEABLE),
))
// Hair Defines
