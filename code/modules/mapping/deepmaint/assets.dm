/**
 * core assets
 */

GLOBAL_VAR(deepmaint_current_interior_wall)
GLOBAL_VAR(deepmaint_current_exterior_wall)
GLOBAL_VAR(deepmaint_current_interior_floor)
GLOBAL_VAR(deepmaint_current_exterior_floor)

/area/deepmaint
	name = "Unexplored Area"
	always_unpowered = FALSE

/area/deepmaint/room

/area/deepmaint/room/powered
	requires_power = FALSE

/area/deepmaint/tunnel
	area_flags = AREA_ABSTRACT

/turf/deepmaint
	icon = 'icons/turf/deepmaint.dmi'
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

