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

/datum/robot_provisioning/Destroy()
	if(applied_to_robot)
		remove()
	return ..()

/datum/robot_provisioning/proc/apply(mob/living/silicon/robot/robot)
	if(applied_to_robot)
		remove()

/datum/robot_provisioning/proc/remove()

#warn impl
