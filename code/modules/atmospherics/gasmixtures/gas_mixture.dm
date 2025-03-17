/**
 * XGM-based gas mixtures from baystation.
 *
 * * gas mixtures are a simulation construct, not a feature system. any snowflake procs should go in their own files.
 *   as an example, `gas_mixture-environmental` is for our environmental (ZAS, right now) system; it is NOT core code.
 * * gas mixtures are always thermodynamically consistent (no energy is created or lost) on any interaction between two
 *   non-immutable mixtures. if it isn't, the gas mixture is always in the wrong.
 * * gas mixtures are never thermodynamically consistent on interaction between a mutable and an immutable mixture.
 *   procs that do that tend to return the energy that was created / gained so you can handle it.
 */
/datum/gas_mixture
	/**
	 * Associative list of gas ID to moles in us.
	 *
	 * * Gases with 0 moles are pruned automatically.
	 * * This **is only** safe to directly edit, if update_values() is called after said edits.
	 */
	var/list/gas
	/**
	 * Temperature of this gas mixture in Kelvin.
	 *
	 * * This **is** safe to directly edit, if you know what you're doing
	 *   and trigger updates accordingly for anything referencing this mixture.
	 */
	var/temperature = TCMB
	/**
	 * Volume of this gas mixture in liters.
	 */
	var/volume = CELL_VOLUME
	/// Size of the group this gas_mixture is representing. 1 for singletons.
	///
	/// * This is a system used to speed up cellular simulation, including the biggest cellular gas sim in the game (the game world).
	/// * Most procs should take this into account. Many procs include a `_singular()` variant that does not.
	var/group_multiplier = 1

	//* Cached Values *//

	/// Sum of all moles in this mixture.
	///
	/// * Updated by update_values().
	var/tmp/total_moles = 0

	//* Debug *//

	#ifdef CF_ATMOS_XGM_UPDATE_VALUES_ASSERTIONS
	var/list/debug_gas_archive
	#endif

/datum/gas_mixture/New(vol = CELL_VOLUME)
	volume = vol
	gas = list()

/datum/gas_mixture/clone()
	var/datum/gas_mixture/mixture = new(volume)
	mixture.gas = gas.Copy()
	mixture.temperature = temperature
	mixture.group_multiplier = group_multiplier
	mixture.total_moles = total_moles
#ifdef CF_ATMOS_XGM_UPDATE_VALUES_ASSERTIONS
	mixture.update_values()
#endif

//Takes a gas string and the amount of moles to adjust by.  Calls update_values() if update isn't 0.
/datum/gas_mixture/proc/adjust_gas(gasid, moles, update = 1)
	if(moles == 0)
		return

	if (group_multiplier != 1)
		gas[gasid] += moles/group_multiplier
	else
		gas[gasid] += moles

	if(update)
		update_values()


//Same as adjust_gas(), but takes a temperature which is mixed in with the gas.
/datum/gas_mixture/proc/adjust_gas_temp(gasid, moles, temp, update = 1)
	if(moles == 0)
		return

	var/self_heat_capacity = heat_capacity()
	var/giver_heat_capacity = global.gas_data.specific_heats[gasid] * moles

	var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
	if(combined_heat_capacity != 0)
		temperature = (temp * giver_heat_capacity + temperature * self_heat_capacity) / combined_heat_capacity

	if (group_multiplier != 1)
		gas[gasid] += moles/group_multiplier
	else
		gas[gasid] += moles

	if(update)
		update_values()


//Variadic version of adjust_gas().  Takes any number of gas and mole pairs and applies them.
/datum/gas_mixture/proc/adjust_multi()
	ASSERT(!(args.len % 2))

	for(var/i = 1; i < args.len; i += 2)
		adjust_gas(args[i], args[i+1], update = 0)

	update_values()


//Variadic version of adjust_gas_temp().  Takes any number of gas, mole and temperature associations and applies them.
/datum/gas_mixture/proc/adjust_multi_temp()
	ASSERT(!(args.len % 3))

	for(var/i = 1; i < args.len; i += 3)
		adjust_gas_temp(args[i], args[i + 1], args[i + 2], update = 0)

	update_values()


//Merges all the gas from another mixture into this one.  Respects group_multipliers and adjusts temperature correctly.
//Does not modify giver in any way.
/datum/gas_mixture/proc/merge(datum/gas_mixture/giver)
	if(!giver)
		return

	var/self_heat_capacity = heat_capacity()
	var/giver_heat_capacity = giver.heat_capacity()
	var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
	if(combined_heat_capacity != 0)
		temperature = (giver.temperature*giver_heat_capacity + temperature*self_heat_capacity)/combined_heat_capacity

	if((group_multiplier != 1)||(giver.group_multiplier != 1))
		for(var/g in giver.gas)
			gas[g] += giver.gas[g] * giver.group_multiplier / group_multiplier
	else
		for(var/g in giver.gas)
			gas[g] += giver.gas[g]

	update_values()

