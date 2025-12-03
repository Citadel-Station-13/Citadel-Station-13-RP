//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Tracks what items / whatnot are given from what, so
 * partial state changes are doable without rebuilding the entire robot's
 * state.
 *
 * # Caveats
 * * Internal state (items in us, as an example) should not be mutated without calling helpers,
 *   or adding / removing.
 * * Can only exist for one borg at a time.
 */
/datum/robot_provisioning
	/// Applied
	var/mob/living/silicon/robot/applied_to_robot
	/// provisioned items / modules
	/// * lazy list
	var/list/obj/item/items
	/// provisioned emag-only items/modules
	/// * lazy list
	/// TODO: legacy, stop using this, emags unlocking functionality
	///       should be handled literally any other way
	var/list/obj/item/emag_items
	/// suppressed items, item = true ?
	/// * suppressed items aren't accessible by the robot (but still exist in them)
	var/list/obj/item/suppressed_items
	/// relay mount
	var/datum/item_mount/robot_provisioning/relay_mount
	/// emaged status?
	var/emag_enabled = FALSE

/datum/robot_provisioning/New()
	relay_mount = new(src)

/datum/robot_provisioning/Destroy()
	if(applied_to_robot)
		remove()
	QDEL_LIST(items)
	QDEL_LIST(emag_items)
	QDEL_NULL(relay_mount)
	return ..()

/datum/robot_provisioning/proc/apply(mob/living/silicon/robot/robot)
	if(applied_to_robot)
		remove()
	set_emag_enabled(robot.emag_items)

/datum/robot_provisioning/proc/remove()

#warn impl

/datum/robot_provisioning/proc/add_item(obj/item/item)

	on_item_add(item, FALSE)

/datum/robot_provisioning/proc/remove_item(obj/item/item)

	on_item_remove(item, FALSE)

/datum/robot_provisioning/proc/add_emag_item(obj/item/item)

	on_item_add(item, TRUE)

/datum/robot_provisioning/proc/remove_emag_item(obj/item/item)

	on_item_remove(item, TRUE)

/datum/robot_provisioning/proc/set_emag_enabled(new_state)
	if(emag_enabled == new_state)
		return
	emag_enabled = new_state
	#warn impl

/**
 * @return list of items suppressed
 */
/datum/robot_provisioning/proc/suppress_all_types_of(path) as /list
	#warn impl

/**
 * @return list of items unsuppressed
 */
/datum/robot_provisioning/proc/unsuppress_all_types_of(path) as /list
	#warn impl

/datum/robot_provisioning/proc/on_item_add(obj/item/item, is_emag_item)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(!applied_to_robot)
		return

/datum/robot_provisioning/proc/on_item_remove(obj/item/item, is_emag_item)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(!applied_to_robot)
		return

/datum/robot_provisioning/proc/cleanup_item(obj/item/item)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/datum/item_mount/robot_provisioning
	var/datum/robot_provisioning/provisioning

/datum/item_mount/robot_provisioning/New(datum/robot_provisioning/provisioning)
	src.provisioning = provisioning

/datum/item_mount/robot_provisioning/Destroy()
	provisioning = null
	return ..()

/datum/item_mount/robot_provisioning/on_item_unmount(obj/item/item)
	..()
	provisioning?.cleanup_item(item)
