//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * The baseline physical chassis for a silicon.
 *
 * * This is considered intrinsic, and cannot be changed on a robot without fully rebuilding its state.
 *
 * Contains:
 *
 * * Base physical stats
 * * Internal slots / space / interconnects
 * * WIP
 */
/datum/prototype/robot_chassis
	abstract_type = /datum/prototype/robot_chassis

	/// our name
	var/name = "???"
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

/datum/prototype/robot_chassis/proc/create_provisioning() as /datum/robot_provisioning
	var/datum/robot_provisioning/creating = new
	. = creating
	var/list/i_normal = list()
	var/list/i_emag = list()
	create_mounted_item_descriptors(i_normal, i_emag)
	for(var/obj/item/descriptor as anything in i_normal)
		var/obj/item/resolved
		if(istype(descriptor))
			resolved = descriptor
		else if(ispath(descriptor))
			resolved = new descriptor
		else if(IS_ANONYMOUS_TYPEPATH(descriptor))
			resolved = new descriptor
		else
			stack_trace("invalid descriptor [descriptor] on [id] ([type])")
			continue
		creating.add_item(resolved)
	for(var/obj/item/descriptor as anything in i_emag)
		var/obj/item/resolved
		if(istype(descriptor))
			resolved = descriptor
		else if(ispath(descriptor))
			resolved = new descriptor
		else if(IS_ANONYMOUS_TYPEPATH(descriptor))
			resolved = new descriptor
		else
			stack_trace("invalid descriptor [descriptor] on [id] ([type])")
			continue
		creating.add_emag_item(resolved)

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
/datum/prototype/robot_chassis/proc/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	if(normal_out)
		if(mounted_item_descriptor_inject_normal)
			normal_out |= mounted_item_descriptor_inject_normal
	if(emag_out)
		if(mounted_item_descriptor_inject_emag)
			emag_out |= mounted_item_descriptor_inject_emag
