/datum/gas_mixture
	//Associative list of gas moles.
	//Gases with 0 moles are not tracked and are pruned by update_values()
	var/list/gas
	//Temperature in Kelvin of this gas mix.
	var/temperature = 0

	//Sum of all the gas moles in this mix.  Updated by update_values()
	// DO NOT USE - Planned to be phased out. Use TOTAL_MOLES().
	var/total_moles = 0
	//Volume of this mix.
	var/volume = CELL_VOLUME
	//Size of the group this gas_mixture is representing.  1 for singletons.
	var/group_multiplier = 1

	//List of active tile overlays for this gas_mixture.  Updated by check_tile_graphic()
	var/list/graphic

/datum/gas_mixture/New(vol = CELL_VOLUME)
	volume = vol
	gas = list()

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
	var/giver_heat_capacity = GLOB.meta_gas_specific_heats[gasid] * moles

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


// Used to equalize the mixture between two zones before sleeping an edge.
/datum/gas_mixture/proc/equalize(datum/gas_mixture/sharer)
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	// Special exception: there isn't enough air around to be worth processing this edge next tick, zap both to zero.
	if(total_moles + sharer.total_moles <= MINIMUM_MOLES_TO_DISSIPATE)
		gas.Cut()
		sharer.gas.Cut()

	for(var/g in gas|sharer.gas)
		var/comb = gas[g] + sharer.gas[g]
		comb /= volume + sharer.volume
		gas[g] = comb * volume
		sharer.gas[g] = comb * sharer.volume

	if(our_heatcap + share_heatcap)
		temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
	sharer.temperature = temperature

	update_values()
	sharer.update_values()

	return 1

// todo: check above

//! Thermodynamics
/**
 * Returns the heat capacity of the gas mix based on the specific heat of the gases and their moles.
 *
 * takes group_multiplier into account.
 */
/datum/gas_mixture/proc/heat_capacity()
	. = 0
	for(var/g in gas)
		. += GLOB.meta_gas_specific_heats[g] * gas[g]
	. *= group_multiplier

/**
 * gets total thermal energy, taking into account group multiplier
 */
/datum/gas_mixture/proc/thermal_energy()
	return heat_capacity() * temperature

/**
 * adjusts thermal energy in joules
 *
 * returns amount changed, so we can't go below TCMB; **amount changed is not absolute value**, e.g. inputting -10 will net you returned -10.
 */
/datum/gas_mixture/proc/adjust_thermal_energy(joules)
	if(!total_moles)
		return 0
	var/capacity = heat_capacity()
	if(joules < 0)
		joules = max(joules, -(temperature - TCMB) * capacity)
	temperature += joules / capacity
	return joules

/**
 * returns thermal energy change in joules to get to a certain temperature
 */
/datum/gas_mixture/proc/get_thermal_energy_change(target)
	return heat_capacity() * (max(target, 0) - temperature)

// todo: check below



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
	var/molar_mass = GLOB.meta_gas_molar_mass[gasid]
	var/specific_heat = GLOB.meta_gas_specific_heats[gasid]
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

//Returns the pressure of the gas mix.  Only accurate if there have been no gas modifications since update_values() has been called.
/datum/gas_mixture/proc/return_pressure()
#ifdef GASMIXTURE_ASSERTIONS
	ASSERT(volume > 0)
#endif
	return (total_moles * R_IDEAL_GAS_EQUATION * temperature) / volume

//Removes moles from the gas mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove(amount)
	amount = min(amount, total_moles * group_multiplier) //Can not take more air than the gas mixture has!
	if(amount <= 0)
		return null

	var/datum/gas_mixture/removed = new

	for(var/g in gas)
		removed.gas[g] = QUANTIZE((gas[g] / total_moles) * amount)
		gas[g] -= removed.gas[g] / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed


