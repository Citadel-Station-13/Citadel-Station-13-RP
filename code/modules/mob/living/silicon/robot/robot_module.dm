//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

#warn #define DECLARE_ROBOT_MODULE?

/**
 * The baseline configuration for a silicon.
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

	/// /obj/item/robot_module typepath
	var/use_robot_module_path = /obj/item/robot_module/robot

	/// Allowed robot frames.
	/// * set to list of typepaths/anonymous types to init
	var/list/datum/robot_frame/allowed_frames = list()

	/// show on manifest?
	#warn hook
	var/legacy_show_on_manifest = FALSE

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
 *
 * * /obj/item/stack's are not allowed in here. Put those in `create_stacks()`.
 */
#warn hook
/datum/prototype/robot_module/proc/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	if(normal_out)
		normal_out |= list(
			/obj/item/flash,
		)

/**
 * Returns a list of `/datum/stack_synth/robot_stack_synth` types to make.
 *
 * @return list()
 */
#warn hook
/datum/prototype/robot_module/proc/get_stack_synth_types()
	return list()