//Technically vacuum doesn't have a specific entropy. Just use a really big number (infinity would be ideal) here so that it's easy to add gas to vacuum and hard to take gas out.
#define SPECIFIC_ENTROPY_VACUUM		150000

//Returns the ideal gas specific entropy of the whole mix. This is the entropy per mole of /mixed/ gas.
/datum/gas_mixture/proc/specific_entropy()
	if (!gas.len || total_moles == 0)
		return SPECIFIC_ENTROPY_VACUUM

	. = 0
	for(var/g in gas)
		. += gas[g] * specific_entropy_gas(g)
	. /= total_moles


/*
	It's arguable whether this should even be called entropy anymore. It's more "based on" entropy than actually entropy now.

	Returns the ideal gas specific entropy of a specific gas in the mix. This is the entropy due to that gas per mole of /that/ gas in the mixture, not the entropy due to that gas per mole of gas mixture.

	For the purposes of SS13, the specific entropy is just a number that tells you how hard it is to move gas. You can replace this with whatever you want.
	Just remember that returning a SMALL number == adding gas to this gas mix is HARD, taking gas away is EASY, and that returning a LARGE number means the opposite (so a vacuum should approach infinity).

	So returning a constant/(partial pressure) would probably do what most players expect. Although the version I have implemented below is a bit more nuanced than simply 1/P in that it scales in a way
	which is bit more realistic (natural log), and returns a fairly accurate entropy around room temperatures and pressures.
*/
/datum/gas_mixture/proc/specific_entropy_gas(var/gasid)
	if (!(gasid in gas) || gas[gasid] == 0)
		return SPECIFIC_ENTROPY_VACUUM	//that gas isn't here

	//group_multiplier gets divided out in volume/gas[gasid] - also, V/(m*T) = R/(partial pressure)
	var/molar_mass = global.gas_data.molar_masses[gasid] * 0.001
	var/specific_heat = global.gas_data.specific_heats[gasid]
	return R_IDEAL_GAS_EQUATION * ( log( (IDEAL_GAS_ENTROPY_CONSTANT*volume/(gas[gasid] * temperature)) * (molar_mass*specific_heat*temperature)**(2/3) + 1 ) +  15 )

	//alternative, simpler equation
	//var/partial_pressure = gas[gasid] * R_IDEAL_GAS_EQUATION * temperature / volume
	//return R_IDEAL_GAS_EQUATION * ( log (1 + IDEAL_GAS_ENTROPY_CONSTANT/partial_pressure) + 20 )


//Updates the total_moles count and trims any empty gases.
/datum/gas_mixture/proc/update_values()
	GAS_GARBAGE_COLLECT(gas)
	TOTAL_MOLES(gas, total_moles)
	if(!total_moles)
		temperature = TCMB

	#ifdef CF_ATMOS_XGM_UPDATE_VALUES_ASSERTIONS
	debug_gas_archive = gas?.Copy()
	#endif

//Copies gas and temperature from another gas_mixture.
/datum/gas_mixture/proc/copy_from(const/datum/gas_mixture/sample)
	gas = sample.gas.Copy()
	temperature = sample.temperature

	update_values()

	return 1

/datum/gas_mixture/proc/react()
	zburn(null, force_burn=0, no_check=0) //could probably just call zburn() here with no args but I like being explicit.

/**
  * Returns a list of vis_contents graphics for the gases we contain.
  */
/datum/gas_mixture/proc/get_turf_graphics()
	. = list()
	var/list/gases = src.gas
	var/list/visual_cache = global.gas_data.visuals
	var/list/overlay_cache = global.gas_data.visual_images
	for(var/id in gases)
		if(!visual_cache[id])
			continue
		var/list/v = visual_cache[id]
		var/moles = gases[id]
		if(moles < v[GAS_VISUAL_INDEX_THRESHOLD])
			continue
		. += overlay_cache[id][min(round(moles * v[GAS_VISUAL_INDEX_FACTOR]) + 1, GAS_VISUAL_STEP_MAX)]
	return length(.)? . : null

