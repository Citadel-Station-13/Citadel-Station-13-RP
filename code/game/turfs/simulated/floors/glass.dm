/turf/simulated/floor/glass
	name = "glass floor"
	desc = "Don't jump on it, or do, I'm not your mom."

	icon = 'icons/turf/flooring/glass.dmi'
	icon_state = "glass-0"
	base_icon_state = "glass"

	base_layer = CATWALK_LAYER
	// Currently if flooring is set, it breaks the layering of the glass floor.
	// initial_flooring = /singleton/flooring/glass

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)
	canSmoothWith = (SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)

	mz_flags = MZ_MIMIC_DEFAULTS

CREATE_STANDARD_TURFS(/turf/simulated/floor/glass)

/turf/simulated/floor/glass/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/turf/simulated/floor/glass/LateInitialize()
	. = ..()
	layer = base_layer


/turf/simulated/floor/glass/reinforced
	name = "reinforced glass flooring"
	desc = "Heavily reinforced with steel rods."

	icon = 'icons/turf/flooring/glass_reinf.dmi'
	icon_state = "glass_reinf-0"
	base_icon_state = "glass_reinf"

	// Currently if flooring is set, it breaks the layering of the glass floor.
	// initial_flooring = /singleton/flooring/glass/reinforced

CREATE_STANDARD_TURFS(/turf/simulated/floor/glass/reinforced)
