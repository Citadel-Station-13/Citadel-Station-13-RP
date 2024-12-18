//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * The baseline physical chassis for a silicon.
 *
 * Contains:
 *
 * * Base physical stats
 * * Internal slots / space / interconnects
 * * WIP
 */
/datum/prototype/robot_chassis

/datum/prototype/robot_chassis

/**
 * Returns a list of descriptors for mounted items
 *
 * A descriptor can be:
 * * An item instance
 * * An item path
 * * An anonymous type of an item
 *
 * It's recommended to use item path, then anonymous types, and lastly, item instances.
 * Item instances should be created in nullspace.
 *
 * The caller must handle all of these.
 * Unused item instances must be qdel'd.
 */
#warn hook
/datum/prototype/robot_chassis/proc/create_mounted_item_descriptors(list/normal_out, list/emag_out)