//Equalizes a list of gas mixtures.  Used for pipe networks.
/proc/equalize_gases(list/datum/gas_mixture/gases)
	//Calculate totals from individual components
	var/total_volume = 0
	var/total_thermal_energy = 0
	var/total_heat_capacity = 0

	var/list/total_gas = list()
	for(var/datum/gas_mixture/gasmix in gases)
		total_volume += gasmix.volume
		var/temp_heatcap = gasmix.heat_capacity()
		total_thermal_energy += gasmix.temperature * temp_heatcap
		total_heat_capacity += temp_heatcap
		for(var/g in gasmix.gas)
			total_gas[g] += gasmix.gas[g]

	if(total_volume > 0)
		var/datum/gas_mixture/combined = new(total_volume)
		combined.gas = total_gas

		//Calculate temperature
		if(total_heat_capacity > 0)
			combined.temperature = total_thermal_energy / total_heat_capacity
		combined.update_values()

		//Allow for reactions
		combined.react()

		//Average out the gases
		for(var/g in combined.gas)
			combined.gas[g] /= total_volume

		//Update individual gas_mixtures
		for(var/datum/gas_mixture/gasmix in gases)
			gasmix.gas = combined.gas.Copy()
			gasmix.temperature = combined.temperature
			gasmix.multiply(gasmix.volume)
			// todo: is this needed? even if not, it should be compiled in if we're under update values debug assertions
			gasmix.update_values()

	return 1

/**
  * Sets our gas/temperature equal to a turf's initial gas mix.
  */
/datum/gas_mixture/proc/copy_from_turf(turf/model)
	parse_gas_string(model.initial_gas_mix, model)

	// acounts for changes in temperature
	// todo: this is silly and weird.
	var/turf/model_parent = model.parent_type
	if(model.temperature != initial(model.temperature) || model.temperature != initial(model_parent.temperature))
		temperature = model.temperature

	return TRUE

//Simpler version of merge(), adjusts gas amounts directly and doesn't account for temperature or group_multiplier.
/datum/gas_mixture/proc/add(datum/gas_mixture/right_side)
	for(var/g in right_side.gas)
		gas[g] += right_side.gas[g]

	update_values()
	return 1


//Simpler version of remove(), adjusts gas amounts directly and doesn't account for group_multiplier.
/datum/gas_mixture/proc/subtract(datum/gas_mixture/right_side)
	for(var/g in right_side.gas)
		gas[g] -= right_side.gas[g]

	update_values()
	return 1


//Multiply all gas amounts by a factor.
/datum/gas_mixture/proc/multiply(factor)
	for(var/g in gas)
		gas[g] *= factor

	update_values()
	return 1


//Divide all gas amounts by a factor.
/datum/gas_mixture/proc/divide(factor)
	for(var/g in gas)
		gas[g] /= factor

	update_values()
	return 1

/**
 * empty us out
 */
/datum/gas_mixture/proc/empty()
	gas.len = 0
	total_moles = 0
	temperature = TCMB
#ifdef CF_ATMOS_XGM_UPDATE_VALUES_ASSERTIONS
	debug_gas_archive = list()
#endif

/**
 * get mass in kilograms
 */
/datum/gas_mixture/proc/get_mass()
	for(var/g in gas)
		. += gas[g] * global.gas_data.molar_masses[g] * group_multiplier
	. *= 0.001

// todo: sort above

//* Getters *//

//Returns the pressure of the gas mix.  Only accurate if there have been no gas modifications since update_values() has been called.
/datum/gas_mixture/proc/return_pressure()
	return (total_moles * R_IDEAL_GAS_EQUATION * temperature) / volume

/**
 * amount of gas of given group
 */
/datum/gas_mixture/proc/moles_by_group(group)
	. = 0
	for(var/id in gas)
		if(global.gas_data.groups[id] & group)
			. += gas[id]

/**
 * amount of gas of given flag
 */
/datum/gas_mixture/proc/moles_by_flag(flag)
	. = 0
	for(var/id in gas)
		if(global.gas_data.flags[id] & flag)
			. += gas[id]

//* Gas Strings *//

/**
  * Copies from a specially formatted gas string, taking on its gas values as our own as well as their temperature.
  * if the gas string does not specify temperature, it'll remain unchanged.
  *
  * @params
  * - gas_string - gas string, atmosphere, etc
  * - turf_context - required for the special atmospheres to look up what zlevel it is
  */
/datum/gas_mixture/proc/parse_gas_string(gas_string, turf/turf_context)
	var/list/parsed = SSair._parse_gas_string(gas_string, turf_context)
	gas = parsed[1]
	gas = gas.Copy()	// why? because we don't want to fuck with cached list.
	if(parsed[2])
		temperature = parsed[2]
	update_values()
	return TRUE

/**
  * Adds from a specially formatted gas string, taking on its gas values as our own as well as their temperature.
  * todo: handle no-temperature?
  */
/datum/gas_mixture/proc/merge_gas_string(gas_string)
	var/datum/gas_mixture/temp = new(volume)
	temp.parse_gas_string(gas_string)
	merge(temp)
	qdel(temp)
	return TRUE

/**
 * Get our gas string
 */
/datum/gas_mixture/proc/get_gas_string()
	return "[list2params(gas)][length(gas)? ";TEMP=[temperature]" : ""]"

