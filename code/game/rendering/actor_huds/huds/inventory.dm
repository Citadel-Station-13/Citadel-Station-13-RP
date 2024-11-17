//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Inventory slots specifically, not hands.
 */
/datum/actor_hud/inventory
	/// owning inventory
	var/datum/inventory/host

	/// hidden classes, associated to list of reasons
	var/list/hidden_classes = list(
		(INVENTORY_HUD_CLASS_DRAWER) = list(
			INVENTORY_HUD_HIDE_SOURCE_DRAWER,
		),
	)

	/// keyed slot id to screen object
	var/list/atom/movable/screen/actor_hud/inventory/plate/slot/slots
	/// ordered hand objects
	var/list/atom/movable/screen/actor_hud/inventory/plate/hand/hands

	/// drawer object
	var/atom/movable/screen/actor_hud/inventory/drawer/button_drawer
	/// swap hand object
	var/atom/movable/screen/actor_hud/inventory/swap_hand/button_swap_hand
	/// equip object
	var/atom/movable/screen/actor_hud/inventory/equip_hand/button_equip_hand

/datum/actor_hud/inventory/Destroy()
	host = null
	cleanup()
	return ..()

/datum/actor_hud/inventory/on_mob_bound(mob/target)
	// we don't have a hook for 'on inventory init',
	// so we can't init it lazily; we init it immediately.
	target.init_inventory()
	if(target.inventory)
		bind_to_inventory(target.inventory)
	return ..()

/datum/actor_hud/inventory/on_mob_unbound(mob/target)
	if(target.inventory)
		unbind_from_inventory(target.inventory)
	return ..()

/datum/actor_hud/inventory/proc/bind_to_inventory(datum/inventory/inventory)
	ASSERT(!host)
	host = inventory
	LAZYADD(inventory.huds_using, src)
	rebuild(inventory.build_inventory_slots_with_remappings(), length(inventory.held_items))
	for(var/i in 1 to length(inventory.held_items))
		if(!inventory.held_items[i])
			continue
		add_item(inventory.held_items[i], i)
	for(var/slot_id in inventory.owner.get_inventory_slot_ids())
		var/obj/item/item_in_slot = inventory.owner.item_by_slot_id(slot_id)
		if(!item_in_slot)
			continue
		add_item(item_in_slot, resolve_inventory_slot(slot_id))
	var/atom/movable/screen/actor_hud/inventory/plate/hand/active_hand_plate = hands[inventory.owner.active_hand]
	active_hand_plate.add_overlay("[active_hand_plate.icon_state]-active")

/datum/actor_hud/inventory/proc/unbind_from_inventory(datum/inventory/inventory)
	for(var/i in 1 to length(inventory.held_items))
		if(!inventory.held_items[i])
			continue
		remove_item(inventory.held_items[i], i)
	for(var/slot_id in inventory.owner.get_inventory_slot_ids())
		var/obj/item/item_in_slot = inventory.owner.item_by_slot_id(slot_id)
		if(!item_in_slot)
			continue
		remove_item(item_in_slot, resolve_inventory_slot(slot_id))
	cleanup()
	LAZYREMOVE(inventory.huds_using, src)
	host = null

/datum/actor_hud/inventory/screens()
	. = ..()
	// slots
	. += all_slot_screen_objects(hidden_classes, TRUE)
	// hands
	. += all_hand_screen_objects()
	// buttons
	. += all_button_screen_objects()

/**
 * destroy everything
 */
/datum/actor_hud/inventory/proc/cleanup()
	// slots
	var/list/atom/movable/screen/actor_hud/inventory/plate/slot/slot_objects = all_slot_screen_objects()
	remove_screen(slot_objects)
	QDEL_LIST(slot_objects)
	slots = null

	// hands
	var/list/atom/movable/screen/actor_hud/inventory/plate/hand/hand_objects = all_hand_screen_objects()
	remove_screen(hand_objects)
	QDEL_LIST(hand_objects)
	hands = null

	// buttons
	var/list/atom/movable/screen/actor_hud/inventory/button_objects = all_button_screen_objects()
	remove_screen(button_objects)
	QDEL_NULL(button_objects)

