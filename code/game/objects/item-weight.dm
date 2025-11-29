//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//*                          Weight                              *//
//* The weight system is a modular, recursive system used to     *//
//* naturally balance things like storage capacities and move    *//
//* speeds on anything from machines to humans to vehicles.      *//

// TODO: /atom/movable level.

/obj/item/proc/get_weight()
	return weight + obj_storage?.get_containing_weight()

/obj/item/proc/update_weight()
	if(isnull(weight_registered))
		return null
	. = get_weight()
	if(. == weight_registered)
		return 0
	. -= weight_registered
	weight_registered += .
	var/mob/living/wearer = get_worn_mob()
	if(istype(wearer))
		wearer.adjust_current_carry_weight(.)

/obj/item/proc/set_weight(amount)
	if(amount == weight)
		return
	var/old = weight
	weight = amount
	update_weight()
	propagate_weight(old, weight)

/obj/item/proc/propagate_weight(old_weight, new_weight)
	loc?.on_contents_weight_change(src, old_weight, new_weight)
