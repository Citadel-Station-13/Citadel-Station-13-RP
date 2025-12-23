//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// proc: dropped() on /obj/item
// todo: this should be in procs.dm and the names need to be changed probably
// todo: comsig instead?
/// relocated; return false
#define ITEM_RELOCATED_BY_DROPPED -1

//* Item `belt_storage_class` defines *//

/// Doesn't go in a belt
#define BELT_CLASS_INVALID 0
/// small grenades, pill bottles, syringes, pistol mags, etc
#define BELT_CLASS_SMALL 1
/// rifle mags, welding torches, crowbars, etc
#define BELT_CLASS_MEDIUM 2
/// sidearms, rpds, etc
#define BELT_CLASS_LARGE 3

// TODO: DECLARE_ENUM

//* Item `belt_storage_size` defines *//

/// Default belt size for items
#define BELT_SIZE_DEFAULT 1
/// Default belt size for ammo casings
#define BELT_SIZE_AMMO_CASING 0.25
/// Default magazine size
#define BELT_SIZE_MAGAZINE 1
/// Default flashlight size
#define BELT_SIZE_FLASHLIGHT 1
#define BELT_SIZE_SYRINGE 0.25
#define BELT_SIZE_PILL 0.25

//* Item `suit_storage_class` defines *//

#define SUIT_STORAGE_CLASS_HARDWEAR (1<<0)
#define SUIT_STORAGE_CLASS_SOFTWEAR (1<<1)
#define SUIT_STORAGE_CLASS_ARMOR (1<<2)

DECLARE_BITFIELD(suit_storage_class, list(
	BITFIELD_NAMED("Hardwear", SUIT_STORAGE_CLASS_HARDWEAR),
	BITFIELD_NAMED("Softwear", SUIT_STORAGE_CLASS_SOFTWEAR),
	BITFIELD_NAMED("Armor", SUIT_STORAGE_CLASS_ARMOR),
))
ASSIGN_BITFIELD(suit_storage_class, /obj/item, suit_storage_class)
ASSIGN_BITFIELD(suit_storage_class, /obj/item, suit_storage_class_allow)
ASSIGN_BITFIELD(suit_storage_class, /obj/item, suit_storage_class_disallow)