//Removes a ratio of gas from the mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove_ratio(ratio, out_group_multiplier = 1)
	if(ratio <= 0)
		return null
	out_group_multiplier = clamp( out_group_multiplier, 1,  group_multiplier)

	ratio = min(ratio, 1)

	var/datum/gas_mixture/removed = new
	removed.group_multiplier = out_group_multiplier

	for(var/g in gas)
		removed.gas[g] = (gas[g] * ratio * group_multiplier / out_group_multiplier)
		gas[g] = gas[g] * (1 - ratio)

	removed.temperature = temperature
	removed.volume = volume * group_multiplier / out_group_multiplier
	update_values()
	removed.update_values()

	return removed

//Removes a volume of gas from the mixture and returns a gas_mixture containing the removed air with the given volume
/datum/gas_mixture/proc/remove_volume(removed_volume)
	var/datum/gas_mixture/removed = remove_ratio(removed_volume/(volume*group_multiplier), 1)
	removed.volume = removed_volume
	return removed

//Removes moles from the gas mixture, limited by a given flag.  Returns a gax_mixture containing the removed air.
/datum/gas_mixture/proc/remove_by_flag(flag, amount)
	if(!flag || amount <= 0)
		return

	var/sum = 0
	for(var/g in gas)
		if(GLOB.meta_gas_flags[g] & flag)
			sum += gas[g]

	var/datum/gas_mixture/removed = new

	for(var/g in gas)
		if(GLOB.meta_gas_flags[g] & flag)
			removed.gas[g] = QUANTIZE((gas[g] / sum) * amount)
			gas[g] -= removed.gas[g] / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed

//Returns the amount of gas that has the given flag, in moles
/datum/gas_mixture/proc/get_by_flag(flag)
	. = 0
	for(var/g in gas)
		if(GLOB.meta_gas_flags[g] & flag)
			. += gas[g]

//Copies gas and temperature from another gas_mixture.
/datum/gas_mixture/proc/copy_from(const/datum/gas_mixture/sample)
	gas = sample.gas.Copy()
	temperature = sample.temperature

	update_values()

	return 1


//Checks if we are within acceptable range of another gas_mixture to suspend processing or merge.
// returns TRUE if we are considered equal enough
/datum/gas_mixture/proc/compare(datum/gas_mixture/sample, var/vacuum_exception = 0)
	if(!sample)
		return FALSE

	// check vacuum exception bullshit
	if(vacuum_exception && ((!total_moles) ^ (!sample.total_moles)))
		return FALSE

	// check temperature
	if(abs(temperature - sample.temperature) >= MINIMUM_MEANINGFUL_TEMPERATURE_DELTA)
		return FALSE

	// check moles
	for(var/id in gas)
		if(abs(gas[id] - sample.gas[id]) >= MINIMUM_MEANINGFUL_MOLES_DELTA)
			return FALSE

	// check pressure
	return abs(return_pressure() - sample.return_pressure()) < MINIMUM_MEANINGFUL_PRESSURE_DELTA

/**
 * checks if we are within acceptable like-ness of a virtual gas data struct to suspend processing or merge
 *
 * @return TRUE if we are equal enough, otherwise FALSE
 */
/datum/gas_mixture/proc/compare_virtual(list/gases, volume, temperature)
	// check temperature
	if(abs(src.temperature - temperature) > MINIMUM_MEANINGFUL_TEMPERATURE_DELTA)
		return FALSE

	// check moles
	for(var/id in gas)
		if(abs(gases[id] - gas[id]) > MINIMUM_MEANINGFUL_MOLES_DELTA)
			return FALSE

	// check pressure
	var/their_pressure = 0
	for(var/id in gases)
		their_pressure += gases[id]
	their_pressure = (their_pressure * R_IDEAL_GAS_EQUATION * temperature) / volume
	return abs(return_pressure() - their_pressure) < MINIMUM_MEANINGFUL_PRESSURE_DELTA

/datum/gas_mixture/proc/react()
	zburn(null, force_burn=0, no_check=0) //could probably just call zburn() here with no args but I like being explicit.

/**
  * Returns a list of vis_contents graphics for the gases we contain.
  */
