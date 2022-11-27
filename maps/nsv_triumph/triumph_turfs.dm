// Be sure to update planetary_vr.dm and atmosphers.dm when switching to this map.
/turf/simulated/open/triumph
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf

/turf/simulated/open/triumph/Initialize(mapload)
	. = ..()
	if(outdoors)
		SSplanets.addTurf(src)

/turf/simulated/floor/triumph_indoors
	TRIUMPH_SET_ATMOS
	allow_gas_overlays = FALSE

/turf/simulated/floor/outdoors/grass/sif
	baseturfs = /turf/simulated/floor/outdoors/dirt



//Unsimulated
/turf/unsimulated/mineral/triumph
	blocks_air = TRUE

