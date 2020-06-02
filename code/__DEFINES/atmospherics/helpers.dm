
#define THERMAL_ENERGY(gas) (gas.temperature * gas.heat_capacity())
/// Atmospherics quantization define.
#define QUANTIZE(variable)		(round(variable,0.0000001))/*I feel the need to document what happens here. Basically this is used to catch most rounding errors, however it's previous value made it so that
															once gases got hot enough, most procedures wouldnt occur due to the fact that the mole counts would get rounded away. Thus, we lowered it a few orders of magnititude */

/// Writes the total moles of cached gases gaslist to out_var. Use this to spare a proccall in performance critical areas.
#define TOTAL_MOLES(cached_gases, out_var)\
	out_var = 0;\
	for(var/total_moles_id in cached_gases){\
		out_var += cached_gases[total_moles_id];\
	}

///
#define GAS_GARBAGE_COLLECT(GASGASGAS)\
	var/list/CACHE_GAS = GASGASGAS;\
	for(var/id in CACHE_GAS){\
		if(QUANTIZE(CACHE_GAS[id]) <= 0)\
			CACHE_GAS -= id;\
	}

#define ARCHIVE_TEMPERATURE(gas)		gas.temperature_archived = gas.temperature
#define ARCHIVE_gases(gas)				gas.gas_archive = gas.gases.Copy()