/datum/gas_mixture/proc/get_turf_graphics()
	. = list()
	var/list/gases = src.gas
	var/list/no_overlay_typecache = GLOB.meta_gas_typecache_no_overlays
	for(var/id in gases)
		if(no_overlay_typecache[id])
			continue
		var/moles = gases[id]
		var/list/gas_overlays = GLOB.meta_gas_overlays[id]
		if(gas_overlays && moles > GLOB.meta_gas_visibility[id])
			. += gas_overlays[min(FACTOR_GAS_VISIBLE_MAX, CEILING(moles / MOLES_GAS_VISIBLE_STEP, 1))]
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

	return 1

/**
  * Sets our gas/temperature equal to a turf's initial gas mix.
  */
/datum/gas_mixture/proc/copy_from_turf(turf/model)
	parse_gas_string(model.initial_gas_mix)

	//acounts for changes in temperature
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

/datum/gas_mixture/proc/get_mass()
	for(var/g in gas)
		. += gas[g] * GLOB.meta_gas_molar_mass[g] * group_multiplier

// todo: sort above

//! Gas Strings

/**
  * Copies from a specially formatted gas string, taking on its gas values as our own as well as their temperature.
  */
/datum/gas_mixture/proc/parse_gas_string(gas_string)
	gas_string = SSair.preprocess_gas_string(gas_string)
	var/list/gases = src.gas
	var/list/gas = params2list(gas_string)
	if(gas["TEMP"])
		temperature = text2num(gas["TEMP"])
		gas -= "TEMP"
	gases.Cut()
	for(var/id in gas)
		var/path = id
		if(!ispath(path))
			path = gas_id2path(path) //a lot of these strings can't have embedded expressions (especially for mappers), so support for IDs needs to stick around
		gases[path] = text2num(gas[id])
	//archive()
	update_values()
	return TRUE

/**
  * Adds from a specially formatted gas string, taking on its gas values as our own as well as their temperature.
  */
/datum/gas_mixture/proc/merge_gas_string(gas_string)
	var/datum/gas_mixture/temp = new(volume)
	temp.parse_gas_string(gas_string)
	merge(temp)
	qdel(temp)
	return TRUE

//! Tile Operations
/**
 * get the equivalent of a single tile of this gas mixture
 *
 * TODO: remove group_multiplier, change to tiles_represented
 */
/datum/gas_mixture/proc/copy_single_tile()
	RETURN_TYPE(/datum/gas_mixture)
	var/datum/gas_mixture/GM = new(CELL_VOLUME)
	GM.copy_from(src)
	GM.group_multiplier = 1
	return GM

//! Sharing; usually used for environmental systems.
/**
 * Default share gas implementation - shares with another gas_mixture non-canonically
 * based on connecting tiles. Is just a wrapper to use a lookup table.
 */
/datum/gas_mixture/proc/default_share_ratio(datum/gas_mixture/other, tiles)
#ifdef GASMIXTURE_ASSERTIONS
	ASSERT(tiles > 0)
#endif
	var/static/list/lookup_table = list(
		0.3,
		0.4,
		0.48,
		0.54,
		0.6,
		0.66
	)
	if(tiles <= 0)
		CRASH("sharing with tiles < 0 is a waste of time")
	return share_ratio(other, lookup_table[min(tiles, 6)])

/**
 * Shares a ratio of the combined gas of two gas mixtures
 *
 * non canonical, e.g. A shares with B --> A shares with C != A shares with C --> A shares with B
 *
 * this also assumes equal
 */
/datum/gas_mixture/proc/share_ratio(datum/gas_mixture/other, ratio)
#ifdef GASMIXTURE_ASSERTIONS
	ASSERT(ratio > 0 && ratio <= 1)
	// todo: volume based, not group multiplier based. is it worth it?
	ASSERT(volume == other.volume)
