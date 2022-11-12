GLOBAL_DATUM_INIT(main_window_menu, /datum/skin_menu/main, new)

/datum/skin_menu/main
	id = SKIN_ID_MAIN_MENU
	bind_to = SKIN_WINDOW_ID_MAIN
	categories = list(
		/datum/skin_menu_category/main_file,
		/datum/skin_menu_category/main_zoom,
		/datum/skin_menu_category/main_scaling,
		/datum/skin_menu_category/main_help,
	)

/datum/skin_menu_category/main_file
	id = SKIN_ID_MENU_CATEGORY_FILE
	name = "File"
	entries = list(
		/datum/skin_menu_entry/quick_screenshot,
		/datum/skin_menu_entry/screenshot,
		/datum/skin_menu_entry/ping,
		/datum/skin_menu_entry/reconnect,
		/datum/skin_menu_entry/quit,
	)

/datum/skin_menu_category/main_zoom
	id = SKIN_ID_MENU_CATEGORY_ZOOM
	name = "Zoom"
	entries = list(
		/datum/skin_menu_entry/widescreen/automatic,
		/datum/skin_menu_entry/widescreen/legacy,
		null,
		/datum/skin_menu_entry/auto_fit,
		/datum/skin_menu_entry/fit_viewport,
		null,
		/datum/skin_menu_entry/zoom/stretch_to_fit,
		/datum/skin_menu_entry/zoom/stretch_to_fill,
	)

/datum/skin_menu_category/main_zoom/init_entries()
	. = ..()
	var/static/list/auto_sizes = list(
		32,
		48,
		64,
		72,
		96,
		128,
	)
	for(var/size in auto_sizes)
		entries += new /datum/skin_menu_entry/zoom/specific(src, size)

/datum/skin_menu_category/main_scaling
	id = SKIN_ID_MENU_CATEGORY_SCALING
	name = "Scaling"
	entries = list(
		/datum/skin_menu_entry/scaling/sharp,
		/datum/skin_menu_entry/scaling/normal,
		/datum/skin_menu_entry/scaling/blur,
	)

/datum/skin_menu_category/main_help
	id = SKIN_ID_MENU_CATEGORY_HELP
	name = "Help"
	entries = list(
		/datum/skin_menu_entry/adminhelp,
	)

//! file
/datum/skin_menu_entry/quick_screenshot
	id = SKIN_ID_MENU_BUTTON_SCREENSHOT_QUICK
	name = "Quick Screenshot"
	command = ".screenshot auto"

/datum/skin_menu_entry/screenshot
	id = SKIN_ID_MENU_BUTTON_SCREENSHOT
	name = "Screenshot..."
	command = ".screenshot"

/datum/skin_menu_entry/quit
	id = SKIN_ID_MENU_BUTTON_QUIT
	name = "Quit"
	command = ".quit"

/datum/skin_menu_entry/reconnect
	id = SKIN_ID_MENU_BUTTON_RECONNECT
	name = "Reconnect"
	command = ".reconnect"

/datum/skin_menu_entry/ping
	id = SKIN_ID_MENU_BUTTON_PING
	name = "Ping (legacy chat)"
	command = ".ping"

//! zoom
/datum/skin_menu_entry/zoom
	group = SKIN_BUTTON_GROUP_MAP_ZOOM
	load_command_default = TRUE
	checkbox = TRUE

/datum/skin_menu_entry/zoom/pressed(client/C, new_checked)
	. = ..()
	if(C.is_auto_fit_viewport_enabled())
		C.request_viewport_fit()
	C.request_viewport_update()

/datum/skin_menu_entry/zoom/load(client/C, enabled)
	. = ..()
	if(C.is_auto_fit_viewport_enabled())
		C.request_viewport_fit()
	C.request_viewport_update()

/datum/skin_menu_entry/zoom/stretch_to_fit
	name = "Stretch to Fit"
	id = SKIN_ID_MENU_BUTTON_STRETCH_TO_FIT
	is_default = TRUE

/datum/skin_menu_entry/zoom/stretch_to_fit/generate_command(loading)
	if(loading)
		return ".winset \"[SKIN_MAP_ID_VIEWPORT].zoom=0;[SKIN_MAP_ID_VIEWPORT].letterbox=true\""
	return ".winset \"[SKIN_MAP_ID_VIEWPORT].zoom=0;[SKIN_MAP_ID_VIEWPORT].letterbox=true\"\n.update_viewport"

/datum/skin_menu_entry/zoom/stretch_to_fill
	name = "Stretch to Fill"
	id = SKIN_ID_MENU_BUTTON_STRETCH_NO_LETTERBOX

