//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/inventory/robot

/datum/inventory/robot/robot_module_get_slots()
	return length(active_modules)

/datum/inventory/robot/robot_module_set_slots(count)
	LAZYINITLIST(active_modules)
	active_modules.len = count
	#warn update ui

/datum/inventory/robot/robot_module_get_all()
	return robot_modules ? robot_modules.Copy() : list()

/datum/inventory/proc/robot_module_get_active()
	. = list()
	for(var/obj/item/module in active_modules)
		. += module

/datum/inventory/robot/robot_module_is_active(obj/item/item)
	return active_modules ? active_modules.Find(item) : 0

/datum/inventory/robot/robot_module_is_registered(obj/item/item)
	return item in robot_modules

/datum/inventory/robot/robot_module_register_impl(obj/item/item)

/datum/inventory/robot/robot_module_unregister_impl(obj/item/item)

/datum/inventory/robot/robot_module_equip_impl(obj/item/item, index)

/datum/inventory/robot/robot_module_unequip_impl(obj/item/item, index)

/datum/inventory/robot/on_robot_module_equip(obj/item/item, index)
	..()

/datum/inventory/robot/on_robot_module_unequip(obj/item/item, index)
	..()

/datum/inventory/robot/on_robot_module_register(obj/item/item)
	..()

/datum/inventory/robot/on_robot_module_unregister(obj/item/item)
	..()

#warn impl all
