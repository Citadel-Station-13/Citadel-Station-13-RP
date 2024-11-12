//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* gun attachment slot *//

/**
 * * align_x is center pixel (or the left pixel of the 2-wide center, if center is 2 wide)
 * * align_y is topmost pixel extending out of gun
 */
#define GUN_ATTACHMENT_SLOT_GRIP "grip"
/**
 * * align_x is leftmost pixel of the part extending out of gun
 * * align_y is center pixel (or the bottom pixel of center, if center is 2 wide)
 */
#define GUN_ATTACHMNET_SLOT_MUZZLE "muzzle"
/**
 * * align_x is center pixel (or the left pixel of the 2-wide center, if center is 2 wide)
 * * align_y is bottom pixel extending out of gun
 */
#define GUN_ATTACHMENT_SLOT_RAIL "rail"
/**
 * * align_x is leftmost pixel of the part extending out of gun
 * * align_y is center pixel (or the bottom pixel of center, if center is 2 wide)
 * * this means that for many sidebarrel's, the align_x is actually right of the actual attachment because
 *   it'll be aligned to the pixel right of the muzzle, not to the interior of the gun!
 */
#define GUN_ATTACHMENT_SLOT_SIDEBARREL "sidebarrel"
/**
 * * align_x is rightmost pixel extending left from the gun
 * * align_y is top pixel of the area that actually attaches to the gun
 */
#define GUN_ATTACHMENT_SLOT_STOCK "stock"
/**
 * * align_x is center pixel (or the left pixel of the 2-wide center, if center is 2 wide)
 * * align_y is topmost pixel extending out of gun
 */
#define GUN_ATTACHMENT_SLOT_UNDERBARREL "underbarrel"

// todo: DEFINE_ENUM

//* gun attachment types *//

/// flashlight
#define GUN_ATTACHMENT_TYPE_FLASHLIGHT (1<<0)
/// targeting laser
#define GUN_ATTACHMENT_TYPE_AIM_LASER (1<<1)
/// scope
#define GUN_ATTACHMENT_TYPE_SCOPE (1<<2)
/// magharness, lanyard, etc
#define GUN_ATTACHMENT_TYPE_HARNESS (1<<3)

// todo: DEFINE_BITFIELD
