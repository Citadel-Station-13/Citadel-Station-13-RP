//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Abstraction *//

/mob/living/_slot_by_item(obj/item/I)
	if(back == I)
		return SLOT_ID_BACK
	else if(wear_mask == I)
		return SLOT_ID_MASK
	return ..()

/mob/living/_item_by_slot(slot)
	switch(slot)
		if(SLOT_ID_MASK)
			return wear_mask
		if(SLOT_ID_BACK)
			return back
		else
			return ..()

/mob/living/_set_inv_slot(slot, obj/item/I, flags)
	switch(slot)
		if(SLOT_ID_BACK)
			back = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_back()
		if(SLOT_ID_MASK)
			wear_mask = I
			if(!(flags & INV_OP_NO_UPDATE_ICONS))
				update_inv_wear_mask()
				// todo: only rebuild when needed for BLOCKHAIR|BLOCKHEADHAIR
				update_hair(0)
				update_inv_ears()
			if(!(flags & INV_OP_NO_LOGIC))
				if(!wear_mask)
					// todo: why are internals code shit
					if(internal)
						internal = null
						if(internals)
							internals.icon_state = "internal0"
		else
			return ..()

/mob/living/_get_all_slots(include_restraints)
	. = ..()
	if(back)
		. += back.inv_slot_attached()
	if(wear_mask)
		. += wear_mask.inv_slot_attached()

/mob/living/_get_inventory_slot_ids()
	return ..() + list(
		SLOT_ID_BACK,
		SLOT_ID_MASK
	)

//* Carry Weight *//

// don't call this you shouldn't need to
/mob/living/update_carry_slowdown()
	recalculate_carry()

/mob/living/proc/recalculate_carry(update = TRUE)
	var/tally_weight = 0
	var/tally_encumbrance = 0
	var/flat_encumbrance = 0
	for(var/obj/item/I as anything in get_equipped_items())
		tally_weight += (I.weight_registered = I.get_weight())
		if(I.is_being_held())
			if(!(I.item_flags & ITEM_ENCUMBERS_WHILE_HELD))
				I.encumbrance_registered = null
				continue
		else
			if(I.item_flags & ITEM_ENCUMBERS_ONLY_HELD)
				I.encumbrance_registered = null
				continue
		var/encumbrance = I.get_encumbrance()
		tally_encumbrance += encumbrance
		I.encumbrance_registered = encumbrance
		flat_encumbrance = max(flat_encumbrance, I.get_flat_encumbrance())
	cached_carry_weight = tally_weight
	cached_carry_encumbrance = tally_encumbrance
	cached_carry_flat_encumbrance = flat_encumbrance
	if(update)
		update_carry()

/mob/living/proc/adjust_current_carry_weight(amount)
	if(!amount)
		return
	cached_carry_weight += amount
	update_carry()

/mob/living/proc/adjust_current_carry_encumbrance(amount)
	if(!amount)
		return
	cached_carry_encumbrance += amount
	update_carry()

/**
 * @return penalty as speed multiplier from 0 to 1
 */
/mob/living/proc/carry_weight_to_penalty(amount)
	return 1

/**
 * @return penalty as speed multiplier from 0 to 1
 */
/mob/living/proc/carry_encumbrance_to_penalty(amount)
	return 1

/mob/living/proc/update_carry()
	var/weight_penalty = carry_weight_to_penalty(cached_carry_weight)
	var/encumbrance_penalty = carry_encumbrance_to_penalty(cached_carry_encumbrance)
	var/flat_encumbrance_penalty = carry_encumbrance_to_penalty(cached_carry_flat_encumbrance)
	var/penalty = min(weight_penalty, encumbrance_penalty, flat_encumbrance_penalty)
	switch(round(min(weight_penalty, encumbrance_penalty) * 100))
		if(85 to 99)
			throw_alert("encumbered", /atom/movable/screen/alert/encumbered/minor)
		if(65 to 84)
			throw_alert("encumbered", /atom/movable/screen/alert/encumbered/moderate)
		if(36 to 64)
			throw_alert("encumbered", /atom/movable/screen/alert/encumbered/severe)
		if(0 to 35)
			throw_alert("encumbered", /atom/movable/screen/alert/encumbered/extreme)
		else
			clear_alert("encumbered")
	/// do not slow down below 10% of base
	penalty = max(penalty, 0.1)
	if(penalty)
		update_movespeed_modifier(
			/datum/movespeed_modifier/mob_inventory_carry,
			params = list(
				MOVESPEED_PARAM_MOD_MULTIPLY_SPEED = penalty,
			),
		)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/mob_inventory_carry)

//* Movespeed *//

/mob/living/update_item_slowdown()
	var/tally = get_item_slowdown()
	if(tally)
		update_movespeed_modifier(
			/datum/movespeed_modifier/mob_item_slowdown,
			params = list(
				MOVESPEED_PARAM_MOD_HYPERBOLIC_SLOWDOWN = tally,
			)
		)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/mob_item_slowdown)

/mob/living/proc/get_item_slowdown()
	. = 0
	for(var/obj/item/I as anything in get_equipped_items())
		. += I.slowdown
