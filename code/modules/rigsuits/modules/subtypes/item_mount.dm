//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Mounts an item for usage on click.
 * * Unlike item_deploy, this doesn't actually deploy to hand.
 */
/obj/item/rig_module/item_mount

/obj/item/rig_module/item_mount/is_active_rig_click_module()
	return TRUE

#warn impl all

/obj/item/rig_module/item_mount/proc/on_item_mounted(obj/item/entity)

/obj/item/rig_module/item_mount/proc/on_item_unmounted(obj/item/entity)

/obj/item/rig_module/item_mount/handle_rig_module_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/obj/item/use_item = get_active_item()
	if(!use_item)
		clickchain.chat_feedback(
			SPAN_WARNING("[src] doesn't have an active item selected."),
			target = src,
		)
		return clickchain_flags | CLICKCHAIN_DO_NOT_PROPAGATE
	if(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)
		return use_item.melee_interaction_chain(clickchain, clickchain_flags | CLICKCHAIN_REDIRECTED)
	return use_item.ranged_interaction_chain(clickchain, clickchain_flags | CLICKCHAIN_REDIRECTED)

/obj/item/rig_module/item_mount/proc/get_active_item() as /obj/item
	return null

/**
 * Mounts a single item.
 */
/obj/item/rig_module/item_mount/single
	tgui_interface = "ItemMountSingle"

	var/expected_item_type = /obj/item
	var/obj/item/mounted
	var/lazy_automount_path

	var/allow_attack_self = FALSE
	var/allow_click_melee = FALSE
	var/allow_click_ranged = FALSE

#warn the item needs to be mounted on the rig's resource bus

/**
 * Gets the thing mounted on us
 * * It's safe to cast the return value to `expected_item_type`.
 */
/obj/item/rig_module/item_mount/single/proc/get_single_mounted()
	#warn impl
