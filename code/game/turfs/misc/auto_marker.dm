//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * automatic markers that replace themselves on mapload
 */
/turf/auto_marker
	name = "unknown auto marker"
	icon = 'icons/turf/auto_marker.dmi'
	abstract_type = /turf/auto_marker

// TODO: implement

/**
 * floor; cavern floor, sand, etc
 */
/turf/auto_marker/use_outdoors_floor
	icon_state = "floor-1"

/**
 * strip lower
 */
/turf/auto_marker/use_outdoors_floor/stripped
	icon_state = "floor-2"

/**
 * strip to base
 */
/turf/auto_marker/use_outdoors_floor/very_stripped
	icon_state = "floor-3"

/**
 * use rock type
 */
/turf/auto_marker/use_outdoors_rock
	icon_state = "rock-1"

/**
 * denser rock
 */
/turf/auto_marker/use_outdoors_rock/dense
	icon_state = "rock-2"

/**
 * densest rock
 */
/turf/auto_marker/use_outdoors_rock/very_dense
	icon_state = "rock-3"

/**
 * adapts to water most places, lava on lava worlds, blood in freakshow cult planets, etc
 */
/turf/auto_marker/use_outdoors_liquid
	icon_state = "liquid"
