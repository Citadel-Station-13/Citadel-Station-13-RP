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
#define DECLARE_SECTOR_SHUTTLE_TEMPLATE(MAP_PATH, TYPEPATH) GENERATE_SHUTTLE_TEMPLATE_PRELOAD(/map_specific/sector##MAP_PATH##TYPEPATH) \
/datum/shuttle_template/map_specific/sector##MAP_PATH##TYPEPATH { \
	category = "Sector-Specific"; \
	subcategory = /datum/map/sector##MAP_PATH::name; \
}; \
/datum/shuttle_template/map_specific/sector##MAP_PATH##TYPEPATH

/**
 * * Binds to /datum/map/station's
 */
#define DECLARE_STATION_SHUTTLE_TEMPLATE(MAP_PATH, TYPEPATH) GENERATE_SHUTTLE_TEMPLATE_PRELOAD(/map_specific/station##MAP_PATH##TYPEPATH) \
/datum/shuttle_template/map_specific/station##MAP_PATH##TYPEPATH { \
	category = "Station-Specific"; \
	subcategory = /datum/map/station##MAP_PATH::name; \
}; \
/datum/shuttle_template/map_specific/station##MAP_PATH##TYPEPATH

#define DECLARE_SHUTTLE_DOCK_PRESET_IMPL(TYPEPATH, NAME, ALIGNED) \
/obj/shuttle_dock/preset##TYPEPATH { \
	name = NAME; \
	maptext = MAPTEXT_CENTER_CONST("Shuttle Dock\n" + "(" + NAME + ")"); \
	centered_landing_only = ALIGNED; \
}; \
/obj/shuttle_dock/preset##TYPEPATH

#define DECLARE_SHUTTLE_DOCK_PRESET_ALIGNED(TYPEPATH, NAME) DECLARE_SHUTTLE_DOCK_PRESET_IMPL(TYPEPATH, NAME, TRUE)
#define DECLARE_SHUTTLE_DOCK_PRESET_CENTERED(TYPEPATH, NAME) DECLARE_SHUTTLE_DOCK_PRESET_IMPL(TYPEPATH, NAME, FALSE)

#define DECLARE_SHUTTLE_DOCK_MAP_PRESET_ALIGNED(MAP_FRAGMENT, TYPEPATH, NAME) DECLARE_SHUTTLE_DOCK_PRESET_ALIGNED(/map_specific##MAP_FRAGMENT##TYPEPATH, NAME)
#define DECLARE_SHUTTLE_DOCK_MAP_PRESET_CENTERED(MAP_FRAGMENT, TYPEPATH, NAME) DECLARE_SHUTTLE_DOCK_PRESET_CENTERED(/map_specific##MAP_FRAGMENT##TYPEPATH, NAME)

#warn ferry pairs
#define DECLARE_SHUTTLE_FERRY_DOCK_PAIR_IMPL(TYPEPATH, NAME) \
/obj/shuttle_dock/ferry_pair##TYPEPATH { \
	name = "Ferry Dock - " + NAME; \
}; \
/obj/shuttle_dock/ferry_pair##TYPEPATH/home { \
	name = /obj/shuttle_dock/ferry_pair##TYPEPATH::name + " (Home)"; \
	maptext = MAPTEXT_CENTER_CONST("Shuttle Ferry Dock\n" + "(" + NAME + ") - Home"); \
	ferry_init_is_home = TRUE; \
	ferry_init_bind_opposite_typepath = /obj/shuttle_dock/ferry_pair##TYPEPATH/away; \
} \
/obj/shuttle_dock/ferry_pair##TYPEPATH/away { \
	name = /obj/shuttle_dock/ferry_pair##TYPEPATH::name + " (Away)"; \
	maptext = MAPTEXT_CENTER_CONST("Shuttle Ferry Dock\n" + "(" + NAME + ") - Away"); \
	ferry_init_is_home = FALSE; \
	ferry_init_bind_opposite_typepath = /obj/shuttle_dock/ferry_pair##TYPEPATH/home; \
}

/**
 * Declares a map-specific instancing of a ferry pair.
 * * Different maps create different instances of this. The same ferry pair must be on the same map,
 *   or they won't bind.
 */
#define DECLARE_SHUTTLE_FERRY_DOCK_MAP_PAIR(MAP_PATH, TYPEPATH, NAME) \
DECLARE_SHUTTLE_FERRY_DOCK_PAIR_IMPL(/map_specific##MAP_PATH##TYPEPATH, NAME)

#define DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR_VARIABLE_IMPL(VARIABLE_TYPE, VARIABLE_TAG, VARIABLE_SUFFIX) \
GLOBAL_DATUM(global_ferry_##VARIABLE_TAG##VARIABLE_SUFFIX, VARIABLE_TYPE)

/**
 * Declares a global ferry pair and auto-binds it to a set of generated global variables.
 */
#define DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR(VARIABLE_SUFFIX, TYPEPATH, NAME) \
DECLARE_SHUTTLE_FERRY_DOCK_PAIR_IMPL(/round_global##TYPEPATH, NAME) \
/obj/shuttle_dock/ferry_pair/round_global##TYPEPATH/home/Initialize(mapload) { \
	if(GLOB.global_ferry_##VARIABLE_SUFFIX##_home) { \
		. = INITIALIZE_HINT_QDEL; \
		CRASH("Global ferry duplicate init on type [#TYPEPATH] (home) at [COORD(src)] vs [COORD(GLOB.global_ferry_##VARIABLE_SUFFIX##_home)]"); \
	} \
	GLOB.global_ferry_##VARIABLE_SUFFIX##_home = src; \
	return ..(); \
}; \
/obj/shuttle_dock/ferry_pair/round_global##TYPEPATH/away/Initialize(mapload) { \
	if(GLOB.global_ferry_##VARIABLE_SUFFIX##_away) { \
		. = INITIALIZE_HINT_QDEL; \
		CRASH("Global ferry duplicate init on type [#TYPEPATH] (away) at [COORD(src)] vs [COORD(GLOB.global_ferry_##VARIABLE_SUFFIX##_away)]"); \
	} \
	GLOB.global_ferry_##VARIABLE_SUFFIX##_away = src; \
	return ..(); \
}; \
/datum/shuttle_controller/ferry/round_global##TYPEPATH/New() { \
	if(GLOB.global_ferry_##VARIABLE_SUFFIX##_controller) { \
		STACK_TRACE("Global ferry controller duplicate init on type [#TYPEPATH]. Overwriting old controller."); \
	} \
	GLOB.global_ferry_##VARIABLE_SUFFIX##_controller = src; \
	..(); \
}; \
DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR_VARIABLE_IMPL(/obj/shuttle_dock, VARIABLE_SUFFIX, _home) \
DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR_VARIABLE_IMPL(/obj/shuttle_dock, VARIABLE_SUFFIX, _away) \
DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR_VARIABLE_IMPL(/datum/shuttle_controller/ferry/round_global##TYPEPATH, VARIABLE_SUFFIX, _controller)

/**
 * Boilerplate for custom shuttle areas.
 */
#define DECLARE_SHUTTLE_AREA(TYPEPATH) \
/area/shuttle/bespoke##TYPEPATH
