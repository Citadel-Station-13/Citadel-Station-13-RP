//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * The baseline configuration for a silicon.
 *
 * * This is considered intrinsic, and cannot be changed on a robot without fully rebuilding its state.
 *
 * Contains:
 *
 * * Inbuilt items
 * * WIP
 */
/datum/prototype/robot_module
	abstract_type = /datum/prototype/robot_module

	/// Allow selection
	//  todo: replace with selection class / groups / something to that effect
	var/selectable = FALSE

	/// /obj/item/robot_module_legacy typepath
	var/use_robot_module_path = /obj/item/robot_module_legacy/robot

	/// Allowed robot frames.
	/// * set to list of typepaths/anonymous types to init
	var/list/datum/robot_frame/frames = list()

	/// Generate robot frames from iconsets.
	/// * set to list of `/datum/prototype/robot_iconset` ids or paths
	/// * the iconset must have `chassis` set, or this will runtime.
	var/list/auto_iconsets = list()

	/// Required selection groups
	/// * If both this and `selection_groups_any` are null, this can't be picked.
	var/list/selection_groups_all
	/// Required selection groups
	/// * If both this and `selection_groups_all` are null, this can't be picked.
	var/list/selection_groups_any

	/// show on manifest?
	#warn hook
	var/legacy_show_on_manifest = FALSE

	//* Lighting *//
	/// Default lighting color
	var/light_color = "#ffffff"

	//* Identity *//
	/// Our display name
	var/display_name = "???"
	/// Our examine name, defaulting to display name
	var/visible_name

	//* Mounted Item Descriptor - Injectors *//
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

#warn impL
#warn init frames

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
/datum/prototype/robot_module/proc/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	if(normal_out)
		if(mounted_item_descriptor_inject_normal)
			normal_out |= mounted_item_descriptor_inject_normal
		normal_out |= list(
			/obj/item/flash,
			/obj/item/multitool, // todo: special robot multitool that can interface with machines?
			/obj/item/gps/robot,
			/obj/item/tool/crowbar/cyborg,
		)
	if(emag_out)
		if(mounted_item_descriptor_inject_emag)
			emag_out |= mounted_item_descriptor_inject_emag

/**
 * Provision a robot's resource store.
 *
 * * All of the store's lists should be initalized, even if they're generally lazy.
 *   You can lazyclearlist it later.
 */
/datum/prototype/robot_module/proc/provision_resource_store(datum/robot_resource_store/store)
	return

/datum/prototype/robot_module/proc/legacy_custom_regenerate_resources(mob/living/silicon/robot/robot, dt, multiplier)
	return

//* Name / Description / Identity *//

/**
 * Get name as seen by things like robotics consoles that don't use another way
 * to resolve who / what we are.
 */
/datum/prototype/robot_module/proc/get_display_name()
	return display_name

/**
 * Get visible name on examine
 */
/datum/prototype/robot_module/proc/get_visible_name()
	return visible_name || display_name

//* Application *//

/**
 * Called when we're being set onto a robot.
 */
/datum/prototype/robot_module/proc/on_install(mob/living/silicon/robot/robot)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Called when we're being unset from a robot.
 */
/datum/prototype/robot_module/proc/on_uninstall(mob/living/silicon/robot/robot)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
