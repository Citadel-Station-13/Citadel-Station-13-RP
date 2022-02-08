//Simulated

//Outside turfs
MAGMATIC_RIFT_TURF_CREATE(/turf/simulated/open)
/turf/simulated/open/magmatic_rift
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf
/turf/simulated/open/magmatic_rift/Initialize(mapload)
	. = ..()
	if(outdoors)
		SSplanets.addTurf(src)

MAGMATIC_RIFT_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand)
MAGMATIC_RIFT_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
MAGMATIC_RIFT_TURF_CREATE(/turf/simulated/floor/outdoors/lava)
MAGMATIC_RIFT_TURF_CREATE(/turf/simulated/floor/tiled)
MAGMATIC_RIFT_TURF_CREATE(/turf/simulated/mineral)
//MAGMATIC_RIFT_TURF_CREATE()
//MAGMATIC_RIFT_TURF_CREATE()


/*turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/virgo3b,
		/turf/simulated/floor/outdoors/dirt/virgo3b
		)*/
