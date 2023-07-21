/datum/mob_hud/inventory
	/// owning inventory
	var/datum/inventory/host
	/// ordered hand objects
	var/list/atom/movable/screen/inventory/hand/hands
	/// swap hand object
	var/atom/movable/screen/inventory/swap_hand/swap_hand
	/// equip object
	var/atom/movable/screen/inventory/equip_hand/equip_hand
	/// use hand on self object
	var/atom/movable/screen/inventory/use_self_hand/use_self_hand

/datum/mob_hud/inventory/proc/add_item(obj/item/item, datum/inventory_slot_meta/slot_or_index)

/datum/mob_hud/inventory/proc/remove_item(obj/item/item, datum/inventory_slot_meta/slot_or_index)

#warn impl all

/atom/movable/screen/inventory
	name = "inventory"
	icon = 'icons/screen/hud/midnight/inventory.dmi'

	/// our owning mob hud
	var/datum/mob_hud/inventory/hud

/atom/movable/screen/inventory/Initialize(mapload, datum/mob_hud/inventory/hud)
	. = ..()
	src.hud = hud
	sync_style(hud.style)

/atom/movable/screen/inventory/sync_style(datum/hud_style/style, style_alpha, style_color)
	icon = style.inventory_icons
	alpha = style_alpha
	color = style_color

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
	/// target hand index
	var/hand_index

/atom/movable/screen/inventory/hand/Initialize(mapload, datum/inventory/host, hand_index)
	. = ..()
	src.hand_index = hand_index
	sync_index(hand_index)

/atom/movable/screen/inventory/hand/proc/sync_index(index = hand_index)
	screen_loc = SCREEN_LOC_INV_HAND(index)
	var/index_of_side = round(index / 2)
	name = "[index % 2? "left" : "right"] hand[index > 1? " #[index]" : ""]"
	icon_state = "hand-[index % 2? "left" : "right"]"

/atom/movable/screen/inventory/swap_hand

/atom/movable/screen/inventory/swap_hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	icon = style.inventory_icons_wide
	alpha = style_alpha
	color = style_color

/atom/movable/screen/inventory/equip_hand

/atom/movable/screen/inventory/use_self_hand
