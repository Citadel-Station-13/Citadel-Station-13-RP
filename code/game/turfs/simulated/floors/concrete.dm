/turf/simulated/floor/outdoors/concrete
	name = "concrete"
	desc = "That's concrete baby!"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "concrete"
	initial_flooring = /singleton/flooring/concrete
	baseturfs = /turf/baseturf_bottom

/turf/simulated/floor/outdoors/concrete/tile
	name = "concrete tile"
	desc = "That's concrete baby!"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "concrete3"
	initial_flooring = /singleton/flooring/concrete
	baseturfs = /turf/baseturf_bottom

/turf/simulated/floor/outdoors/concrete/tile/indoors
	outdoors = FALSE

/turf/simulated/floor/outdoors/concrete/rng/Initialize(mapload)
	. = ..()
	if(prob(5))
		icon_state = "concrete[pick(1,2)]"
	else icon_state = "concrete"

/turf/simulated/floor/outdoors/concrete/indoors
	outdoors = FALSE

/turf/simulated/floor/outdoors/concrete/rng/indoors
	outdoors = FALSE
