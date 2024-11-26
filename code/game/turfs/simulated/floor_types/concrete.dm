CREATE_STANDARD_TURFS(/turf/simulated/floor/concrete)
/turf/simulated/floor/concrete
	name = "concrete"
	desc = "That's concrete baby!"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "concrete"
	initial_flooring = /datum/prototype/flooring/concrete
	baseturfs = /turf/simulated/floor/outdoors/dirt
	edge_blending_priority = 0
	smoothing_flags = NONE

CREATE_STANDARD_TURFS(/turf/simulated/floor/concrete/tile)
/turf/simulated/floor/concrete/tile
	name = "concrete tile"
	desc = "That's concrete baby!"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "concrete3"
	initial_flooring = /datum/prototype/flooring/concrete/tile
	baseturfs = /turf/simulated/floor/outdoors/dirt

CREATE_STANDARD_TURFS(/turf/simulated/floor/concrete/rng)
/turf/simulated/floor/concrete/rng/Initialize(mapload)
	. = ..()
	if(prob(5))
		icon_state = "concrete[pick(1,2)]"