/datum/skin_menu_entry/zoom/stretch_to_fill/generate_command(loading)
	if(loading)
		return ".winset \"[SKIN_MAP_ID_VIEWPORT].zoom=0;[SKIN_MAP_ID_VIEWPORT].letterbox=false\""
	return ".winset \"[SKIN_MAP_ID_VIEWPORT].zoom=0;[SKIN_MAP_ID_VIEWPORT].letterbox=false\"\n.update_viewport"

//? the normal sizes are created by main_zoom category
/datum/skin_menu_entry/zoom/specific
	/// our pixel size
	var/pixel_size

/datum/skin_menu_entry/zoom/specific/New(datum/skin_menu_category/category, pixel_size)
	src.pixel_size = pixel_size
	src.id = SKIN_ID_MENU_BUTTON_FOR_RESOLUTION(pixel_size)
	src.name = "[pixel_size]x[pixel_size]"
	..()

/datum/skin_menu_entry/zoom/specific/generate_command(loading)
	var/zoom = pixel_size / WORLD_ICON_SIZE
	if(loading)
		return ".winset \"[SKIN_MAP_ID_VIEWPORT].zoom=[zoom]\""
	return ".winset \"[SKIN_MAP_ID_VIEWPORT].zoom=[zoom]\"\n.update_viewport"

//! widescreen
/datum/skin_menu_entry/widescreen
	group = SKIN_BUTTON_GROUP_MAP_WIDESCREEN
	checkbox = TRUE

/datum/skin_menu_entry/widescreen/pressed(client/C, new_checked)
	. = ..()
	if(C.is_auto_fit_viewport_enabled())
		C.request_viewport_fit()
	C.request_viewport_update()

/datum/skin_menu_entry/widescreen/load(client/C, enabled)
	. = ..()
	if(C.is_auto_fit_viewport_enabled())
		C.request_viewport_fit()
	C.request_viewport_update()

/datum/skin_menu_entry/widescreen/automatic
	id = SKIN_ID_MENU_BUTTON_WIDESCREEN_ENABLED
	name = "Automatic Widescreen"
	is_default = TRUE

/datum/skin_menu_entry/widescreen/legacy
	id = SKIN_ID_MENU_BUTTON_WIDESCREEN_DISABLED
	name = "Lock to 15x15 (Legacy)"

/client/proc/is_widescreen_enabled()
	return menu_group_query(SKIN_BUTTON_GROUP_MAP_WIDESCREEN) == SKIN_ID_MENU_BUTTON_WIDESCREEN_ENABLED

//! misc zoom
/datum/skin_menu_entry/auto_fit
	id = SKIN_ID_MENU_BUTTON_AUTO_FIT_VIEWPORT
	name = "Automatically Fit Viewport (EXPERIMENTAL)"
	checkbox = TRUE
	is_default = FALSE

/datum/skin_menu_entry/auto_fit/load(client/C, enabled)
	. = ..()
	if(enabled)
		C.request_viewport_fit()

/client/proc/is_auto_fit_viewport_enabled()
	return menu_button_checked(SKIN_ID_MENU_BUTTON_AUTO_FIT_VIEWPORT)

/datum/skin_menu_entry/fit_viewport
	id = SKIN_ID_MENU_BUTTON_FIT_VIEWPORT
	name = "Fit Viewport"

/datum/skin_menu_entry/fit_viewport/pressed(client/C, new_checked)
	. = ..()
	C.request_viewport_fit()

//! scaling
/datum/skin_menu_entry/scaling
	group = SKIN_BUTTON_GROUP_MAP_SCALING
	checkbox = TRUE
	load_command_default = TRUE
	var/zoom_mode

/datum/skin_menu_entry/scaling/generate_command(loading)
	return ".winset \"[SKIN_MAP_ID_VIEWPORT].zoom-mode=[zoom_mode]\""

/datum/skin_menu_entry/scaling/sharp
	id = SKIN_ID_MENU_BUTTON_NEAREST_NEIGHBOR
	name = "Nearest Neighbor (Sharp)"
	zoom_mode = "distort"
	is_default = TRUE

/datum/skin_menu_entry/scaling/normal
	id = SKIN_ID_MENU_BUTTON_POINT_SAMPLE
	name = "Point Sampling (Normal)"
	zoom_mode = "normal"

/datum/skin_menu_entry/scaling/blur
	id = SKIN_ID_MENU_BUTTON_BILINEAR
	name = "Bilinear (Blurry)"
	zoom_mode = "blur"

//! help
/datum/skin_menu_entry/adminhelp
	id = SKIN_ID_MENU_BUTTON_ADMINHELP
	name = "Admin Help (F1)"
	command = "adminhelp"