/**
 * Accepts a list with keys as slot IDs, and values as null or a list of
 * INVENTORY_SLOT_REMAP_*'s.
 */
/datum/actor_hud/inventory/proc/rebuild(list/inventory_slots_with_mappings = host.build_inventory_slots_with_remappings(), number_of_hands = host.get_hand_count())
	cleanup()

	// buttons
	add_screen((button_swap_hand = new(null, src, number_of_hands)))
	add_screen((button_equip_hand = new(null, src, number_of_hands)))
	add_screen((button_drawer = new(null, src)))

	// slots
	rebuild_slots(inventory_slots_with_mappings)

	// hands
	rebuild_hands(number_of_hands)

/**
 * Rebuilds our slots. Doesn't rebuild anything else. Doesn't wipe old objects.
 */
/datum/actor_hud/inventory/proc/rebuild_slots(list/inventory_slots_with_mappings)
	QDEL_LIST_ASSOC_VAL(slots)
	LAZYINITLIST(slots)
	for(var/slot_id in inventory_slots_with_mappings)
		var/datum/inventory_slot/slot = resolve_inventory_slot(slot_id)
		if(!slot)
			stack_trace("failed to fetch slot during hud rebuild: [slot_id]")
			continue
		var/atom/movable/screen/actor_hud/inventory/plate/slot/slot_object = new /atom/movable/screen/actor_hud/inventory/plate/slot(null, src, slot, inventory_slots_with_mappings[slot_id] || list())
		if(!hidden_classes[slot_object.inventory_hud_class])
			add_screen(slot_object)
		slots[slot_id] = slot_object

	// here is where we basically pull a CSS flexbox.

	var/list/atom/movable/screen/actor_hud/inventory/plate/slot/place_anywhere = list()

	var/list/cross_axis_for_drawer = list()
	var/list/cross_axis_for_hands_left = list()
	var/list/cross_axis_for_hands_right = list()

	for(var/id in slots)
		var/atom/movable/screen/actor_hud/inventory/plate/slot/slot_object = slots[id]
		var/list/inject_into

		switch(slot_object.inventory_hud_anchor)
			if(INVENTORY_HUD_ANCHOR_AUTOMATIC)
				place_anywhere += slot_object
			if(INVENTORY_HUD_ANCHOR_TO_DRAWER)
				var/requested_cross_axis = clamp(slot_object.inventory_hud_cross_axis, 0, 4) + 1 // 1 to 5
				if(length(cross_axis_for_drawer) < requested_cross_axis)
					for(var/i in length(cross_axis_for_drawer) + 1 to requested_cross_axis)
						cross_axis_for_drawer[++cross_axis_for_drawer.len] = list()
				inject_into = cross_axis_for_drawer[requested_cross_axis]
			if(INVENTORY_HUD_ANCHOR_TO_HANDS)
				var/list/relevant_cross_axis = slot_object.inventory_hud_main_axis > 0 ? cross_axis_for_hands_right : cross_axis_for_hands_left
				var/requested_cross_axis = clamp(slot_object.inventory_hud_cross_axis, 0, 4) + 1 // 1 to 5
				if(length(relevant_cross_axis) < requested_cross_axis)
					for(var/i in length(relevant_cross_axis) + 1 to requested_cross_axis)
						relevant_cross_axis[++relevant_cross_axis.len] = list()
				inject_into = relevant_cross_axis[requested_cross_axis]

		BINARY_INSERT(slot_object, inject_into, /atom/movable/screen/actor_hud/inventory/plate/slot, slot_object, inventory_hud_main_axis, COMPARE_KEY)

	if(length(place_anywhere))
		var/list/cram_into_bottom_of_drawer = list()
		for(var/atom/movable/screen/actor_hud/inventory/plate/slot/slot_object as anything in place_anywhere)
			// intelligent detection; cluster based on class
			switch(slot_object.inventory_hud_class)
				if(INVENTORY_HUD_CLASS_ALWAYS)
					cram_into_bottom_of_drawer += slot_object
				if(INVENTORY_HUD_CLASS_DRAWER)
					cram_into_bottom_of_drawer += slot_object
		pack_2d_flat_list(cross_axis_for_drawer, cram_into_bottom_of_drawer, FALSE)

	var/list/atom/movable/screen/actor_hud/inventory/plate/slot/aligned = list()

	for(var/cross_axis in 1 to length(cross_axis_for_drawer))
		var/list/cross_axis_list = cross_axis_for_drawer[cross_axis]
		var/main_axis_bias = cross_axis == 1 ? 1 : 0
		for(var/main_axis in 1 to length(cross_axis_list))
			var/atom/movable/screen/actor_hud/inventory/plate/slot/aligning = cross_axis_list[main_axis]
			aligning.inventory_hud_cross_axis = cross_axis - 1
			aligning.inventory_hud_main_axis = main_axis - 1 + main_axis_bias
			aligned += aligning
	for(var/cross_axis in 1 to length(cross_axis_for_hands_left))
		var/list/cross_axis_list = cross_axis_for_hands_left[cross_axis]
		var/add_for_inverse = -(length(cross_axis_list) + 1)
		for(var/main_axis in 1 to length(cross_axis_list))
			var/atom/movable/screen/actor_hud/inventory/plate/slot/aligning = cross_axis_list[main_axis]
			aligning.inventory_hud_cross_axis = cross_axis - 1
			aligning.inventory_hud_main_axis = add_for_inverse + main_axis
			aligned += aligning
	for(var/cross_axis in 1 to length(cross_axis_for_hands_right))
		var/list/cross_axis_list = cross_axis_for_hands_right[cross_axis]
		for(var/main_axis in 1 to length(cross_axis_list))
			var/atom/movable/screen/actor_hud/inventory/plate/slot/aligning = cross_axis_list[main_axis]
			aligning.inventory_hud_cross_axis = cross_axis - 1
			aligning.inventory_hud_main_axis = main_axis
			aligned += aligning

	for(var/atom/movable/screen/actor_hud/inventory/plate/slot/slot_object as anything in aligned)
		switch(slot_object.inventory_hud_anchor)
			if(INVENTORY_HUD_ANCHOR_TO_DRAWER)
				slot_object.screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_SLOT_DRAWER_ALIGNED(slot_object.inventory_hud_main_axis, slot_object.inventory_hud_cross_axis)
			if(INVENTORY_HUD_ANCHOR_TO_HANDS)
				slot_object.screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_SLOT_HANDS_ALIGNED(slot_object.inventory_hud_main_axis, slot_object.inventory_hud_cross_axis)

