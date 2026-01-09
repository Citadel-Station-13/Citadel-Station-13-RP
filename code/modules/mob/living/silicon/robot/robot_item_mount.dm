//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Something for all owned items to be mounted on as a resource bus.
 */
/datum/item_mount/robot_item_mount
	var/datum/robot_resource_store/store

/datum/item_mount/robot_item_mount/New(datum/robot_resource_store/store)
	..()
	src.store = store

/datum/item_mount/robot_item_mount/Destroy()
	store = null
	return ..()

/datum/item_mount/robot_item_mount/material_get_amount(obj/item/item, key, material_id)
	var/datum/robot_resource/resource = store.provisioned_material_store[material_id]
	. = resource?.amount

/datum/item_mount/robot_item_mount/material_get_capacity(obj/item/item, key, material_id)
	var/datum/robot_resource/resource = store.provisioned_material_store[material_id]
	. = resource?.amount_max

/datum/item_mount/robot_item_mount/material_get_provider_name(obj/item/item, key, material_id)
	. = "material store"

/datum/item_mount/robot_item_mount/material_give_amount(obj/item/item, key, material_id, amount, force)
	var/datum/robot_resource/resource = store.provisioned_material_store[material_id]
	if(resource)
		if(force)
			. = amount
			resource.amount += amount
		else
			. = clamp(resource.amount_max - resource.amount, 0, amount)
			resource.amount += .

/datum/item_mount/robot_item_mount/material_use_amount(obj/item/item, key, material_id, amount)
	var/datum/robot_resource/resource = store.provisioned_material_store[material_id]
	if(resource)
		. = min(resource.amount, amount)
		resource.amount -= .

/datum/item_mount/robot_item_mount/stack_get_amount(obj/item/item, key, path)
	var/datum/robot_resource/resource = store.provisioned_stack_store[path]
	. = resource?.amount

/datum/item_mount/robot_item_mount/stack_get_capacity(obj/item/item, key, path)
	var/datum/robot_resource/resource = store.provisioned_stack_store[path]
	. = resource?.amount_max

/datum/item_mount/robot_item_mount/stack_get_provider_name(obj/item/item, key, path)
	. = "resource store"

/datum/item_mount/robot_item_mount/stack_give_amount(obj/item/item, key, path, amount, force)
	var/datum/robot_resource/resource = store.provisioned_stack_store[path]
	if(resource)
		if(force)
			. = amount
			resource.amount += amount
		else
			. = clamp(resource.amount_max - resource.amount, 0, amount)
			resource.amount += .

/datum/item_mount/robot_item_mount/stack_use_amount(obj/item/item, key, path, amount)
	var/datum/robot_resource/resource = store.provisioned_stack_store[path]
	if(resource)
		. = min(resource.amount, amount)
		resource.amount -= .

/datum/item_mount/robot_item_mount/lazy_energy_check(obj/item/item, key, joules)
	. = DYNAMIC_CELL_UNITS_TO_J(store.owner?.cell?.charge) >= joules

/datum/item_mount/robot_item_mount/lazy_energy_use(obj/item/item, key, joules, minimum_reserve)
	. = store.owner?.cell?.use(DYNAMIC_J_TO_CELL_UNITS(joules))

/datum/item_mount/robot_item_mount/reagent_get_amount(obj/item/item, key, datum/reagent/reagent)
	var/datum/robot_resource/resource = store.provisioned_reagent_store[reagent.id]
	. = resource?.amount

/datum/item_mount/robot_item_mount/reagent_erase_amount(obj/item/item, key, datum/reagent/reagent, amount)
	var/datum/robot_resource/resource = store.provisioned_reagent_store[reagent.id]
	if(resource)
		. = max(amount, resource.amount)
		resource.amount -= .

/datum/item_mount/robot_item_mount/reagent_spawn_amount(obj/item/item, key, datum/reagent/reagent, amount, force)
	var/datum/robot_resource/resource = store.provisioned_reagent_store[reagent.id]
	if(resource)
		if(force)
			. = amount
			resource.amount += amount
		else
			. = clamp(resource.amount_max - resource.amount, 0, amount)
			resource.amount += .

/datum/item_mount/robot_item_mount/extinguisher_get_volume(obj/item/extinguisher/extinguisher, key)
	var/datum/robot_resource/resource = store.provisioned_reagent_store[/datum/reagent/water::id]
	. = resource?.amount

/datum/item_mount/robot_item_mount/extinguisher_transfer_volume(obj/item/extinguisher/extinguisher, key, requested, datum/reagent_holder/into_holder)
	var/datum/robot_resource/resource = store.provisioned_reagent_store[/datum/reagent/water::id]
	if(resource)
		. = min(requested, resource.amount)
		into_holder.add_reagent(/datum/reagent/water::id, .)
