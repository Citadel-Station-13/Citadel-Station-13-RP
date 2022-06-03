/**
 * core assets
 */

GLOBAL_VAR(deepmaint_current_interior_wall)
GLOBAL_VAR(deepmaint_current_exterior_wall)
GLOBAL_VAR(deepmaint_current_interior_floor)
GLOBAL_VAR(deepmaint_current_exterior_floor)

/area/deepmaint
	icon = 'icons/mapping/deepmaint.dmi'
	name = "Unexplored Area"
	always_unpowered = FALSE

/area/deepmaint/room
	icon_state = "area_room"

/area/deepmaint/room/powered
	requires_power = FALSE

/area/deepmaint/tunnel
	area_flags = AREA_ABSTRACT
	icon_state = "area_path"

/turf/deepmaint
	icon = 'icons/mapping/deepmaint.dmi'
	icon_state = ""
	initial_gas_mix = ATMOSPHERE_ID_USE_DEFAULT

/turf/deepmaint/Initialize(mapload)
	. = ..()
	ChangeTurf(actual_path(), CHANGETURF_INHERIT_AIR)

/turf/deepmaint/interior_wall
	name = "interior wall"
	icon_state = "interior_wall"

/turf/deepmaint/interior_wall/actual_path()
	return GLOB.deepmaint_current_interior_wall || /turf/simulated/wall

/turf/deepmaint/exterior_wall
	name = "exterior wall"
	icon_state = "exterior_wall"

/turf/deepmaint/exterior_wall/actual_path()
	return GLOB.deepmaint_current_exterior_wall || /turf/simulated/wall

/turf/deepmaint/interior_floor
	name = "interior floor"
	icon_state = "interior_floor"

/turf/deepmaint/interior_floor/actual_path()
	return GLOB.deepmaint_current_interior_floor || /turf/simulated/floor

/turf/deepmaint/exterior_floor
	name = "exterior floor"
	icon_state = "exterior_floor"

/turf/deepmaint/exterior_floor/actual_path()
	return GLOB.deepmaint_current_exterior_floor || /turf/simulated/floor

/atom/movable/landmark/deepmaint_marker
	icon = 'icons/mapping/deepmaint.dmi'

/**
 * room directives
 */
/atom/movable/landmark/deepmaint_marker/room

/**
 * deepmaint room directive: connect entrance to this path
 */
/atom/movable/landmark/deepmaint_marker/room/entrance
	icon_state = "room_entrance"

/**
 * deepmaint room directive: allow spawning of cross-level here
 */
/atom/movable/landmark/deepmaint_marker/room/multiz

/**
 * deepmaint generation directive: links to a generator and affects generation
 * all of these are soft directives
 * the generator is free to ignore them
 */
/atom/movable/landmark/deepmaint_marker/generation
	/// id to link to
	var/id

/**
 * deepmaint generation directive: less danger towards this area
 */
/atom/movable/landmark/deepmaint_marker/generation/low_danger
	icon_state = "marker_low_danger"

/**
 * deepmaint generation directive: more danger towards this area
 */
/atom/movable/landmark/deepmaint_marker/generation/high_danger
	icon_state = "marker_high_danger"

/**
 * deepmaint generation directive: less rarity towards this area
 */
/atom/movable/landmark/deepmaint_marker/generation/low_value
	icon_state = "marker_low_value"

/**
 * deepmaint generation directive: more rarity towards this area
 */
/atom/movable/landmark/deepmaint_marker/generation/high_value
	icon_state = "marker_high_value"

/**
 * deepmaint generation directive: avoid this area
 */
/atom/movable/landmark/deepmaint_marker/generation/avoid
	icon_state = "avoid"

/**
 * deepmaint generation directive: crowd this area
 */
/atom/movable/landmark/deepmaint_marker/generation/crowd
	icon_state = "crowd"
