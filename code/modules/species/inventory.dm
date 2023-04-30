/**
 * get equip offsets for a given slot
 * return x/y offsets
 */
/datum/species/proc/get_inventory_offsets(slot)
	return list(0, 0)

/**
 * get equip offsets for a given inhand
 *
 * @params
 * - slot - /datum/inventory_slot_meta/abstract/hand/left or right_hand
 * - index - index of the held item in held items
 */
/datum/species/proc/get_inhand_offsets(slot, index)
	return list(0, 0)

/**
 * return effective bodytype for a slot
 *
 * @params
 * - slot - inventory slot id/typepath of meta
 * - I - item in question - optional. With this we can make a slightly more educated guess
 */
/datum/species/proc/get_effective_bodytype(slot, obj/item/I)
	return BODYTYPE_DEFAULT
