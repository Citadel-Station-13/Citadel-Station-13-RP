//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// proc: dropped() on /obj/item
// todo: this should be in procs.dm and the names need to be changed probably
// todo: comsig instead?
/// relocated; return false
#define ITEM_RELOCATED_BY_DROPPED -1

//* Item `suit_storage_class` defines *//

#define SUIT_STORAGE_CLASS_HARDWEAR (1<<0)
#define SUIT_STORAGE_CLASS_SOFTWEAR (1<<1)
#define SUIT_STORAGE_CLASS_ARMOR (1<<2)

DECLARE_BITFIELD(suit_storage_class, list(
	BITFIELD_NEW("Hardwear", SUIT_STORAGE_CLASS_HARDWEAR),
	BITFIELD_NEW("Softwear", SUIT_STORAGE_CLASS_SOFTWEAR),
	BITFIELD_NEW("Armor", SUIT_STORAGE_CLASS_ARMOR),
))
ASSIGN_BITFIELD(suit_storage_class, /obj/item, suit_storage_class)
ASSIGN_BITFIELD(suit_storage_class, /obj/item, suit_storage_class_allow)
ASSIGN_BITFIELD(suit_storage_class, /obj/item, suit_storage_class_disallow)
