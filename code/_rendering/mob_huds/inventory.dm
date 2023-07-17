/datum/mob_hud/inventory

/atom/movable/screen/inventory
	name = "inventory"

	/// our owning inventory datum
	var/datum/inventory/host
	/// our slot ID or index
	var/target

/atom/movable/screen/inventory/Initialize(mapload, datum/inventory/host, target)
	. = ..()
	src.target = target
	src.host = host
	auto_name_and_position(target)

/atom/movable/screen/inventory/proc/auto_name_and_position(slot_or_index)


/**
 * handle an inventory operation
 *
 * @params
 * * user - clicking user; not necessarily the inventory's owner
 * * slot_or_index - slot ID or numerical hand index
 * * with_item - specifically attempting to swap an inventory object with an item, or interact with it with an item.
 */
/atom/movable/screen/inventory/proc/handle_inventory_click(mob/user, slot_or_index, obj/item/with_item)

#warn impl all

/atom/movable/screen/inventory/hand

/atom/movable/screen/inventory/hand/
