//! hair flags
#define HAIR_VERY_SHORT (1<<0)
#define HAIR_TIEABLE (1<<1)

DEFINE_BITFIELD(hair_flags, list(
	BITFIELD(HAIR_VERY_SHORT),
	BITFIELD(HAIR_TIEABLE),
))
// Hair Defines

//* /datum/sprite_accessory/var/icon_sidedness
//? These must be numbers!

/// no additional states
#define SPRITE_ACCESSORY_SIDEDNESS_NONE 0
/// -front state, and -behind state, use different layers
#define SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND 1

// todo: DEFINE_ENUM

//* /datum/sprite_accessory/var/icon_alignment

/// for some asinine reason just ignore it
#define SPRITE_ACCESSORY_ALIGNMENT_IGNORE "ignore"
/// center it east/west but align it to bottom edge
#define SPRITE_ACCESSORY_ALIGNMENT_BOTTOM "bottom"
/// center it fully
#define SPRITE_ACCESSORY_ALIGNMENT_CENTER "center"

// todo: DEFINE_ENUM

//* Sprite Accessory Slots

#define SPRITE_ACCESSORY_SLOT_TAIL "tail"
#define SPRITE_ACCESSORY_SLOT_WINGS "wings"
#define SPRITE_ACCESSORY_SLOT_HORNS "horns"
#define SPRITE_ACCESSORY_SLOT_EARS "ears"
#define SPRITE_ACCESSORY_SLOT_HAIR "hair"
#define SPRITE_ACCESSORY_SLOT_FACEHAIR "facehair"

// todo: DEFINE_ENUM

//* Sprite Accessory Variations (Standard)

#define SPRITE_ACCESSORY_VARIATION_FLAPPING "Flapping"
#define SPRITE_ACCESSORY_VARIATION_WAGGING "Wagging"
#define SPRITE_ACCESSORY_VARIATION_SPREAD "Spread"

// todo: DEFINE_ENUM
