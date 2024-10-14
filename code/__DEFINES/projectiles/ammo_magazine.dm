//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* /obj/item/ammo_magazine - magazine_type *//

/// normal magazines
///
/// * basically, straight or curved 'stick' magazines
#define MAGAZINE_TYPE_NORMAL (1<<0)
/// revolver-like speedloader
#define MAGAZINE_TYPE_SPEEDLOADER (1<<1)
/// stripper clip, or otherwise meant to load one at a time but very quickly
#define MAGAZINE_TYPE_CLIP (1<<2)
/// loose pouch
#define MAGAZINE_TYPE_POUCH (1<<3)
/// structured box
///
/// * this refers to LMG-like box magazine, not what we call just generally normal magazines
#define MAGAZINE_TYPE_BOX (1<<3)

DEFINE_BITFIELD_NEW(ammo_magazine_types, list(
	/obj/item/ammo_magazine = list(
		"magazine_type",
	),
), list(
	BITFIELD_NEW("Normal", MAGAZINE_TYPE_NORMAL),
	BITFIELD_NEW("Speedloader", MAGAZINE_TYPE_SPEEDLOADER),
	BITFIELD_NEW("Stripper Clip", MAGAZINE_TYPE_CLIP),
	BITFIELD_NEW("Ammo Pouch", MAGAZINE_TYPE_POUCH),
	BITFIELD_NEW("Ammo Box", MAGAZINE_TYPE_BOX),
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
#define MAGAZINE_CLASS_BOX (1<<3)

GLOBAL_REAL_LIST(magazine_class_bit_to_state) = list(
	"mag",
	"mag-drum",
	"mag-ext",
	"mag-box",
)