/**
 * Get gas string of given list of gas at a given temperature
 */
/proc/get_gas_string(list/gas, temperature)
	if(!length(gas))
		return "TEMP=[TCMB]"
	return "[list2params(gas)];TEMP=[temperature]"

//* Tile Operations *//

/**
 * get the equivalent of a single tile of this gas mixture
 */
/datum/gas_mixture/proc/copy_single_tile()
	RETURN_TYPE(/datum/gas_mixture)
	var/datum/gas_mixture/GM = new(CELL_VOLUME)
	GM.copy_from(src)
	GM.group_multiplier = 1
	return GM

//* Scanning *//

/datum/gas_mixture/proc/chat_analyzer_scan(group_together, molar_masses, exact)
	RETURN_TYPE(/list)
	. = list()
	update_values()
	if(!total_moles)
		. += SPAN_WARNING("Pressure: 0 kPa")
		return
	var/pressure = return_pressure()
	. += SPAN_NOTICE("Pressure: [round(pressure, 0.001)] kPa")
	. += SPAN_NOTICE("Volume: [round(volume, 0.001)] L")
	. += SPAN_NOTICE("Temperature: [round(temperature, 0.001)]&deg;K ([round(temperature - T0C, 0.001)]&deg;C)")
	var/reagents = 0
	var/other = 0
	var/unknown = 0
	var/list/trace_reagent_masses = list()
	var/list/trace_other_masses = list()
	var/list/trace_unknown_masses = list()
	for(var/id in gas)
		var/groups = global.gas_data.groups[id]
		if((groups & GAS_GROUP_REAGENT) && (group_together & GAS_GROUP_REAGENT))
			reagents += gas[id]
			trace_reagent_masses += id
		else if((groups & GAS_GROUP_OTHER) && (group_together & GAS_GROUP_OTHER))
			other += gas[id]
			trace_other_masses += id
		else if((groups & GAS_GROUP_UNKNOWN) && (group_together & GAS_GROUP_UNKNOWN))
			unknown += gas[id]
			trace_unknown_masses += id
		else
			. += SPAN_NOTICE("[global.gas_data.names[id]]: [exact? "[XGM_QUANTIZE(gas[id])] mol @ " : ""][round(gas[id] / total_moles * 100, 0.01)]%[molar_masses? " ([global.gas_data.molar_masses[id]] g/mol)" : ""]")
	if(reagents)
		. += SPAN_NOTICE("Reagents: [exact? "[XGM_QUANTIZE(reagents)] mol @ " : ""][round(reagents / total_moles * 100, 0.01)]%")
		if(molar_masses)
			for(var/id in trace_reagent_masses)
				. += SPAN_NOTICE("[FOURSPACES] - [global.gas_data.names[id]] ([global.gas_data.molar_masses[id]] g/mol)")
	if(other)
		. += SPAN_NOTICE("Other: [exact? "[XGM_QUANTIZE(other)] mol @ " : ""][round(other / total_moles * 100, 0.01)]%")
		if(molar_masses)
			for(var/id in trace_other_masses)
				. += SPAN_NOTICE("[FOURSPACES] - [global.gas_data.names[id]] ([global.gas_data.molar_masses[id]] g/mol)")
	if(unknown)
		. += SPAN_NOTICE("Unknown: [exact? "[XGM_QUANTIZE(unknown)] mol @ " : ""][round(unknown / total_moles * 100, 0.01)]%")
		if(molar_masses)
			for(var/id in trace_unknown_masses)
				. += SPAN_NOTICE("[FOURSPACES] - [global.gas_data.names[id]] ([global.gas_data.molar_masses[id]] g/mol)")


/datum/gas_mixture/proc/tgui_analyzer_scan(group_together, molar_masses)
	. = list()
	var/pressure = return_pressure()
	.["moles"] = total_moles
	.["pressure"] = pressure
	.["temperature"] = temperature
	var/list/gases = list()
	.["gases"] = gases
	var/list/masses = list()
	.["masses"] = masses
	var/list/names = list()
	.["names"] = names
	.["showMoles"] = molar_masses
	for(var/id in gas)
		var/groups = global.gas_data.groups[id]
		names[id] = global.gas_data.names[id]
		if((groups & GAS_GROUP_REAGENT) && (group_together & GAS_GROUP_REAGENT))
			gases["Reagents"] += gas[id]
		else if((groups & GAS_GROUP_OTHER) && (group_together & GAS_GROUP_OTHER))
			gases["Other"] += gas[id]
		else if((groups & GAS_GROUP_UNKNOWN) && (group_together & GAS_GROUP_UNKNOWN))
			gases["Unknown"] += gas[id]
		else
			gases[id] += gas[id]
		if(molar_masses)
			masses[id] = global.gas_data.molar_masses[id]

