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
	category = "Map-Specific"; \
}; \
/datum/shuttle_template/map_specific/sector##MAP_PATH##TYPEPATH

/**
 * * Binds to /datum/map/station's
 */
#define DECLARE_STATION_SHUTTLE_TEMPLATE(MAP_PATH, TYPEPATH) GENERATE_SHUTTLE_TEMPLATE_PRELOAD(/map_specific/station##MAP_PATH##TYPEPATH) \
/datum/shuttle_template/map_specific/station##MAP_PATH##TYPEPATH { \
	category = "Map-Specific"; \
}; \
/datum/shuttle_template/map_specific/station##MAP_PATH##TYPEPATH

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
} \
/obj/shuttle_dock/ferry_pair##TYPEPATH/away { \
	name = /obj/shuttle_dock/ferry_pair##TYPEPATH::name + " (Away)"; \
	maptext = MAPTEXT_CENTER_CONST("Shuttle Ferry Dock\n" + "(" + NAME + ") - Away"); \
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
/obj/shuttle_dock/ferry_pair/round_global##TYPEPATH { \
}; \
/obj/shuttle_dock/ferry_pair/round_global##TYPEPATH/home { \
}; \
/obj/shuttle_dock/ferry_pair/round_global##TYPEPATH/away { \
}; \
/datum/shuttle_controller/ferry/round_global##TYPEPATH { \
}; \
DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR_VARIABLE_IMPL(/obj/shuttle_dock, VARIABLE_SUFFIX, _home) \
DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR_VARIABLE_IMPL(/obj/shuttle_dock, VARIABLE_SUFFIX, _away) \
DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR_VARIABLE_IMPL(/datum/shuttle_controller/ferry/round_global##TYPEPATH, VARIABLE_SUFFIX, _controller)
#warn impl autobinds
// /obj/shuttle_dock/ferry_pair/escape_shuttle/init_shuttle(datum/shuttle/shuttle)
// 	. = ..()
// 	#warn impl

	// var/datum/shuttle_controller/ferry/controller = new(dock_id, ferry_away_id)
	// shuttle.bind_controller(controller)

	// var/datum/shuttle_controller/ferry/controller = new(dock_id, ferry_away_id)
	// shuttle.bind_controller(controller)

// /obj/shuttle_dock/ferry_pair/escape_shuttle/init_shuttle_controller(datum/shuttle/shuttle)
// 	. = ..()
// 	#warn impl


// /obj/shuttle_dock/ferry_pair/supply_shuttle/init_shuttle(datum/shuttle/shuttle)
// 	. = ..()
// 	#warn impl

// /obj/shuttle_dock/ferry_pair/supply_shuttle/init_shuttle_controller(datum/shuttle/shuttle)
// 	. = ..()
// 	#warn impl

/**
 * Boilerplate for custom shuttle areas.
 */
#define DECLARE_SHUTTLE_AREA(TYPEPATH) \
/area/shuttle/bespoke##TYPEPATH
