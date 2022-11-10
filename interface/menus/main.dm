GLOBAL_DATUM_INIT(main_window_menu, /datum/skin_menu/main, new)

/datum/skin_menu/main

/datum/skin_menu_category/main_file

/datum/skin_menu_category/main_zoom

/datum/skin_menu_category/main_scaling

/datum/skin_menu_category/main_help

//! file
/datum/skin_menu_entry/quick_screenshot

/datum/skin_menu_entry/screenshot

/datum/skin_menu_entry/quit

/datum/skin_menu_entry/reconnect

/datum/skin_menu_entry/ping

//! zoom
/datum/skin_menu_entry/zoom
	group = SKIN_BUTTON_GROUP_MAP_ZOOM

/datum/skin_menu_entry/zoom/stretch_to_fit

/datum/skin_menu_entry/zoom/stretch_to_fill

//? the normal sizes are created by main_zoom category
/datum/skin_menu_entry/zoom/specific
	/// our pixel size
	var/pixel_size

/datum/skin_menu_entry/zoom/specific/New(datum/skin_menu_category/category, pixel_size)
	src.pixel_size = pixel_size
	..()

/datum/skin_menu_entry/zoom/specific/creation_parameters()

//! widescreen
/datum/skin_menu_entry/widescreen
	group = SKIN_BUTTON_GROUP_MAP_WIDESCREEN

/datum/skin_menu_entry/widescreen/automatic

/datum/skin_menu_entry/widescreen/legacy

//! misc zoom
/datum/skin_menu_entry/auto_fit

//! scaling
/datum/skin_menu_entry/scaling
	group = SKIN_BUTTON_GROUP_MAP_SCALING

/datum/skin_menu_entry/scaling/sharp

/datum/skin_menu_entry/scaling/normal

/datum/skin_menu_entry/scaling/blur

//! help
/datum/skin_menu_entry/adminhelp
