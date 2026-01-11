//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * tracks available resources on the rigsuit, doubles as an item mount provider.
 *
 * # Routing
 * Virtual routes exist for some resources.
 *
 * ## Gas Routing
 * Gas uses single-source-multiple-consumer routing. This is for speed; by default nothing
 * should be pulling from multiple at the same time.
 *
 * ## Reagent Routing
 * Reagent uses single-source-multiple-consumer routing. This is for speed; by default nothing
 * should be pulling from multiple at the same time.
 *
 * ## Material Routing
 * Materials uses prioritized multiple-source-multiple-consumer routing. This is because
 * there is no semantics for 'mixing'; it's very possible to do ordered pulls.
 *
 * ## Sources
 * Sources may be **any** rig component via rig component resource API.
 */
/datum/item_mount/rig_resources
	/// registered modules by key for gas
	var/list/gas_routes
	/// registered modules by key for reagents
	var/list/reagent_routes
	/// ordered registered modules associated to priority by key for materials
	var/list/material_routes

/datum/item_mount/rig_resources/New(obj/item/rig/controller)
	// static internals route
	add_gas_route("internals")
	// static jetpack route
	add_gas_route("jetpack")
	// static synthesis route to pull from
	add_material_route("synthesis")

/datum/item_mount/rig_resources/Destroy()
	return ..()

/datum/item_mount/rig_resources/proc/add_gas_route(key)

/datum/item_mount/rig_resources/proc/remove_gas_route(key)

/datum/item_mount/rig_resources/proc/add_reagent_route(key)

/datum/item_mount/rig_resources/proc/remove_reagent_route(key)

/datum/item_mount/rig_resources/proc/add_material_route(key)

/datum/item_mount/rig_resources/proc/remove_material_route(key)




#warn impl
