/datum/keybinding/item
	weight = WEIGHT_ITEM
	category = CATEGORY_ITEM

/datum/keybinding/item/can_use(client/user)
	return TRUE

/datum/keybinding/item/unique_action
	name = "unique_action"
	full_name = "Unique Action"
	description = "Triggers an unique action, based on whichever item you're holding."
	hotkey_keys = list("C")

/datum/keybinding/item/toggle_gun_safety
	hotkey_keys = list()
	name = "toggle_gun_safety"
	full_name = "Toggle Gun Safety"
	description = "Toggle the safety of a gun in your hand"

/datum/keybinding/human/toggle_gun_safety/down(client/user)
	var/obj/item/gun/G = locate() in user.mob.get_all_held_items()
	if(G)
		G.toggle_safety(user)
