//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Tracks what items / whatnot are given from what, so
 * partial state changes are doable without rebuilding the entire robot's
 * state.
 */
/datum/robot_provisioning

	/// provisioned items / modules
	/// * lazy list
	var/list/obj/item/items
	/// provisioned emag-only items/modules
	/// * lazy list
	/// TODO: legacy, stop using this, emags unlocking functionality
	///       should be handled literally any other way
	var/list/obj/item/emag_items

/datum/robot_provisioning/proc/apply(mob/living/silicon/robot/robot)

/datum/robot_provisioning/proc/remove(mob/living/silicon/robot/robot)

#warn impl
