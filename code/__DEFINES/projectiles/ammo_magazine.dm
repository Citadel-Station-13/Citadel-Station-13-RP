//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* /obj/item/ammo_magazine - magazine_type *//

/// Handle loading as magazine.
#define MAGAZINE_TYPE_NORMAL (1<<0)
/// Handle loading as speedloader.
/// * Only usable on guns with internal magazines.
#define MAGAZINE_TYPE_SPEEDLOADER (1<<1)
/// Handle loading one at a time from this magazine.
/// * Only usable on guns with internal magazines.
#define MAGAZINE_TYPE_CLIP (1<<2)

DEFINE_BITFIELD_NEW(ammo_magazine_types, list(
	/obj/item/ammo_magazine = list(
		NAMEOF_TYPE(/obj/item/ammo_magazine, magazine_type),
	),
), list(
	BITFIELD_NEW("Normal", MAGAZINE_TYPE_NORMAL),
	BITFIELD_NEW("Speedloader", MAGAZINE_TYPE_SPEEDLOADER),
	BITFIELD_NEW("Stripper Clip", MAGAZINE_TYPE_CLIP),
))

//* /obj/item/ammo_magazine - magazine_class *//

/// renders as -mag
///
/// * if a magazine's class isn't in a gun's render_magazine_overlay, we use this state
#define MAGAZINE_CLASS_GENERIC (1<<0)
/// renders as -mag-drum
#define MAGAZINE_CLASS_DRUM (1<<1)
/// renders as -mag-ext
#define MAGAZINE_CLASS_EXTENDED (1<<2)
/// renders as -mag-box
/// * this for boxes for lmgs where the ammo's probably belted
#define MAGAZINE_CLASS_BOX (1<<3)
/// renders as -mag-pouch
/// * this is for any container that's considered loose (so no ammo feed belt)
#define MAGAZINE_CLASS_POUCH (1<<4)
/// renders as -mag-clip
/// * this is for strippper clips that can be used as magazines directly.
#define MAGAZINE_CLASS_CLIP (1<<5)
/// renders as -mag-belt
/// * reserved
#define MAGAZINE_CLASS_BELT (1<<6)

GLOBAL_REAL_LIST(magazine_class_bit_to_state) = list(
	"mag",
	"mag-drum",
	"mag-ext",
	"mag-box",
	"mag-pouch",
	"mag-clip",
	"mag-belt",
)

DEFINE_BITFIELD_NEW(ammo_magazine_types, list(
	/obj/item/ammo_magazine = list(
		NAMEOF_TYPE(/obj/item/ammo_magazine, magazine_class),
	),
), list(
	BITFIELD_NEW("Generic", MAGAZINE_CLASS_GENERIC),
	BITFIELD_NEW("Drum", MAGAZINE_CLASS_DRUM),
	BITFIELD_NEW("Extended", MAGAZINE_CLASS_EXTENDED),
	BITFIELD_NEW("Box", MAGAZINE_CLASS_BOX),
	BITFIELD_NEW("Pouch", MAGAZINE_CLASS_POUCH),
	BITFIELD_NEW("Clip", MAGAZINE_CLASS_CLIP),
	BITFIELD_NEW("Belt", MAGAZINE_CLASS_BELT),
))

/// Fits in most guns
#define MAGAZINE_CLASSES_DEFAULT_FIT ( \
	MAGAZINE_CLASS_GENERIC | \
	MAGAZINE_CLASS_DRUM | \
	MAGAZINE_CLASS_EXTENDED \
)
