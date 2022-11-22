//? WINCLONE IDs; NO SKIN CONTROL MAY HAVE THESE IDs, OR WINCLONE WILL NOT CREATE "NAKED" CONTROLS OF THIS TYPE!
#define SKIN_ID_ABSTRACT_MENU "menu"
#define SKIN_ID_ABSTRACT_WINDOW "window"
#define SKIN_ID_ABSTRACT_PANE "pane"
#define SKIN_ID_ABSTRACT_MACRO "macro"

//? SKIN ELEMENT IDS; MAKE SURE TO UPDATE THESE WHEN CHANGING SKIN.DMF.
//! Window IDs
/// main game window
#define SKIN_WINDOW_ID_MAIN "mainwindow"

//! Map IDs
/// main game viewport
#define SKIN_MAP_ID_VIEWPORT "mapwindow.map"

//! Splitter IDs
/// main window split
#define SKIN_SPLITTER_ID_MAIN "mainwindow.split"

//? Dynamic skin IDs used by code-generated elements
//? button groups MUST have unique ids to all skin elements!
// TOP LEVEL MENU //
#define SKIN_ID_MAIN_MENU "menu_main"
	// what it attaches to
	#define SKIN_ID_MAIN_MENU_ATTACH_TO "mainwindow"
	// categories
	#define SKIN_ID_MENU_CATEGORY_FILE "menu_file"
	#define SKIN_ID_MENU_CATEGORY_ZOOM "menu_zoom"
	#define SKIN_ID_MENU_CATEGORY_SCALING "menu_scaling"
	#define SKIN_ID_MENU_CATEGORY_HELP "menu_help"
	// groups
	#define SKIN_BUTTON_GROUP_MAP_ZOOM "group_map_zoom"
	#define SKIN_BUTTON_GROUP_MAP_SCALING "group_map_scaling"
	#define SKIN_BUTTON_GROUP_MAP_WIDESCREEN "group_map_widescreen"
	// buttons - file
	#define SKIN_ID_MENU_BUTTON_SCREENSHOT "menubutton_screenshot"
	#define SKIN_ID_MENU_BUTTON_SCREENSHOT_QUICK "menubutton_screenshot_quick"
	#define SKIN_ID_MENU_BUTTON_RECONNECT "menubutton_reconnect"
	#define SKIN_ID_MENU_BUTTON_PING "menubutton_ping"
	#define SKIN_ID_MENU_BUTTON_QUIT "menubutton_quit"
	// buttons - size
	#define SKIN_ID_MENU_BUTTON_STRETCH_TO_FIT "menubutton_stretchtofit"
	#define SKIN_ID_MENU_BUTTON_STRETCH_NO_LETTERBOX "menubutton_stretchtofill"
	#define SKIN_ID_MENU_BUTTON_FOR_RESOLUTION(resolution) "menubutton_[resolution]x[resolution]"
	#define SKIN_ID_MENU_BUTTON_WIDESCREEN_ENABLED "menubutton_widescreen_on"
	#define SKIN_ID_MENU_BUTTON_WIDESCREEN_DISABLED "menubutton_widescreen_off"
	#define SKIN_ID_MENU_BUTTON_AUTO_FIT_VIEWPORT "menubutton_auto_fit_viewport"
	#define SKIN_ID_MENU_BUTTON_FIT_VIEWPORT "menubutton_fit_viewport"
	// buttons - scaling
	#define SKIN_ID_MENU_BUTTON_NEAREST_NEIGHBOR "menubutton_scale_distort"
	#define SKIN_ID_MENU_BUTTON_POINT_SAMPLE "menubutton_scale_normal"
	#define SKIN_ID_MENU_BUTTON_BILINEAR "menubutton_scale_blur"
	// buttons - help
	#define SKIN_ID_MENU_BUTTON_ADMINHELP "menubutton_adminhelp"
