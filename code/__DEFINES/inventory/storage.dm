//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Storage UI defines *//

/// Size of volumetric box icon
#define VOLUMETRIC_STORAGE_BOX_ICON_SIZE 32
/// Size of EACH left/right border icon for volumetric boxes
#define VOLUMETRIC_STORAGE_BOX_BORDER_SIZE 2
/// Minimum pixels an item must have in volumetric scaled storage UI
/// This must not be smaller than BOX_BORDER_SIZE * 2.
#define VOLUMETRIC_STORAGE_MINIMUM_PIXELS_PER_ITEM 6
/// Maximum number of objects that will be allowed to be displayed using the volumetric display system. Arbitrary number to prevent server lockups.
#define VOLUMETRIC_STORAGE_MAX_ITEMS 128
/// How much padding to give between items
#define VOLUMETRIC_STORAGE_ITEM_PADDING 1
/// How much padding to give to edges
#define VOLUMETRIC_STORAGE_EDGE_PADDING 0
/// Standard pixel width ratio for volumetric storage; 1 volume converts into this many pixels.
#define VOLUMETRIC_STORAGE_STANDARD_PIXEL_RATIO 8

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

#define WEIGHT_VOLUME_TINY				1
#define WEIGHT_VOLUME_SMALL			2
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
#define STORAGE_VOLUME_BACKPACK (WEIGHT_VOLUME_NORMAL * 7)
#define STORAGE_VOLUME_DUFFLEBAG (WEIGHT_VOLUME_NORMAL * 9)

//* Volumetrics - Item Volumes *//