/**
 * Rebuilds our hands. Doesn't rebuild anything else. Doesn't wipe old objects.
 */
/datum/actor_hud/inventory/proc/rebuild_hands(number_of_hands)
	LAZYINITLIST(hands)
	if(length(hands) < number_of_hands)
		var/old_length = length(hands)
		hands.len = number_of_hands
		for(var/i in old_length + 1 to number_of_hands)
			var/atom/movable/screen/actor_hud/inventory/plate/hand/hand_object = new(null, src, i)
			add_screen(hand_object)
			hands[i] = hand_object
	else if(length(hands) > number_of_hands)
		for(var/i in number_of_hands + 1 to length(hands))
			if(!hands[i])
				continue
			remove_screen(hands[i])
			qdel(hands[i])
		hands.len = number_of_hands

	button_equip_hand?.screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_EQUIP_HAND(number_of_hands)
	button_swap_hand?.screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_HAND_SWAP(number_of_hands)

/**
 * @params
 * * filter_by_class - a singular, or a list, of inventory hud classes to filter by
 * * inverse - get everything that isn't in the filter, instead of everything that is
 */
/datum/actor_hud/inventory/proc/all_slot_screen_objects(filter_by_class, inverse = FALSE)
	RETURN_TYPE(/list)
	. = list()
	if(filter_by_class)
		inverse = !!inverse
		if(islist(filter_by_class))
			for(var/id in slots)
				var/atom/movable/screen/actor_hud/inventory/plate/slot/slot_object = slots[id]
				if((slot_object.inventory_hud_class in filter_by_class) != inverse)
					. += slot_object
		else
			for(var/id in slots)
				var/atom/movable/screen/actor_hud/inventory/plate/slot/slot_object = slots[id]
				if((slot_object.inventory_hud_class == filter_by_class) != inverse)
					. += slot_object
	else
		for(var/id in slots)
			. += slots[id]

