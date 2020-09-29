// This is a wall you surround the area of your "planet" with, that makes the atmosphere inside stay within bounds, even if canisters
// are opened or other strange things occur.
/turf/unsimulated/wall/planetary
	name = "railroading"
	desc = "Choo choo!"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1
	alpha = 0
	blocks_air = 0
	// Set these to get your desired planetary atmosphere.
	initial_gas_mix = GAS_STRING_STP

/turf/unsimulated/wall/planetary/Initialize(mapload)
	. = ..()
	SSplanets.addTurf(src)

/turf/unsimulated/wall/planetary/Destroy()
	SSplanets.removeTurf(src)
	return ..()

/turf/unsimulated/wall/planetary/proc/set_temperature(var/new_temperature)
	if(new_temperature == temperature)
		return
	temperature = new_temperature
	// Force ZAS to reconsider our connections because our temperature has changed
	if(connections)
		connections.erase_all()
	air_master.mark_for_update(src)

// Normal station/earth air.
/turf/unsimulated/wall/planetary/normal
	initial_gas_mix = GAS_STRING_STP

/turf/unsimulated/wall/planetary/firnir
	initial_gas_mix = GAS_STRING_FIRNIR

/turf/unsimulated/wall/planetary/tyr
	initial_gas_mix = GAS_STRING_TYR

// Wiki says it's 92.6 kPa, composition 18.1% O2 80.8% N2 1.1% trace.  We're gonna pretend trace is actually nitrogen.
/turf/unsimulated/wall/planetary/sif
	initial_gas_mix = GAS_STRING_SIF

//High Alt Sif
/turf/unsimulated/wall/planetary/sif/alt
	initial_gas_mix = GAS_STRING_SIF_ALT

// Fairly close to Mars in terms of temperature and pressure.
/turf/unsimulated/wall/planetary/magni
	initial_gas_mix = GAS_STRING_MAGNI

/turf/unsimulated/wall/planetary/desert
	initial_gas_mix = GAS_STRING_STP_HOT


// Virgo Turfmakers

#define VIRGO3B_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_VIRGO3B
#define VIRGO3B_TURF_CREATE(x)	x/virgo3b/initial_gas_mix=ATMOSPHERE_ID_VIRGO3B;x/virgo3b/outdoors=TRUE;x/virgo3b/update_graphic(list/graphic_add = null, list/graphic_remove = null) return 0
#define VIRGO3B_TURF_CREATE_UN(x)	x/virgo3b/initial_gas_mix=ATMOSPHERE_ID_VIRGO3B

// This is a wall you surround the area of your "planet" with, that makes the atmosphere inside stay within bounds, even if canisters
// are opened or other strange things occur.
/turf/unsimulated/wall/planetary/virgo3b
	name = "facility wall"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	alpha = 0xFF
	VIRGO3B_SET_ATMOS

// This line below is placeholder for Triumph as the code base here gets really angry if there isn't an actual planet atmos to set. Might do something for Tirumph in the future to allow this.

/turf/unsimulated/wall/planetary/triumph
	name = "facility wall"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	alpha = 0xFF
	TRIUMPH_SET_ATMOS
