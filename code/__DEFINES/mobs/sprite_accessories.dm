//! hair flags
#define HAIR_VERY_SHORT (1<<0)
#define HAIR_TIEABLE (1<<1)

DEFINE_BITFIELD(hair_flags, list(
	BITFIELD(HAIR_VERY_SHORT),
	BITFIELD(HAIR_TIEABLE),
))
// Hair Defines

//* /datum/sprite_accessory/var/icon_sidedness

/// no additional states
#define SPRITE_ACCESSORY_SIDEDNESS_NONE "none"
/// -front state, and -behind state, use different layers
#define SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND "front-behind"

//* /datum/sprite_accessory/var/icon_alignment

/// for some asinine reason just ignore it
#define SPRITE_ACCESSORY_ALIGNMENT_IGNORE "ignore"
/// center it east/west but align it to bottom edge
#define SPRITE_ACCESSORY_ALIGNMENT_BOTTOM "bottom"
/// center it fully
#define SPRITE_ACCESSORY_ALIGNMENT_CENTER "center"
