// This is a wall you surround the area of your "planet" with, that makes the atmosphere inside stay within bounds, even if canisters
// are opened or other strange things occur.
/turf/unsimulated/wall/planetary
	name = "railroading"
	desc = "Choo choo!"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	density = TRUE
	alpha = 0
	blocks_air = FALSE
	// Set these to get your desired planetary atmosphere.
	initial_gas_mix = ATMOSPHERE_USE_OUTDOORS

/turf/unsimulated/wall/planetary/endless_sands
	name = "Endless Sands"
	desc = "You see nothing but featureless flat desert stretching outwards far beyond what the eye can see."
	icon_state = "desert"
	opacity = FALSE
	alpha = 255
	initial_gas_mix = GAS_STRING_STP_HOT

/turf/unsimulated/wall/planetary/facility_wall
	name = "facility wall"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	alpha = 255

/turf/unsimulated/wall/planetary/permafrost
	name = "glacial permafrost"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	initial_gas_mix = ATMOSPHERE_ID_LYTHIOS43C
	icon = 'icons/turf/walls/natural.dmi'
	icon_state = "preview"
	base_icon_state = "wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WALLS+SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_MINERAL_WALLS)
	canSmoothWith = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS+SMOOTH_GROUP_MINERAL_WALLS)
	color = COLOR_OFF_WHITE
	alpha = 255
