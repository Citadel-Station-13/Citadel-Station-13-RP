/datum/keybinding/movement
    category = CATEGORY_MOVEMENT
    weight = WEIGHT_HIGHEST

/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	name = "North"
	full_name = "Move North"
	description = "Moves your character north"
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	name = "South"
	full_name = "Move South"
	description = "Moves your character south"
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	name = "West"
	full_name = "Move West"
	description = "Moves your character left"
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	name = "East"
	full_name = "Move East"
	description = "Moves your character east"
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/multiz_up
	hotkey_keys = list()
	name = "multiz_move_up"
	full_name = "Move Up Zlevel"
	description = "Moves up one zlevel if possible"
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/multiz_up/down(client/user)
	user.mob.up()

/datum/keybinding/movement/multiz_down
	hotkey_keys = list()
	name = "multiz_move_down"
	full_name = "Move down Zlevel"
	description = "Moves down one zlevel if possible"
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/multiz_down/down(client/user)
	user.mob.down()

/datum/keybinding/movement/facenorth
	hotkey_keys = list("CtrlAltW", "CtrlAltNorth")
	name = "Permanently Face North"
	full_name = "Permanently Face North"
	description = "Force your character to face north until overridden."
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/facenorth/down(client/user)
	user.mob.northfaceperm()

/datum/keybinding/movement/facesouth
	hotkey_keys = list("CtrlAltS", "CtrlAltSouth")
	name = "Face South"
	full_name = "Permanently Face South"
	description = "Force your character to face south until overridden."
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/facesouth/down(client/user)
	user.mob.southfaceperm()

/datum/keybinding/movement/facewest
	hotkey_keys = list("CtrlAltA", "CtrlAltWest")
	name = "Face west"
	full_name = "Permanently Face West"
	description = "Force your character to face west until overridden."
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/facewest/down(client/user)
	user.mob.westfaceperm()

/datum/keybinding/movement/faceeast
	hotkey_keys = list("CtrlAltD", "CtrlAltEast")
	name = "Face east"
	full_name = "Permanently Face East"
	description = "Force your character to face east until overridden."
	category = CATEGORY_MOVEMENT

/datum/keybinding/movement/faceeast/down(client/user)
	user.mob.eastfaceperm()

/datum/keybinding/mob/shift_north
	hotkey_keys = list("CtrlShiftW", "CtrlShiftNorth")
	name = "pixel_shift_north"
	full_name = "Pixel Shift North"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/shift_north/down(client/user)
	var/mob/M = user.mob
	M.northshift()
	return TRUE

/datum/keybinding/mob/shift_east
	hotkey_keys = list("CtrlShiftD", "CtrlShiftEast")
	name = "pixel_shift_east"
	full_name = "Pixel Shift East"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/shift_east/down(client/user)
	var/mob/M = user.mob
	M.eastshift()
	return TRUE

/datum/keybinding/mob/shift_south
	hotkey_keys = list("CtrlShiftS", "CtrlShiftSouth")
	name = "pixel_shift_south"
	full_name = "Pixel Shift South"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/shift_south/down(client/user)
	var/mob/M = user.mob
	M.southshift()
	return TRUE

/datum/keybinding/mob/shift_west
	hotkey_keys = list("CtrlShiftA", "CtrlShiftWest")
	name = "pixel_shift_west"
	full_name = "Pixel Shift West"
	description = ""
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/shift_west/down(client/user)
	var/mob/M = user.mob
	M.westshift()
	return TRUE