/datum/actor_hud/inventory/proc/all_hand_screen_objects()
	RETURN_TYPE(/list)
	. = list()
	for(var/atom/movable/object in hands)
		. += object

/datum/actor_hud/inventory/proc/all_button_screen_objects()
	RETURN_TYPE(/list)
	. = list()
	if(button_swap_hand)
		. += button_swap_hand
	if(button_equip_hand)
		. += button_equip_hand
	if(button_drawer)
		. += button_drawer

/datum/actor_hud/inventory/proc/toggle_hidden_class(class, source)
	var/list/atom/movable/screen/actor_hud/inventory/affected
	var/something_changed
	if(class in hidden_classes)
		LAZYREMOVE(hidden_classes[class], source)
		if(!length(hidden_classes[class]))
			affected = all_slot_screen_objects(class)
			add_screen(affected)
			hidden_classes -= class
			something_changed = TRUE
	else
		if(!hidden_classes[class])
			affected = all_slot_screen_objects(class)
			remove_screen(affected)
			something_changed = TRUE
		LAZYADD(hidden_classes[class], class)
	if(something_changed)
		switch(class)
			if(INVENTORY_HUD_CLASS_DRAWER)
				button_drawer?.update_icon()

/datum/actor_hud/inventory/proc/add_hidden_class(class, source)
	if(class in hidden_classes)
		return
	toggle_hidden_class(class, source)

/datum/actor_hud/inventory/proc/remove_hidden_class(class, source)
	if(!(class in hidden_classes))
		return
	toggle_hidden_class(class, source)

//* Hooks *//

/datum/actor_hud/inventory/proc/add_item(obj/item/item, datum/inventory_slot/slot_or_index)
	var/atom/movable/screen/actor_hud/inventory/plate/screen_obj = isnum(slot_or_index) ? hands[slot_or_index] : slots[slot_or_index.id]
	screen_obj.bind_item(item)

/datum/actor_hud/inventory/proc/remove_item(obj/item/item, datum/inventory_slot/slot_or_index)
	var/atom/movable/screen/actor_hud/inventory/plate/screen_obj = isnum(slot_or_index) ? hands[slot_or_index] : slots[slot_or_index.id]
	screen_obj.unbind_item(item)

/datum/actor_hud/inventory/proc/move_item(obj/item/item, datum/inventory_slot/from_slot_or_index, datum/inventory_slot/to_slot_or_index)
	var/atom/movable/screen/actor_hud/inventory/plate/old_screen_obj = isnum(from_slot_or_index) ? hands[from_slot_or_index] : slots[from_slot_or_index.id]
	var/atom/movable/screen/actor_hud/inventory/plate/new_screen_obj = isnum(to_slot_or_index) ? hands[to_slot_or_index] : slots[to_slot_or_index.id]
	old_screen_obj.unbind_item(item)
	new_screen_obj.bind_item(item)

