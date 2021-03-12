// Turfmakers
#define BOREAS_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_BOREAS
#define BOREAS_TURF_CREATE(x)	x/boreas/initial_gas_mix=ATMOSPHERE_ID_BOREAS;x/boreas/outdoors=TRUE;x/boreas/allow_gas_overlays = FALSE
#define BOREAS_TURF_CREATE_UN(x)	x/boreas/initial_gas_mix=ATMOSPHERE_ID_BOREAS

//Simulated
BOREAS_TURF_CREATE(/turf/simulated/open)
BOREAS_TURF_CREATE(/turf/simulated/floor)
BOREAS_TURF_CREATE(/turf/simulated/floor/reinforced)
BOREAS_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
BOREAS_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
BOREAS_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
BOREAS_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
BOREAS_TURF_CREATE(/turf/simulated/mineral)
BOREAS_TURF_CREATE(/turf/simulated/mineral/floor)
