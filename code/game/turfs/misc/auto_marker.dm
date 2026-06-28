//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/turf_auto_marker_config
	var/outdoors_floor_type = /turf/simulated/floor/tiled
	var/outdoors_floor_stripped_type = /turf/simulated/floor/plating
	var/outdoors_floor_very_stripped_type = /turf/simulated/floor/plating
	var/outdoors_rock_type = /turf/simulated/mineral
	var/outdoors_rock_dense_type = /turf/simulated/mineral
	var/outdoors_rock_very_dense_type = /turf/simulated/mineral
	var/outdoors_liquid_type = /turf/simulated/floor/water

/**
 * automatic markers that replace themselves on mapload
 */
/turf/auto_marker
	name = "unknown auto marker"
	icon = 'icons/turf/auto_marker.dmi'
	abstract_type = /turf/auto_marker

	var/change_to

/turf/auto_marker/Initialize(mapload)
	if(change_to)
		ChangeTurf(change_to)
	return ..()

/**
 * floor; cavern floor, sand, etc
 */
/turf/auto_marker/use_outdoors_floor
	icon_state = "floor-1"

/turf/auto_marker/use_outdoors_floor/preloading_from_mapload(datum/dmm_context/context)
	change_to = context.auto_marker_config.outdoors_floor_type
	..()

/**
 * strip lower
 */
/turf/auto_marker/use_outdoors_floor/stripped
	icon_state = "floor-2"

/turf/auto_marker/use_outdoors_floor/stripped/preloading_from_mapload(datum/dmm_context/context)
	change_to = context.auto_marker_config.outdoors_floor_stripped_type
	..()

/**
 * strip to base
 */
/turf/auto_marker/use_outdoors_floor/very_stripped
	icon_state = "floor-3"

/turf/auto_marker/use_outdoors_floor/very_stripped/preloading_from_mapload(datum/dmm_context/context)
	change_to = context.auto_marker_config.outdoors_floor_very_stripped_type
	..()

/**
 * use rock type
 */
/turf/auto_marker/use_outdoors_rock
	icon_state = "rock-1"

/turf/auto_marker/use_outdoors_rock/preloading_from_mapload(datum/dmm_context/context)
	change_to = context.auto_marker_config.outdoors_rock_type
	..()

/**
 * denser rock
 */
/turf/auto_marker/use_outdoors_rock/dense
	icon_state = "rock-2"

/turf/auto_marker/use_outdoors_rock/dense/preloading_from_mapload(datum/dmm_context/context)
	change_to = context.auto_marker_config.outdoors_rock_dense_type
	..()

/**
 * densest rock
 */
/turf/auto_marker/use_outdoors_rock/very_dense
	icon_state = "rock-3"

/turf/auto_marker/use_outdoors_rock/very_dense/preloading_from_mapload(datum/dmm_context/context)
	change_to = context.auto_marker_config.outdoors_rock_very_dense_type
	..()

/**
 * adapts to water most places, lava on lava worlds, blood in freakshow cult planets, etc
 */
/turf/auto_marker/use_outdoors_liquid
	icon_state = "liquid"

/turf/auto_marker/use_outdoors_liquid/preloading_from_mapload(datum/dmm_context/context)
	change_to = context.auto_marker_config.outdoors_liquid_type
	..()