/datum/actor_hud/inventory/proc/swap_active_hand(from_index, to_index)
	var/atom/movable/screen/actor_hud/inventory/plate/hand/old_hand = hands[from_index]
	var/atom/movable/screen/actor_hud/inventory/plate/hand/new_hand = hands[to_index]

	old_hand.cut_overlay("[old_hand.icon_state]-active")
	new_hand.add_overlay("[new_hand.icon_state]-active")

//* Inventory Screen Objects *//

/**
 * Base type of inventory screen objects.
 */
/atom/movable/screen/actor_hud/inventory
	name = "inventory"
	icon = 'icons/screen/hud/midnight/inventory.dmi'

/atom/movable/screen/actor_hud/inventory/on_click(mob/user, list/params)
	var/obj/item/held = user.get_active_held_item()
	handle_inventory_click(user, held)

/atom/movable/screen/actor_hud/inventory/sync_to_preferences(datum/hud_preferences/preference_set)
	sync_style(preference_set.hud_style, preference_set.hud_alpha, preference_set.hud_color)

/atom/movable/screen/actor_hud/inventory/proc/sync_style(datum/hud_style/style, style_alpha, style_color)
	alpha = style_alpha
	color = style_color

/**
 * handle an inventory operation
 *
 * @params
 * * user - clicking user; not necessarily the inventory's owner
 * * with_item - specifically attempting to swap an inventory object with an item, or interact with it with an item.
 */
/atom/movable/screen/actor_hud/inventory/proc/handle_inventory_click(mob/user, obj/item/with_item)
	return

/**
 * Base type of item-holding screen objects
 */
/atom/movable/screen/actor_hud/inventory/plate

/atom/movable/screen/actor_hud/inventory/plate/Destroy()
	if(length(vis_contents) != 0)
		vis_contents.len = 0
	return ..()

/atom/movable/screen/actor_hud/inventory/plate/proc/bind_item(obj/item/item)
	vis_contents += item

/atom/movable/screen/actor_hud/inventory/plate/proc/unbind_item(obj/item/item)
	vis_contents -= item

/**
 * Slot screen objects
 *
 * * Stores remappings so we don't have to do it separately
 * * Stores calculated screen_loc so we don't have to recalculate unless slots are mutated.
 */
/atom/movable/screen/actor_hud/inventory/plate/slot
	/// our inventory slot id
	var/inventory_slot_id
	/// our (potentially remapped) class
	var/inventory_hud_class = INVENTORY_HUD_CLASS_ALWAYS
	/// our (potentially remapped) main axis
	var/inventory_hud_main_axis = 0
	/// our (potentially remapped) cross axis
	var/inventory_hud_cross_axis = 0
	/// our (potentially remapped) anchor
	var/inventory_hud_anchor = INVENTORY_HUD_ANCHOR_AUTOMATIC

/atom/movable/screen/actor_hud/inventory/plate/slot/Initialize(mapload, datum/actor_hud/inventory/hud, datum/inventory_slot/slot, list/slot_remappings)
	. = ..()
	inventory_slot_id = slot.id
	icon_state = slot.inventory_hud_icon_state
	inventory_hud_class = slot_remappings[INVENTORY_SLOT_REMAP_CLASS] || slot.inventory_hud_class
	inventory_hud_main_axis = slot_remappings[INVENTORY_SLOT_REMAP_MAIN_AXIS] || slot.inventory_hud_main_axis
	inventory_hud_cross_axis = slot_remappings[INVENTORY_SLOT_REMAP_CROSS_AXIS] || slot.inventory_hud_cross_axis
	inventory_hud_anchor = slot_remappings[INVENTORY_SLOT_REMAP_ANCHOR] || slot.inventory_hud_anchor
	name = slot_remappings[INVENTORY_SLOT_REMAP_NAME] || slot.display_name || slot.name

/atom/movable/screen/actor_hud/inventory/plate/slot/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons_slot

