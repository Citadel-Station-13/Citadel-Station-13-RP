//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* Storage UI defines *//

/// Size of volumetric box icon
#define VOLUMETRIC_STORAGE_BOX_ICON_SIZE 32
/// Size of EACH left/right border icon for volumetric boxes
#define VOLUMETRIC_STORAGE_BOX_BORDER_SIZE 2
/// Minimum pixels an item must have in volumetric scaled storage UI
/// This must not be smaller than BOX_BORDER_SIZE * 2.
#define VOLUMETRIC_STORAGE_MINIMUM_PIXELS_PER_ITEM 12
/// Maximum number of objects that will be allowed to be displayed using the volumetric display system. Arbitrary number to prevent server lockups.
#define VOLUMETRIC_STORAGE_MAX_ITEMS 128
/// How much padding to give between items
#define VOLUMETRIC_STORAGE_ITEM_PADDING 1
/// How much padding to give to edges
#define VOLUMETRIC_STORAGE_EDGE_PADDING 0
/// Standard pixel width ratio for volumetric storage; 1 volume converts into this many pixels.
#define VOLUMETRIC_STORAGE_STANDARD_PIXEL_RATIO 8
/// Used if a UI would be very, very small; this is the max we can inflate the calculation to.
#define VOLUMETRIC_STORAGE_INFLATED_PIXEL_RATIO 16
/// If volumetric storage is below this, inflate the pixel ratio up to this
#define VOLUMETRIC_STORAGE_INFLATE_TO_TILES 3.5

//* Storage access *//

#define STORAGE_REACH_DEPTH 3

//* Storage quick gather modes *//

/// one at a time on click
#define STORAGE_QUICK_GATHER_COLLECT_ONE 1
/// all on tile
#define STORAGE_QUICK_GATHER_COLLECT_ALL 2
/// same typepath
#define STORAGE_QUICK_GATHER_COLLECT_SAME 3

//* Storage UI - we shouldn't hardcode this but I don't care. *//
//  todo: we should care

#define STORAGE_UI_START_TILE_X 3
#define STORAGE_UI_START_TILE_Y 1
#define STORAGE_UI_START_PIXEL_X 16
#define STORAGE_UI_START_PIXEL_Y 16
#define STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(X) max(4, X - 8)
#define STORAGE_UI_MAX_ROWS 5

//* w_class *//

// ITEM INVENTORY WEIGHT, FOR w_class
// todo: lmao this is so outdated, semantically
// keep this 1 to n, and make sure w_class_to_volume is updated.

#define WEIGHT_CLASS_MIN 0
#define WEIGHT_CLASS_MAX 6

/// Usually items smaller then a human hand, ex: Playing Cards, Lighter, Scalpel, Coins/Money
#define WEIGHT_CLASS_TINY     1
/// Pockets can hold small and tiny items, ex: Flashlight, Multitool, Grenades, GPS Device
#define WEIGHT_CLASS_SMALL    2
/// Standard backpacks can carry tiny, small & normal items, ex: Fire extinguisher, Stunbaton, Gas Mask, Metal Sheets
#define WEIGHT_CLASS_NORMAL   3
/// Items that can be weilded or equipped but not stored in a normal bag, ex: Defibrillator, Backpack, Space Suits
#define WEIGHT_CLASS_BULKY    4
/// Usually represents objects that require two hands to operate, ex: Shotgun, Two Handed Melee Weapons - Can not fit in Boh
#define WEIGHT_CLASS_HUGE     5
/// Essentially means it cannot be picked up or placed in an inventory, ex: Mech Parts, Safe - Can not fit in Boh
#define WEIGHT_CLASS_GIGANTIC 6

//* Volumetrics - Default Item Volumes *//

#define WEIGHT_VOLUME_TINY				0.5
#define WEIGHT_VOLUME_SMALL			1
#define WEIGHT_VOLUME_NORMAL			4
#define WEIGHT_VOLUME_BULKY			8
#define WEIGHT_VOLUME_HUGE				16
#define WEIGHT_VOLUME_GIGANTIC			32

GLOBAL_REAL_LIST(w_class_to_volume) = list(
	WEIGHT_VOLUME_TINY,
	WEIGHT_VOLUME_SMALL,
	WEIGHT_VOLUME_NORMAL,
	WEIGHT_VOLUME_BULKY,
	WEIGHT_VOLUME_HUGE,
	WEIGHT_VOLUME_GIGANTIC,
)

//* Volumetrics - Storage Volumes *//

#define STORAGE_VOLUME_BOX (WEIGHT_VOLUME_SMALL * 7)
#define STORAGE_VOLUME_BOX_2X (WEIGHT_VOLUME_SMALL * 14)
#define STORAGE_VOLUME_BACKPACK (WEIGHT_VOLUME_NORMAL * 7)
#define STORAGE_VOLUME_DUFFLEBAG (WEIGHT_VOLUME_NORMAL * 9)

//* Volumetrics - Item Volumes *//

// 2x capacity to pack small items for now, unfortunately
#define ITEM_VOLUME_BOX (WEIGHT_VOLUME_NORMAL * 1)
// for some bigger boxes
#define ITEM_VOLUME_BOX_AND_HALF (WEIGHT_VOLUME_NORMAL * 1.5)

#define ITEM_VOLUME_SMALL_CELL (WEIGHT_VOLUME_NORMAL / 4)
#define ITEM_VOLUME_WEAPON_CELL (WEIGHT_VOLUME_NORMAL / 2)
#define ITEM_VOLUME_MEDIUM_CELL (WEIGHT_VOLUME_NORMAL * 1)
#define ITEM_VOLUME_LARGE_CELL (WEIGHT_VOLUME_NORMAL * 2)

#define ITEM_VOLUME_PISTOL_MAG (WEIGHT_VOLUME_NORMAL / 4)
#define ITEM_VOLUME_RIFLE_MAG (WEIGHT_VOLUME_NORMAL / 2)

#define ITEM_VOLUME_AMMO_CASING (WEIGHT_VOLUME_TINY / 2)

//* Item `belt_storage_class` defines *//

/// Doesn't go in a belt
#define BELT_CLASS_INVALID 0
/// small grenades, pill bottles, syringes, pistol mags, etc
#define BELT_CLASS_SMALL 1
/// rifle mags, welding torches, crowbars, etc
#define BELT_CLASS_MEDIUM 2
/// sidearms, rpds, etc
#define BELT_CLASS_LARGE 3

#define BELT_CLASS_FOR_SMALL_CELL BELT_CLASS_SMALL
#define BELT_CLASS_FOR_WEAPON_CELL BELT_CLASS_MEDIUM
#define BELT_CLASS_FOR_MEDIUM_CELL BELT_CLASS_LARGE
#define BELT_CLASS_FOR_LARGE_CELL BELT_CLASS_INVALID

// TODO: DECLARE_ENUM

//* Item `belt_storage_size` defines *//

/// Default belt size for items
#define BELT_SIZE_DEFAULT 1

/// Default belt size for ammo casings
#define BELT_SIZE_FOR_AMMO_CASING 0.25
/// Default magazine size
#define BELT_SIZE_FOR_MAGAZINE 1

/// Default flashlight size
#define BELT_SIZE_FOR_FLASHLIGHT 1

#define BELT_SIZE_FOR_SYRINGE 0.25
#define BELT_SIZE_FOR_PILL 0.25

#define BELT_SIZE_FOR_SMALL_CELL 1
#define BELT_SIZE_FOR_WEAPON_CELL 1
#define BELT_SIZE_FOR_MEDIUM_CELL 1
#define BELT_SIZE_FOR_LARGE_CELL 1

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
