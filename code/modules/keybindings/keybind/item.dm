//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/keybinding/item
	weight = WEIGHT_ITEM
	category = CATEGORY_ITEM

/datum/keybinding/item/can_use(client/user)
	return TRUE

/datum/keybinding/item/activate_inhand
	hotkey_keys = list("Z", "Southeast") // PAGEDOWN
	name = "activate_inhand"
	full_name = "Activate in-hand"
	description = "Uses whatever item you have inhand; this is usually the item's primary action."

/datum/keybinding/item/activate_inhand/down(client/user)
	user.mob.keybind_activate_inhand()
	return TRUE

/datum/keybinding/item/unique_action
	name = "unique_action"
	full_name = "Unique Action"
	description = "Uses whatever item you have inhand; this is usually the item's secondary action."
	hotkey_keys = list("Space")

/datum/keybinding/item/unique_action/down(client/user)
	user.mob.keybind_unique_inhand()
	return TRUE

/datum/keybinding/item/defensive_toggle
	name = "item-defensive-toggle"
	full_name = "Defensive Toggle"
	description = "Usually uses whatever item you have inhand; this is usually the item's toggled defensive action."
	hotkey_keys = list("F")

/datum/keybinding/item/defensive_toggle/down(client/user)
	user.mob.keybind_defensive_toggle()
	return TRUE

/datum/keybinding/item/defensive_trigger
	name = "item-defensive-trigger"
	full_name = "Defensive Trigger"
	description = "Usually uses whatever item you have inhand; this is usually the item's triggered defensive action."
	hotkey_keys = list("G")

/datum/keybinding/item/defensive_trigger/down(client/user)
	user.mob.keybind_defensive_trigger()
	return TRUE

/datum/keybinding/item/toggle_gun_safety
	hotkey_keys = list()
	name = "toggle_gun_safety"
	full_name = "Toggle Gun Safety"
	description = "Toggle the safety of a gun in your hand"

/datum/keybinding/human/toggle_gun_safety/down(client/user)
	var/obj/item/gun/G = locate() in user.mob.get_held_items()
	if(G)
		G.toggle_safety(user)
