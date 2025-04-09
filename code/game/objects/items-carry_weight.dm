//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//*                         Carry Weight                               *//
//* The carry weight system is a modular system used to discourage     *//
//* carrying too much, through both weight (recursive weight) and      *//
//* encumbrance (only on the stuff worn, and potentially also in hand) *//

/obj/item/proc/get_weight()
	return weight + obj_storage?.get_containing_weight()

/obj/item/proc/get_encumbrance()
	return encumbrance

/obj/item/proc/get_flat_encumbrance()
	return flat_encumbrance

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

/obj/item/proc/update_encumbrance()
	if(isnull(encumbrance_registered))
		return null
	. = get_encumbrance()
	if(. == encumbrance_registered)
		return 0
	. -= encumbrance_registered
	encumbrance_registered += .
	var/mob/living/wearer = get_worn_mob()
	if(istype(wearer))
		wearer.adjust_current_carry_encumbrance(.)

/obj/item/proc/update_flat_encumbrance()
	var/mob/living/wearer = get_worn_mob()
	if(istype(wearer))
		wearer.recalculate_carry()

/obj/item/proc/set_weight(amount)
	if(amount == weight)
		return
	var/old = weight
	weight = amount
	update_weight()
	propagate_weight(old, weight)

/obj/item/proc/set_encumbrance(amount)
	if(amount == encumbrance)
		return
	encumbrance = amount
	update_encumbrance()

/obj/item/proc/set_flat_encumbrance(amount)
	if(amount == flat_encumbrance)
		return
	flat_encumbrance = amount
	update_flat_encumbrance()

/obj/item/proc/set_slowdown(amount)
	if(amount == slowdown)
		return
	slowdown = amount
	get_worn_mob()?.update_item_slowdown()

/obj/item/proc/propagate_weight(old_weight, new_weight)
	loc?.on_contents_weight_change(src, old_weight, new_weight)
