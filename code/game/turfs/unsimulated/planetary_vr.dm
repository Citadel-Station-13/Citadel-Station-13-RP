
//Turfmakers
#define BOREAS_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_BOREAS
#define BOREAS_TURF_CREATE(x)	x/boreas/initial_gas_mix=ATMOSPHERE_ID_BOREAS;x/boreas/outdoors=TRUE;x/boreas/allow_gas_overlays = FALSE
#define BOREAS_TURF_CREATE_UN(x)	x/boreas/initial_gas_mix=ATMOSPHERE_ID_BOREAS

#define VIRGO3B_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_VIRGO3B
#define VIRGO3B_TURF_CREATE(x)	x/virgo3b/initial_gas_mix=ATMOSPHERE_ID_VIRGO3B;x/virgo3b/outdoors=TRUE;x/virgo3b/allow_gas_overlays = FALSE
#define VIRGO3B_TURF_CREATE_UN(x)	x/virgo3b/initial_gas_mix=ATMOSPHERE_ID_VIRGO3B

// This is a wall you surround the area of your "planet" with, that makes the atmosphere inside stay within bounds, even if canisters
// are opened or other strange things occur.
/turf/unsimulated/wall/planetary/virgo3b
	name = "facility wall"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	alpha = 0xFF
	VIRGO3B_SET_ATMOS

/turf/unsimulated/wall/planetary/boreas
	name = "facility wall"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	alpha = 0xFF
	BOREAS_SET_ATMOS
