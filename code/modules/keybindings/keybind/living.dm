/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/living/can_use(client/user)
	return isliving(user.mob)

/datum/keybinding/living/resist
	hotkey_keys = list("B")
	name = "resist"
	full_name = "Resist"
	description = "Break free of your current state. Handcuffed? on fire? Resist!"

/datum/keybinding/living/resist/down(client/user)
	var/mob/living/L = user.mob
	L.resist()
	return TRUE

/datum/keybinding/living/rest
	hotkey_keys = list("V")
	name = "rest"
	full_name = "Rest"
	description = "Toggle between lying down or standing up."

/datum/keybinding/living/rest/down(client/user)
	var/mob/living/L = user.mob
	L.toggle_intentionally_resting()
	return TRUE
