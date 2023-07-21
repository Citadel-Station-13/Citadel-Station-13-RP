/datum/mob_hud/hands
	/// owning inventory
	var/datum/inventory/host
	/// ordered hand objects
	var/list/atom/movable/screen/hand/instance/hands
	/// swap hand object
	var/atom/movable/screen/hand/swap_hand/swap_hand
	/// equip object
	var/atom/movable/screen/hand/equip_hand/equip_hand
	/// use hand on self object
	var/atom/movable/screen/hand/use_self_hand/use_self_hand


/atom/movable/screen/hand
	name = "inventory"
	icon = 'icons/screen/hud/midnight/inventory.dmi'

	/// our owning inventory datum
	var/datum/inventory/host

/atom/movable/screen/hand/Initialize(mapload, datum/inventory/host)
	. = ..()
	src.host = host

/atom/movable/screen/hand/sync_style(datum/hud_style/style)
	icon = hud.inventory_icons

/**
 * handle an inventory operation
 *
 * @params
 * * user - clicking user; not necessarily the inventory's owner
 * * slot_or_index - slot ID or numerical hand index
 * * with_item - specifically attempting to swap an inventory object with an item, or interact with it with an item.
 */
/atom/movable/screen/hand/proc/handle_inventory_click(mob/user, slot_or_index, obj/item/with_item)

#warn impl all

/atom/movable/screen/hand/instance
	/// target hand index
	var/hand_index

/atom/movable/screen/hand/instance/Initialize(mapload, datum/inventory/host, hand_index)
	. = ..()
	src.hand_index = hand_index
	synx_index(hand_index)

/atom/movable/screen/hand/instance/proc/sync_index(index = hand_index)
	screen_loc = SCREEN_LOC_INV_HAND(index)
	var/index_of_side = round(index / 2)
	name = "[index % 2? "left" : "right"] hand[index > 1? " #[index]" : ""]"
	icon_state = "hand-[index % 2? "left" : "right"]"

/atom/movable/screen/hand/swap_hand

/atom/movable/screen/hand/swap_hand/sync_style(datum/hud_style/style)
	icon = hud.inventory_icons_wide

/atom/movable/screen/hand/equip_hand

/atom/movable/screen/hand/use_self_hand
