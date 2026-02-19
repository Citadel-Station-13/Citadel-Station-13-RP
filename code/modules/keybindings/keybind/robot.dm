/datum/keybinding/robot
	category = CATEGORY_ROBOT
	weight = WEIGHT_ROBOT

/datum/keybinding/robot/can_use(client/user)
	return isrobot(user.mob)

/datum/keybinding/robot/moduleone
	hotkey_keys = list("1")
	name = "module_one"
	full_name = "Toggle module 1"
	description = "Equips or unequips the first module"

/datum/keybinding/robot/moduleone/down(client/user)
	user.mob?.swap_hand(user.mob.active_hand == 1 ? null : 1, TRUE)
	return TRUE

/datum/keybinding/robot/moduletwo
	hotkey_keys = list("2")
	name = "module_two"
	full_name = "Toggle module 2"
	description = "Equips or unequips the second module"

/datum/keybinding/robot/moduletwo/down(client/user)
	user.mob?.swap_hand(user.mob.active_hand == 2 ? null : 2, TRUE)
	return TRUE

/datum/keybinding/robot/modulethree
	hotkey_keys = list("3")
	name = "module_three"
	full_name = "Toggle module 3"
	description = "Equips or unequips the third module"

/datum/keybinding/robot/modulethree/down(client/user)
	user.mob?.swap_hand(user.mob.active_hand == 3 ? null : 3, TRUE)
	return TRUE

/datum/keybinding/robot/intent_cycle
	hotkey_keys = list("4")
	name = "cycle_intent"
	full_name = "Cycle intent left"
	description = "Cycles the intent left"

/datum/keybinding/robot/intent_cycle/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.a_intent_change(INTENT_HOTKEY_LEFT)
	return TRUE

/datum/keybinding/robot/unequip_module
	hotkey_keys = list("Q")
	name = "unequip_module"
	full_name = "Unequip module"
	description = "Unequips the active module"

/datum/keybinding/robot/unequip_module/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.drop_active_held_item()
	return TRUE
