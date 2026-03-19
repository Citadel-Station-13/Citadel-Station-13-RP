//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

#define GENERATE_SHUTTLE_TEMPLATE_PRELOAD(TYPEPATH) \
/obj/shuttle_dock_preload/generated##TYPEPATH { \
	shuttle_template_path = /datum/shuttle_template##TYPEPATH; \
	maptext = MAPTEXT_CENTER_CONST("Shuttle Preloader\n" + "(" + /datum/shuttle_template##TYPEPATH::id + ")"); \
};

#define DECLARE_SHUTTLE_TEMPLATE(TYPEPATH) GENERATE_SHUTTLE_TEMPLATE_PRELOAD(TYPEPATH) \
/datum/shuttle_template##TYPEPATH

/**
 * * Binds to /datum/map/sector's
 */
#define DECLARE_SECTOR_SHUTTLE_TEMPLATE(MAP_PATH, TYPEPATH) GENERATE_SHUTTLE_TEMPLATE_PRELOAD(/map_specific/sector##MAP_PATH/##TYPEPATH) \
/datum/shuttle_template/map_specific/sector##MAP_PATH/##TYPEPATH { \
	category = "Map-Specific"; \
}; \
/datum/shuttle_template/map_specific/sector##MAP_PATH/##TYPEPATH

/**
 * * Binds to /datum/map/station's
 */
#define DECLARE_STATION_SHUTTLE_TEMPLATE(MAP_PATH, TYPEPATH) GENERATE_SHUTTLE_TEMPLATE_PRELOAD(/map_specific/station##MAP_PATH/##TYPEPATH) \
/datum/shuttle_template/map_specific/station##MAP_PATH/##TYPEPATH { \
	category = "Map-Specific"; \
}; \
/datum/shuttle_template/map_specific/station##MAP_PATH/##TYPEPATH

#warn sector / station name above, bind for subcat?

#warn aligned?
#define DECLARE_SHUTTLE_DOCK_PRESET_IMPL(TYPEPATH, NAME, ALIGNED) \
/obj/shuttle_dock/preset##TYPEPATH { \
	name = NAME; \
	maptext = MAPTEXT_CENTER_CONST("Shuttle Dock\n" + "(" + NAME + ")"); \
}; \
/obj/shuttle_dock/preset##TYPEPATH
// /obj/shuttle_dock/landing_pad
// 	icon_state = "dock_center"
// 	centered_landing_only = TRUE
// 	centered_landing_allowed = TRUE

#define DECLARE_SHUTTLE_DOCK_PRESET_ALIGNED(TYPEPATH, NAME) DECLARE_SHUTTLE_DOCK_PRESET_IMPL(TYPEPATH, NAME, TRUE)
#define DECLARE_SHUTTLE_DOCK_PRESET_CENTERED(TYPEPATH, NAME) DECLARE_SHUTTLE_DOCK_PRESET_IMPL(TYPEPATH, NAME, FALSE)

#define DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(MAP_FRAGMENT, TYPEPATH, NAME) DECLARE_SHUTTLE_DOCK_PRESET_ALIGNED(/map_specific/##MAP_FRAGMENT##TYPEPATH, NAME)
#define DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(MAP_FRAGMENT, TYPEPATH, NAME) DECLARE_SHUTTLE_DOCK_PRESET_CENTERED(/map_specific/##MAP_FRAGMENT##TYPEPATH, NAME)

#warn ferry pairs
#define DECLARE_SHUTTLE_FERRY_DOCK_MAP_PAIR_ALIGNED(MAP_PATH, TYPEPATH, ID, NAME)
#define DECLARE_SHUTTLE_FERRY_DOCK_MAP_PAIR_CENTERED(MAP_PATH, TYPEPATH, ID, NAME)
#define DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR_ALIGNED(TYPEPATH, ID, NAME)
#define DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR_CENTERED(TYPEPATH, ID, NAME)

/**
 * Boilerplate for custom shuttle areas.
 */
#define DECLARE_SHUTTLE_AREA(TYPEPATH) \
/area/shuttle/bespoke##TYPEPATH