#endif
	// collect
	var/list/their_gas = other.gas
	var/list/our_gas = gas

	var/our_size = src.group_multiplier
	var/their_size = other.group_multiplier
	var/total_size = our_size + their_size

	var/our_capacity = heat_capacity()
	var/their_capacity = heat_capacity()

	// compute
	var/list/avg_gas = list()
	for(var/id in our_gas)
		avg_gas[id] += our_gas[id] * our_size

	for(var/id in their_gas)
		avg_gas[id] += their_gas[id] * their_size

	for(var/id in avg_gas)
		avg_gas[id] /= total_size

	// equalize
	var/intact_ratio = 1 - ratio
	var/avg_amt
	for(var/id in avg_gas)
		// set moles by ratio
		// lists are cached, so directly set
		avg_amt = avg_gas[id]
		// i don't know what these do but they work (probably)
		our_gas[id] = (our_gas[id] - avg_amt) * intact_ratio + avg_amt
		their_gas[id] = (their_gas[id] - avg_amt) * intact_ratio + avg_amt

	// update
	update_values()
	other.update_values()
	
	// if empty
	if(!total_moles)
		return compare(other)

	// thermodynamics:
	// i don't know what these do but they work (probably)
	var/avg_temperature = (temperature * our_capacity + other.temperature * their_capacity) / (our_capacity + their_capacity)
	temperature = (temperature - avg_temperature) * intact_ratio + avg_temperature
	other.temperature = (other.temperature - avg_temperature) * intact_ratio + avg_temperature

	// return if we equalized fully
	return compare(other)

/**
 * default implementation to equalize with an unsimulated space
 * by default, this will ramp up equalization to match our room, so we can't
 * overpower say, 1 tile of unsimulated with a massive room.
 */
/datum/gas_mixture/proc/default_share_unsimulated(datum/gas_mixture/unsimulated)
	var/static/list/sharing_lookup_table = list(0.30, 0.40, 0.48, 0.54, 0.60, 0.66)
	var/computed_multiplier = max(group_multiplier, unsimulated.group_multiplier)
	return share_virtual(unsimulated.gas, computed_multiplier, unsimulated.temperature, sharing_lookup_table[min(unsimulated.group_multiplier, 6)])

/**
 * equalizes x% of our gas with an unsimulated mixture.
 *
 * ! warning: this assumes the virtual mixture is the same volume as us, for optimization
 *
 * @params
 * - gases - gases of the other mixture
 * - group_multiplier - how big the other mixture is pretending to be
 * - temperature - how hot the other mixture is
 * - ratio - how much of the **total** mixture will be equalized
 */
/datum/gas_mixture/proc/share_virtual(list/gases, group_multiplier, temperature, ratio)
#ifdef GASMIXTURE_ASSERTIONS
	ASSERT(ratio > 0 && ratio <= 1)
	ASSERT(temperature >= TCMB)
	ASSERT(group_multiplier >= 1)
#endif
	// let's not break the input list
	//! IF YOU DO NOT KNOW WHY WE ARE COPYING, DO NOT TAKE THIS OUT.
	gases = gases.Copy()
	// collect
	var/list/our_gas = gas
	var/our_capacity = heat_capacity()

	// compute
	var/their_capacity = 0
	for(var/id in gases)
		// in the same loop, we'll calculate their total capacity, at the same time expanding their moles to the true value
		their_capacity += GLOB.meta_gas_specific_heats[id] * gases[id] * group_multiplier
		gases[id] *= group_multiplier

	for(var/id in our_gas)
		// now add ours
		gases[id] += our_gas[id] * src.group_multiplier

	for(var/id in gases)
		// now shrink to the average
		gases[id] /= (src.group_multiplier + group_multiplier)

	// update
	update_values()
	
	if(!total_moles)
		return compare_virtual(gases, src.volume, temperature)

	// calculate avg temperature
	var/avg_temperature = (src.temperature * our_capacity + temperature * their_capacity) / (our_capacity + their_capacity)

	// equalize
	var/intact_ratio = 1 - ratio
	var/avg_amt
	for(var/id in gases)
		// set moles by ratio
		// lists are cached, so directly set
		avg_amt = gases[id]
		// i don't know what these do but they work (probably)
		our_gas[id] = (our_gas[id] - avg_amt) * intact_ratio + avg_amt

	// thermodynamics:
	// i don't know what these do but they work (probably)
	src.temperature = (src.temperature - avg_temperature) * intact_ratio + avg_temperature

	// return if we equalized fully
	return compare_virtual(gases, src.volume, temperature)
