/datum/keybinding/movement
    category = CATEGORY_MOVEMENT
    weight = WEIGHT_HIGHEST

/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	name = "North"
	full_name = "Move North"
	description = "Moves your character north"

/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	name = "South"
	full_name = "Move South"
	description = "Moves your character south"

/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	name = "West"
	full_name = "Move West"
	description = "Moves your character left"

/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	name = "East"
	full_name = "Move East"
	description = "Moves your character east"

/datum/keybinding/movement/facenorth
	hotkey_keys = list("AltW", "AltNorth")
	name = "Permanently Face North"
	full_name = "Permanently Face North"
	description = "Force your character to face north until overridden."

/datum/keybinding/movement/facenorth/down(client/user)
	user.mob.northfaceperm()

/datum/keybinding/movement/facesouth
	hotkey_keys = list("AltS", "AltSouth")
	name = "Face South"
	full_name = "Permanently Face South"
	description = "Force your character to face south until overridden."

/datum/keybinding/movement/facesouth/down(client/user)
	user.mob.southfaceperm()

/datum/keybinding/movement/facewest
	hotkey_keys = list("AltA", "AltWest")
	name = "Face west"
	full_name = "Permanently Face West"
	description = "Force your character to face west until overridden."

/datum/keybinding/movement/facewest/down(client/user)
	user.mob.westfaceperm()

/datum/keybinding/movement/faceeast
	hotkey_keys = list("AltD", "AltEast")
	name = "Face east"
	full_name = "Permanently Face East"
	description = "Force your character to face east until overridden."

/datum/keybinding/movement/faceeast/down(client/user)
	user.mob.eastfaceperm()
