SUBSYSTEM_DEF(input)
	name = "Input"
	wait = 1 //SS_TICKER means this runs every tick
	init_order = INIT_ORDER_INPUT
	flags = SS_TICKER
	priority = FIRE_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/macro_sets
	var/list/movement_keys
	var/list/valid_keys
	var/list/valid_custom_keys

	var/list/keybind_datums				//plain list of datums
	var/list/keybind_datums_by_type		//type = datum, where datums are instanciated
	var/list/keybind_categories			//category_name = list(typepath1, typepath2)

/datum/controller/subsystem/input/PreInit()
	. = ..()
	setup_keybind_datums()
	setup_valid_keys()

/datum/controller/subsystem/input/Initialize()
	setup_default_macro_sets()

	setup_default_movement_keys()

	initialized = TRUE

	refresh_client_macro_sets()

	return ..()

/datum/controller/subsystem/input/proc/keybind_datum_by_type(_type)
	return keybind_datums_by_type[_type]

/datum/controller/subsystem/input/proc/setup_keybind_datums()
	keybind_datums = all_keybind_datums()
	keybind_datums_by_type = list()
	for(var/i in keybind_datums)
		var/datum/keybind/K = i
		keybind_datums_by_type[K.type] = K

/datum/controller/subsystem/input/proc/setup_valid_keys()
	vaild_keys = default_valid_keyboard_keys()
	valid_ustom_keys = valid_keys.Copy() - list("Return", "F1", "F2", "Escape"))

// This is for when macro sets are eventualy datumized
/datum/controller/subsystem/input/proc/setup_default_macro_sets()
	var/list/static/default_macro_sets

	if(default_macro_sets)
		macro_sets = default_macro_sets
		return

	//Hardcoded keybinds.
	default_macro_sets = list(
		"default" = list(
			"Tab" = "\".winset \\\"input.focus=true?map.focus=true input.background-color=[COLOR_INPUT_DISABLED]:input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
			"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"", // This makes it so backspace can remove default inputs
			"Escape" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
			"Any" = "\"KeyDown \[\[*\]\]\"",
			"Any+UP" = "\"KeyUp \[\[*\]\]\"",
			),
		"old_default" = list(
			"Tab" = "\".winset \\\"mainwindow.macro=old_hotkeys map.focus=true input.background-color=[COLOR_INPUT_DISABLED]\\\"\"",
			"Escape" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
			),
		"old_hotkeys" = list(
			"Tab" = "\".winset \\\"mainwindow.macro=old_default input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
			"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"", // This makes it so backspace can remove default inputs
			"Any" = "\"KeyDown \[\[*\]\]\"",
			"Any+UP" = "\"KeyUp \[\[*\]\]\"",
			"Escape" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
			),
		)

	// Because i'm lazy and don't want to type all these out twice
	var/list/old_default = default_macro_sets["old_default"]

	var/list/static/oldmode_keys = list(
		"North", "East", "South", "West",
		"Northeast", "Southeast", "Northwest", "Southwest",
		"Insert", "Delete", "Ctrl", "Alt",
		"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
		)

	for(var/i in 1 to oldmode_keys.len)
		var/key = oldmode_keys[i]
		old_default[key] = "\"KeyDown [key]\""
		old_default["[key]+UP"] = "\"KeyUp [key]\""

	var/list/static/oldmode_ctrl_override_keys = list(
		"W" = "W", "A" = "A", "S" = "S", "D" = "D", // movement
		"1" = "1", "2" = "2", "3" = "3", "4" = "4", // intent
		"B" = "B", // resist
		"E" = "E", // quick equip
		"F" = "F", // intent left
		"G" = "G", // intent right
		"H" = "H", // stop pulling
		"Q" = "Q", // drop
		"R" = "R", // throw
		"X" = "X", // switch hands
		"Y" = "Y", // activate item
		"Z" = "Z", // activate item
		)

	for(var/i in 1 to oldmode_ctrl_override_keys.len)
		var/key = oldmode_ctrl_override_keys[i]
		var/override = oldmode_ctrl_override_keys[key]
		old_default["Ctrl+[key]"] = "\"KeyDown [override]\""
		old_default["Ctrl+[key]+UP"] = "\"KeyUp [override]\""

	macro_sets = default_macro_sets

// For initially setting up or resetting to default the movement keys
/datum/controller/subsystem/input/proc/setup_default_movement_keys()
	var/static/list/default_movement_keys = list(
		"W" = NORTH, "A" = WEST, "S" = SOUTH, "D" = EAST,				// WASD
		"North" = NORTH, "West" = WEST, "South" = SOUTH, "East" = EAST,	// Arrow keys & Numpad
		)

	movement_keys = default_movement_keys.Copy()

// Badmins just wanna have fun ♪
/datum/controller/subsystem/input/proc/refresh_client_macro_sets()
	//var/list/clients = GLOB.clients
	for(var/i in 1 to clients.len)
		var/client/user = clients[i]
		user.set_macros()

/datum/controller/subsystem/input/fire()
	set waitfor = FALSE
	//var/list/clients = GLOB.clients // Let's sing the list cache song
	for(var/i in 1 to clients.len)
		var/client/C = clients[i]
		C.keyLoop()

/datum/controller/subsystem/input/proc/default_valid_keyboard_keys()
	return make_list_assoc(list(
	"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
	"-", "=", "\[", "\]", "\\", ".", "/", "`", "Capslock",
	"Numpad0", "Numpad1", "Numpad2", "Numpad3", "Numpad4", "Numpad5", "Numpad6", "Numpad7", "Numpad8", "Numpad9",
	"North", "South", "East", "West", "Northwest", "Southwest", "Northeast", "Southeast",
	"Center", "Return", "Escape", "Tab", "Space", "Back", "Insert", "Delete", "Pause", "Snapshot",
	"LWin", "RWin", "Apps", "Multiply", "Add", "Subtract", "Divide", "Separator", "Decimal",
	"Shift", "Ctrl", "Numlock", "Scroll", "Alt"
	))
