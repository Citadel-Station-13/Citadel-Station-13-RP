//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * tracks available resources on the rigsuit, doubles as an item mount provider.
 */
/datum/item_mount/rig_resources
	/// item mount
	var/datum/item_mount/rig_bus/item_bus

	/// registered resource_store modules by key for gas
	var/list/gas_routes

/datum/item_mount/rig_resources/New(obj/item/rig/controller)
	item_bus = new(src)
	add_gas_route("internals")
	add_gas_route("jetpack")

/datum/item_mount/rig_resources/Destroy()
	QDEL_NULL(item_bus)
	return ..()

/datum/item_mount/rig_resources/proc/add_gas_route(key)

/datum/item_mount/rig_resources/proc/remove_gas_route(key)




#warn impl
