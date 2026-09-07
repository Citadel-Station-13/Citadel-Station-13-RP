//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/// declares an admin panel global'd
///
/// this lets other parts of the code call procs on it, like push_ui_data
/// this is very useful for things like shuttle panels, which need to update
/// as shuttles do.
#define ADMIN_PANEL_GLOBAL(PATH, GLOBAL_NAME) \
GLOBAL_DATUM(GLOBAL_NAME, PATH); \
##PATH/New() { \
	GLOB.##GLOBAL_NAME = src; \
}

/// declares an admin pane global'd
///
/// this lets other parts of the code call procs on it, like push_ui_data
/// this is very useful for things like shuttle panes, which need to update
/// as shuttles do.
#define ADMIN_PANE_GLOBAL(PATH, GLOBAL_NAME) \
GLOBAL_DATUM(GLOBAL_NAME, PATH); \
##PATH/New() { \
	GLOB.##GLOBAL_NAME = src; \
}

/// declares an admin section global'd
///
/// this lets other parts of the code call procs on it, like push_ui_data
/// this is very useful for things like shuttle sections, which need to update
/// as shuttles do.
#define ADMIN_SECTION_GLOBAL(PATH, GLOBAL_NAME) \
GLOBAL_DATUM(GLOBAL_NAME, PATH); \
##PATH/New() { \
	GLOB.##GLOBAL_NAME = src; \
}
