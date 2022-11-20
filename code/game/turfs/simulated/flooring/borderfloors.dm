/decl/flooring/tiling/borderfloor
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/tiles/borderfloors/standard.dmi'
	base_icon_state = "borderfloor"
	has_damage_range = null
	uses_legacy_smooth = FALSE

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_OPEN_FLOOR)

/decl/flooring/tiling/borderfloor/white
	icon = 'icons/turf/tiles/borderfloors/white.dmi'

/decl/flooring/tiling/borderfloor/lightgrey
	icon = 'icons/turf/tiles/borderfloors/lightgrey.dmi'
