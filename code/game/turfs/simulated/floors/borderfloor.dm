/turf/simulated/floor/tiled/auto_border
	icon = 'icons/turf/tiles/borderfloors/standard.dmi'
	icon_state = "borderfloor-15"
	base_icon_state = "borderfloor"
	initial_flooring = /decl/flooring/tiling/borderfloor
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_OPEN_FLOOR)

/turf/simulated/floor/tiled/auto_border/white
	icon = 'icons/turf/tiles/borderfloors/white.dmi'
	initial_flooring = /decl/flooring/tiling/borderfloor/white

/turf/simulated/floor/tiled/auto_border/lightgrey
	icon = 'icons/turf/tiles/borderfloors/lightgrey.dmi'
	initial_flooring = /decl/flooring/tiling/borderfloor/lightgrey
