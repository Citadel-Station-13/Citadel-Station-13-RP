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
	/// items to inject into normal out
	/// * paths are allowed
	/// * anonymous types are allowed
	/// * item instances are **not allowed** and will result in shit exploding!
	var/list/mounted_item_descriptor_inject_normal
	/// items to inject into emag out
	/// * paths are allowed
	/// * anonymous types are allowed
	/// * item instances are **not allowed** and will result in shit exploding!
	var/list/mounted_item_descriptor_inject_emag

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
	if(normal_out)
		if(mounted_item_descriptor_inject_normal)
			normal_out |= mounted_item_descriptor_inject_normal
	if(emag_out)
		if(mounted_item_descriptor_inject_emag)
			emag_out |= mounted_item_descriptor_inject_emag