/atom/movable/screen/actor_hud/inventory/plate/slot/handle_inventory_click(mob/user, obj/item/with_item)
	var/obj/item/in_slot = user.item_by_slot_id(inventory_slot_id)
	if(with_item)
		if(in_slot)
			with_item.melee_interaction_chain(in_slot, user, NONE, list())
		else
			user.equip_to_slot_if_possible(with_item, inventory_slot_id, NONE, user)
	else
		in_slot?.attack_hand(user, new /datum/event_args/actor/clickchain(user))

/**
 * Hand screen objects
 */
/atom/movable/screen/actor_hud/inventory/plate/hand
	/// target hand index
	var/hand_index
	/// should we have handcuffed overlay?
	var/handcuffed = FALSE

/atom/movable/screen/actor_hud/inventory/plate/hand/Initialize(mapload, datum/inventory/host, hand_index)
	. = ..()
	src.hand_index = hand_index
	sync_index(hand_index)

/atom/movable/screen/actor_hud/inventory/plate/hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons

/atom/movable/screen/actor_hud/inventory/plate/hand/handle_inventory_click(mob/user, obj/item/with_item)
	hud.owner.swap_hand(hand_index)

/atom/movable/screen/actor_hud/inventory/plate/hand/proc/sync_index(index = hand_index)
	screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_HAND(index)
	name = "[index % 2? "left" : "right"] hand[index > 2? " #[index]" : ""]"
	icon_state = "hand-[index % 2? "left" : "right"]"

/atom/movable/screen/actor_hud/inventory/plate/hand/proc/set_handcuffed(state)
	if(state == handcuffed)
		return
	handcuffed = state
	update_icon()

/atom/movable/screen/actor_hud/inventory/plate/hand/update_overlays()
	. = ..()
	if(handcuffed)
		. += image('icons/mob/screen_gen.dmi', "[hand_index % 2 ? "r_hand" : "l_hand"]_hud_handcuffs")

/**
 * Button: 'swap hand'
 */
/atom/movable/screen/actor_hud/inventory/drawer
	name = "drawer"
	icon_state = "drawer"
	screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_DRAWER

/atom/movable/screen/actor_hud/inventory/drawer/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons

/atom/movable/screen/actor_hud/inventory/drawer/on_click(mob/user, list/params)
	// todo: remote control
	hud.toggle_hidden_class(INVENTORY_HUD_CLASS_DRAWER, INVENTORY_HUD_HIDE_SOURCE_DRAWER)

/atom/movable/screen/actor_hud/inventory/drawer/update_icon_state()
	icon_state = "[(INVENTORY_HUD_CLASS_DRAWER in hud.hidden_classes) ? "drawer" : "drawer-active"]"
	return ..()

/**
 * Button: 'swap hand'
 */
/atom/movable/screen/actor_hud/inventory/swap_hand
	name = "swap active hand"
	icon_state = "hand-swap"
/atom/movable/screen/actor_hud/inventory/swap_hand/Initialize(mapload, datum/inventory/host, hand_count)
	. = ..()
	screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_HAND_SWAP(hand_count)

/atom/movable/screen/actor_hud/inventory/swap_hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons_wide

/atom/movable/screen/actor_hud/inventory/swap_hand/on_click(mob/user, list/params)
	// todo: remote control
	user.swap_hand()

/**
 * Button: 'auto equip'
 */
/atom/movable/screen/actor_hud/inventory/equip_hand
	name = "equip held item"
	icon_state = "button-equip"

/atom/movable/screen/actor_hud/inventory/equip_hand/Initialize(mapload, datum/inventory/host, hand_count)
	. = ..()
	screen_loc = SCREEN_LOC_MOB_HUD_INVENTORY_EQUIP_HAND(hand_count)

/atom/movable/screen/actor_hud/inventory/equip_hand/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.inventory_icons

/atom/movable/screen/actor_hud/inventory/equip_hand/on_click(mob/user, list/params)
	// todo: remote control
	user.attempt_smart_equip(user.get_active_held_item())
