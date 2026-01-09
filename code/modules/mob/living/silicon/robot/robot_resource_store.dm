//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Internal abstraction of stored resources.
 *
 * Stores:
 * * Arbitrary stack-types
 * * Arbitrary materials
 * * Arbitrary reagents
 * * Arbitrary IDs
 */
/datum/robot_resource_store
	//* Storage *//

	/// Provisioned store for stacks.
	/// * Measured in sheets
	/// * Stack type to `/datum/robot_resource/provisioned`
	/// * Lazylist outside of provisioning. Lists are always formed during provisioning.
	/// * Automatically given to the robot as a mounted item if provided.
	var/list/provisioned_stack_store
	/// Provisioned store for materials.
	/// * Measured in cm3
	/// * Material id to `/datum/robot_resource/provisioned`
	/// * Lazylist outside of provisioning. Lists are always formed during provisioning.
	/// * Automatically given to the robot as a mounted item if provided.
	var/list/provisioned_material_store
	/// Provisioned store for reagents.
	/// * Measured in units
	/// * Reagent id to `/datum/robot_resource/provisioned`
	/// * Lazylist outside of provisioning. Lists are always formed during provisioning.
	var/list/provisioned_reagent_store
	/// Provisioned store for misc string-key resources.
	/// * Measured arbitrarily
	/// * String key to `/datum/robot_resource/provisioned`
	/// * Lazylist outside of provisioning. Lists are always formed during provisioning.
	var/list/provisioned_resource_store

	//* Items *//

	/// Material ID to stack item
	var/list/provided_material_items
	/// Stack ID to stack item
	var/list/provided_stack_items

	//* Provider API *//

	/// Stack synthesizer used as a provider API.
	var/datum/item_mount/robot_item_mount/item_mount

	//* Robot *//
	/// Our owner
	var/mob/living/silicon/robot/owner

/datum/robot_resource_store/New(mob/living/silicon/robot/owner)
	item_mount = new(src)
	src.owner = owner

/datum/robot_resource_store/Destroy()
	QDEL_NULL(item_mount)
	owner = null
	return ..()

/datum/robot_resource_store/proc/prep_provisioning()
	LAZYINITLIST(provisioned_stack_store)
	LAZYINITLIST(provisioned_material_store)
	LAZYINITLIST(provisioned_reagent_store)
	LAZYINITLIST(provisioned_resource_store)

/datum/robot_resource_store/proc/finish_provisioning()
	UNSETEMPTY(provisioned_stack_store)
	UNSETEMPTY(provisioned_material_store)
	UNSETEMPTY(provisioned_reagent_store)
	UNSETEMPTY(provisioned_resource_store)

	for(var/id in provisioned_material_store)
		if(provided_material_items[id])
			continue
		var/datum/prototype/material/resolved_material = RSmaterials.fetch_local_or_throw(id)
		if(!resolved_material)
			continue
		var/path = resolved_material.stack_type
		var/obj/item/stack/material/created = new path(null)
		RegisterSignal(created, COMSIG_PARENT_QDELETING, PROC_REF(on_provided_item_del))
		LAZYSET(provided_stack_items, path, created)
		owner.robot_inventory.inv_register(created)

	for(var/path in provisioned_stack_store)
		if(provided_stack_items[path])
			continue
		var/obj/item/stack/created = new path(null)
		RegisterSignal(created, COMSIG_PARENT_QDELETING, PROC_REF(on_provided_item_del))
		LAZYSET(provided_stack_items, path, created)
		owner.robot_inventory.inv_register(created)

/datum/robot_resource_store/proc/wipe_provisioning()
	QDEL_LIST_ASSOC_VAL(provided_material_items)
	QDEL_LIST_ASSOC_VAL(provided_stack_items)
	provisioned_stack_store = null
	provisioned_material_store = null
	provisioned_reagent_store = null
	provisioned_resource_store = null

/datum/robot_resource_store/proc/regen_provisioned(seconds)
	for(var/key in provisioned_stack_store)
		var/datum/robot_resource/provisioned/resource = provisioned_stack_store[key]
		resource.regen(seconds)
	for(var/key in provisioned_material_store)
		var/datum/robot_resource/provisioned/resource = provisioned_material_store[key]
		resource.regen(seconds)
	for(var/key in provisioned_reagent_store)
		var/datum/robot_resource/provisioned/resource = provisioned_reagent_store[key]
		resource.regen(seconds)
	for(var/key in provisioned_resource_store)
		var/datum/robot_resource/provisioned/resource = provisioned_resource_store[key]
		resource.regen(seconds)

/datum/robot_resource_store/proc/on_provided_item_del(obj/item/source)
	SIGNAL_HANDLER

	if(istype(source, /obj/item/stack))
		if(istype(source, /obj/item/stack/material))
			var/obj/item/stack/material/mat = source
			if(provided_material_items[mat.material.id] != source)
				STACK_TRACE("provided stack didn't match [mat.material.id] deleting vs [provided_material_items[source.type]:material:id] existing")
			else
				provided_material_items -= mat.material.id
		else
			if(provided_stack_items[source.type] != source)
				STACK_TRACE("provided stack didn't match [source.type] deleting vs [provided_stack_items[source.type]:type] existing")
			else
				provided_stack_items -= source.type

