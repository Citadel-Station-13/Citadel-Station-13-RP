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
	/// * Stack type to `/datum/robot_resource/provisioned`
	/// * Lazylist outside of provisioning. Lists are always formed during provisioning.
	/// * Automatically given to the robot as a mounted item if provided.
	var/list/provisioned_stack_store
	/// Provisioned store for materials.
	/// * Material id to `/datum/robot_resource/provisioned`
	/// * Lazylist outside of provisioning. Lists are always formed during provisioning.
	/// * Automatically given to the robot as a mounted item if provided.
	var/list/provisioned_material_store
	/// Provisioned store for reagents.
	/// * Reagent id to `/datum/robot_resource/provisioned`
	/// * Lazylist outside of provisioning. Lists are always formed during provisioning.
	var/list/provisioned_reagent_store
	/// Provisioned store for misc string-key resources.
	/// * String key to `/datum/robot_resource/provisioned`
	/// * Lazylist outside of provisioning. Lists are always formed during provisioning.
	var/list/provisioned_resource_store

	//* Provider API *//

	/// Stack synthesizer used as a provider API.
	var/datum/stack_provider/robot_stack_provider/stack_provider

/datum/robot_resource_store/New()
	stack_provider = new(src)

/datum/robot_resource_store/Destroy()
	QDEL_NULL(stack_provider)
	return ..()

/datum/robot_resource_store/proc/prep_provisioning()
	LAZYINITLIST(provisioned_stack_store)
	LAZYINITLIST(provisioned_material_store)
	LAZYINITLIST(provisioned_reagent_store)
	LAZYINITLIST(provisioned_resource_store)

/datum/robot_resource_store/proc/finish_provisioning()
	LAZYCLEARLIST(provisioned_stack_store)
	LAZYCLEARLIST(provisioned_material_store)
	LAZYCLEARLIST(provisioned_reagent_store)
	LAZYCLEARLIST(provisioned_resource_store)

/datum/robot_resource_store/proc/wipe_provisioning()
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
