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
