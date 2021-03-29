// Turfmakers
#define TRIUMPH_SET_ATMOS	initial_gas_mix = ATMOSPHERE_ID_TRIUMPH
#define TRIUMPH_TURF_CREATE(x)	x/triumph/initial_gas_mix = ATMOSPHERE_ID_TRIUMPH;x/triumph/outdoors=TRUE;x/triumph/allow_gas_overlays = FALSE
#define TRIUMPH_TURF_CREATE_UN(x)	x/triumph/initial_gas_mix=ATMOSPHERE_ID_TRIUMPH

//Simulated
TRIUMPH_TURF_CREATE(/turf/simulated/open)
TRIUMPH_TURF_CREATE(/turf/simulated/floor)
TRIUMPH_TURF_CREATE(/turf/simulated/floor/reinforced)
TRIUMPH_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
TRIUMPH_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
TRIUMPH_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
TRIUMPH_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
TRIUMPH_TURF_CREATE(/turf/simulated/mineral)
TRIUMPH_TURF_CREATE(/turf/simulated/mineral/floor)
