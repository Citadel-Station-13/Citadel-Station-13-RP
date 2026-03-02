//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

#define GENERATE_SHUTTLE_TEMPLATE_PRELOAD(TYPEPATH) \
/obj/shuttle_dock_preload/generated##TYPEPATH { \
	shuttle_template_path = /datum/shuttle_template##TYPEPATH; \
	maptext = MAPTEXT_CENTER_CONST("Shuttle Preloader\n" + "(" + /datum/shuttle_template##TYPEPATH::id + ")"); \
}; \
/datum/shuttle_template##TYPEPATH

#define DECLARE_SHUTTLE_TEMPLATE(TYPEPATH) GENERATE_SHUTTLE_TEMPLATE_PRELOAD(TYPEPATH)

#define DECLARE_SHUTTLE_DOCK_PRESET(TYPEPATH, NAME) \
/obj/shuttle_dock/preset##TYPEPATH { \
	name = NAME; \
	maptext = MAPTEXT_CENTER_CONST("Shuttle Dock\n" + "(" + NAME + ")"); \
}; \
/obj/shuttle_dock/preset##TYPEPATH

#define DECLARE_SHUTTLE_DOCK_MAP_PRESET(MAP_FRAGMENT, TYPEPATH, NAME) DECLARE_SHUTTLE_DOCK_PRESET(/map_specific/##MAP_FRAGMENT##TYPEPATH, NAME)

/**
 * Boilerplate for shuttle areas.
 */
#define DECLARE_SHUTTLE_AREA(TYPEPATH) \
/area/shuttle##TYPEPATH
