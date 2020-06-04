#define MINIMUM_HEAT_CAPACITY	0.0003
#define MINIMUM_MOLE_COUNT		0.01

/**
  * Gas Mixture
  *
  * Gas mixture datums are the primary holder of atmospherics gases used in the code.
  * They contain procs needed to manipulate said gases.
  */
/datum/gas_mixture
	/// List of gases, typepath = volume
	var/list/gases = list()
	/// Gas archive. This is a lazy list only used when needed, to ensure computations are commutative in things like turf/zone gasflow.
	var/tmp/list/gas_archive
	/// Temperature of this mixture in Kelvins
	var/temperature = 0
	/// See [gas_archive]
	var/tmp/temperature_archived = 0
	/// Volume of this mixture in liters
	var/volume = CELL_VOLUME

	var/last_share = 0

	/// Lazy list used for gas reaction results.
	var/list/reaction_results
	/// Lazy list used for gas analyzer feedback.
	var/list/analyzer_results

	var/gc_share = FALSE // Whether to call garbage_collect() on the sharer during shares, used for immutable mixtures

/datum/gas_mixture/New(volume)
	if (!isnull(volume))
		src.volume = volume

/**
  * Updates all archived variables.
  *
  * Use the defines in [code/__DEFINES/atmospherics/helpers.dm] in hot loops/performance critical code!
  */
/datum/gas_mixture/proc/archive()
	INTERNAL_GASMIX_ARCHIVE

/datum/gas_mixture/proc/heat_capacity()

/datum/gas_mixture/proc/archived_heat_capacity()

/datum/gas_mixture/heat_capacity() //joules per kelvin
	var/list/cached_gases = gases
	var/list/cached_gasheats = GLOB.meta_gas_specific_heats
	. = 0
	for(var/id in cached_gases)
		. += cached_gases[id] * cached_gasheats[id]

/datum/gas_mixture/archived_heat_capacity()
	// lots of copypasta but heat_capacity is the single proc called the most in a regular round, bar none, so performance loss adds up
	var/list/cached_gases = gas_archive
	var/list/cached_gasheats = GLOB.meta_gas_specific_heats
	. = 0
	for(var/id in cached_gases)
		. += cached_gases[id] * cached_gasheats[id]

/datum/gas_mixture/turf/heat_capacity() // Same as above except vacuums return HEAT_CAPACITY_VACUUM
	var/list/cached_gases = gases
	var/list/cached_gasheats = GLOB.meta_gas_specific_heats
	for(var/id in cached_gases)
		. += cached_gases[id] * cached_gasheats[id]
	if(!.)
		. += HEAT_CAPACITY_VACUUM //we want vacuums in turfs to have the same heat capacity as space

/datum/gas_mixture/turf/archived_heat_capacity() // Same as above except vacuums return HEAT_CAPACITY_VACUUM
	var/list/cached_gases = gas_archive
	var/list/cached_gasheats = GLOB.meta_gas_specific_heats
	for(var/id in cached_gases)
		. += cached_gases[id] * cached_gasheats[id]
	if(!.)
		. += HEAT_CAPACITY_VACUUM //we want vacuums in turfs to have the same heat capacity as space

/datum/gas_mixture/proc/total_moles()
	var/cached_gases = gases
	TOTAL_MOLES(cached_gases, .)

/datum/gas_mixture/proc/return_pressure() //kilopascals
	if(volume > 0) // to prevent division by zero
		var/cached_gases = gases
		TOTAL_MOLES(cached_gases, .)
		. *= R_IDEAL_GAS_EQUATION * temperature / volume
		return
	return 0

/datum/gas_mixture/proc/return_temperature() //kelvins
	return temperature

/datum/gas_mixture/proc/return_volume() //liters
	return max(0, volume)

/datum/gas_mixture/proc/thermal_energy() //joules
	return THERMAL_ENERGY(src) //see code/__DEFINES/atmospherics.dm; use the define in performance critical areas

/datum/gas_mixture/proc/merge(datum/gas_mixture/giver)
	//Merges all air from giver into self. Deletes giver.
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/copy_from_turf(turf/model)
	//Copies all gas info from the turf into the gas list along with temperature
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/parse_gas_string(gas_string)
	//Copies variables from a particularly formatted string.
	//Returns: 1 if we are mutable, 0 otherwise

/datum/gas_mixture/proc/share(datum/gas_mixture/sharer)
	//Performs air sharing calculations between two gas_mixtures assuming only 1 boundary length
	//Returns: amount of gas exchanged (+ if sharer received)

/datum/gas_mixture/proc/temperature_share(datum/gas_mixture/sharer, conduction_coefficient)
	//Performs temperature sharing calculations (via conduction) between two gas_mixtures assuming only 1 boundary length
	//Returns: new temperature of the sharer

/datum/gas_mixture/proc/compare(datum/gas_mixture/sample)
	//Compares sample to self to see if within acceptable ranges that group processing may be enabled
	//Returns: a string indicating what check failed, or "" if check passes

/datum/gas_mixture/proc/react(turf/open/dump_location)
	//Performs various reactions such as combustion or fusion (LOL)
	//Returns: 1 if any reaction took place; 0 otherwise

/datum/gas_mixture/merge(datum/gas_mixture/giver)
	if(!giver)
		return 0

	//heat transfer
	if(abs(temperature - giver.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/giver_heat_capacity = giver.heat_capacity()
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity)
			temperature = (giver.temperature * giver_heat_capacity + temperature * self_heat_capacity) / combined_heat_capacity

	var/list/cached_gases = gases //accessing datum vars is slower than proc vars
	var/list/giver_gases = giver.gases
	//gas transfer
	for(var/giver_id in giver_gases)
		cached_gases[giver_id] += giver_gases[giver_id]

	return 1

/**
  * Removes the specified amount of moles from the gas_mixture equally from all gases in it.
  * Returns a gas mixture of the base type /datum/gas_mixture with the removed gases in it.
  *
  * @params
  * * amount - Moles to remove
  */
/datum/gas_mixture/proc/remove(amount)
	var/sum
	var/list/cached_gases = gases
	TOTAL_MOLES(cached_gases, sum)
	amount = min(amount, sum) //Can not take more air than gasmix has!
	if(amount <= 0)
		return null
	var/datum/gas_mixture/removed = new
	var/list/removed_gases = removed.gases // accessing datum vars is slower than proc vars

	removed.temperature = temperature
	for(var/id in cached_gases)
		removed_gases[id] = (cached_gases[id] / sum) * amount
		cached_gases[id] -= removed_gases[id]
	GAS_GARBAGE_COLLECT(cached_gases)
	GAS_GARBAGE_COLLECT(removed_gases)

	return removed

/**
  * Removes a ratio from 0 to 1 of gases from the gas_mixture
  * Returns a gas_mixture of the base type /datum/gas_mixture with the removed gases in it.
  *
  * @params
  * * ratio - Ratio of the gasmix from 0 to 1 to remove
  */
/datum/gas_mixture/proc/remove_ratio(ratio)
	if(ratio <= 0)
		return
	ratio = min(ratio, 1)

	var/list/cached_gases = gases
	var/datum/gas_mixture/removed = new /datum/gas_mixture
	var/list/removed_gases = removed.gases // accessing datum vars is slower than proc vars

	removed.temperature = temperature
	for(var/id in cached_gases)
		removed_gases[id] = QUANTIZE(cached_gases[id] * ratio)
		cached_gases[id] -= removed_gases[id]

	GAS_GARBAGE_COLLECT(cached_gases)
	GAS_GARBAGE_COLLECT(remved_gases)

	return removed

/**
  * Returns a copy of ourself.
  * Does NOT set the copy's volume!
  */
/datum/gas_mixture/proc/copy()
	var/list/cached_gases = gases
	var/datum/gas_mixture/copy = new type
	var/list/copy_gases = copy.gases

	copy.temperature = temperature
	for(var/id in cached_gases)
		copy_gases[id] = cached_gases[id]
	return copy


/datum/gas_mixture/copy_from(datum/gas_mixture/sample)
	var/list/cached_gases = gases //accessing datum vars is slower than proc vars
	var/list/sample_gases = sample.gases

	temperature = sample.temperature
	for(var/id in sample_gases)
		cached_gases[id] = sample_gases[id]

	//remove all gases not in the sample
	cached_gases &= sample_gases

	return 1

/datum/gas_mixture/copy_from_turf(turf/model)
	parse_gas_string(model.initial_gas_mix)

	//acounts for changes in temperature
	var/turf/model_parent = model.parent_type
	if(model.temperature != initial(model.temperature) || model.temperature != initial(model_parent.temperature))
		temperature = model.temperature

	return 1

/datum/gas_mixture/parse_gas_string(gas_string)
	var/list/gases = src.gases
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
	archive()
	return 1

/datum/gas_mixture/share(datum/gas_mixture/sharer, atmos_adjacent_turfs = 4)

	var/list/cached_gases = gases
	var/list/sharer_gases = sharer.gases

	var/temperature_delta = temperature_archived - sharer.temperature_archived
	var/abs_temperature_delta = abs(temperature_delta)

	var/old_self_heat_capacity = 0
	var/old_sharer_heat_capacity = 0
	if(abs_temperature_delta > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		old_self_heat_capacity = heat_capacity()
		old_sharer_heat_capacity = sharer.heat_capacity()

	var/heat_capacity_self_to_sharer = 0 //heat capacity of the moles transferred from us to the sharer
	var/heat_capacity_sharer_to_self = 0 //heat capacity of the moles transferred from the sharer to us

	var/moved_moles = 0
	var/abs_moved_moles = 0

	//we're gonna define these vars outside of this for loop because as it turns out, var declaration is pricy
	var/delta
	var/gas_heat_capacity
	//and also cache this shit rq because that results in sanic speed for reasons byond explanation
	var/list/cached_gasheats = GLOB.meta_gas_specific_heats
	//GAS TRANSFER
	for(var/id in cached_gases | sharer_gases) // transfer gases

		delta = QUANTIZE(gas_archive[id] - sharer.gas_archive[id])/(atmos_adjacent_turfs+1) //the amount of gas that gets moved between the mixtures

		if(delta && abs_temperature_delta > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			gas_heat_capacity = delta * cached_gasheats[id]
			if(delta > 0)
				heat_capacity_self_to_sharer += gas_heat_capacity
			else
				heat_capacity_sharer_to_self -= gas_heat_capacity //subtract here instead of adding the absolute value because we know that delta is negative.

		cached_gases[id]					-= delta
		sharer_gases[id]			+= delta
		moved_moles			+= delta
		abs_moved_moles		+= abs(delta)

	last_share = abs_moved_moles

	//THERMAL ENERGY TRANSFER
	if(abs_temperature_delta > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/new_self_heat_capacity = old_self_heat_capacity + heat_capacity_sharer_to_self - heat_capacity_self_to_sharer
		var/new_sharer_heat_capacity = old_sharer_heat_capacity + heat_capacity_self_to_sharer - heat_capacity_sharer_to_self

		//transfer of thermal energy (via changed heat capacity) between self and sharer
		if(new_self_heat_capacity > MINIMUM_HEAT_CAPACITY)
			temperature = (old_self_heat_capacity*temperature - heat_capacity_self_to_sharer*temperature_archived + heat_capacity_sharer_to_self*sharer.temperature_archived)/new_self_heat_capacity

		if(new_sharer_heat_capacity > MINIMUM_HEAT_CAPACITY)
			sharer.temperature = (old_sharer_heat_capacity*sharer.temperature-heat_capacity_sharer_to_self*sharer.temperature_archived + heat_capacity_self_to_sharer*temperature_archived)/new_sharer_heat_capacity
		//thermal energy of the system (self and sharer) is unchanged

			if(abs(old_sharer_heat_capacity) > MINIMUM_HEAT_CAPACITY)
				if(abs(new_sharer_heat_capacity/old_sharer_heat_capacity - 1) < 0.1) // <10% change in sharer heat capacity
					temperature_share(sharer, OPEN_HEAT_TRANSFER_COEFFICIENT)

	if (initial(sharer.gc_share))
		GAS_GARBAGE_COLLECT(sharer.gases)
	if(temperature_delta > MINIMUM_TEMPERATURE_TO_MOVE || abs(moved_moles) > MINIMUM_MOLES_DELTA_TO_MOVE)
		var/our_moles
		TOTAL_MOLES(cached_gases,our_moles)
		var/their_moles
		TOTAL_MOLES(sharer_gases,their_moles)
		return (temperature_archived*(our_moles + moved_moles) - sharer.temperature_archived*(their_moles - moved_moles)) * R_IDEAL_GAS_EQUATION / volume

/datum/gas_mixture/temperature_share(datum/gas_mixture/sharer, conduction_coefficient, sharer_temperature, sharer_heat_capacity)
	//transfer of thermal energy (via conduction) between self and sharer
	if(sharer)
		sharer_temperature = sharer.temperature_archived
	var/temperature_delta = temperature_archived - sharer_temperature
	if(abs(temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = archived_heat_capacity()
		sharer_heat_capacity = sharer_heat_capacity || sharer.archived_heat_capacity()

		if((sharer_heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*temperature_delta* \
				(self_heat_capacity*sharer_heat_capacity/(self_heat_capacity+sharer_heat_capacity))

			temperature = max(temperature - heat/self_heat_capacity, TCMB)
			sharer_temperature = max(sharer_temperature + heat/sharer_heat_capacity, TCMB)
			if(sharer)
				sharer.temperature = sharer_temperature
	return sharer_temperature
	//thermal energy of the system (self and sharer) is unchanged

/datum/gas_mixture/compare(datum/gas_mixture/sample)
	var/list/sample_gases = sample.gases //accessing datum vars is slower than proc vars
	var/list/cached_gases = gases

	for(var/id in cached_gases | sample_gases) // compare gases from either mixture
		var/gas_moles = cached_gases[id]
		var/sample_moles = sample_gases[id]
		var/delta = abs(gas_moles - sample_moles)
		if(delta > MINIMUM_MOLES_DELTA_TO_MOVE && \
			delta > gas_moles * MINIMUM_AIR_RATIO_TO_MOVE)
			return id

	var/our_moles
	TOTAL_MOLES(cached_gases, our_moles)
	if(our_moles > MINIMUM_MOLES_DELTA_TO_MOVE)
		var/temp = temperature
		var/sample_temp = sample.temperature

		var/temperature_delta = abs(temp - sample_temp)
		if(temperature_delta > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND)
			return "temp"

	return ""

/datum/gas_mixture/react(datum/holder)
	. = NO_REACTION
	var/list/cached_gases = gases
	if(!length(cached_gases))
		return
	var/list/reactions = list()
	for(var/datum/gas_reaction/G in SSair.gas_reactions)
		if(cached_gases[G.major_gas])
			reactions += G
	if(!length(reactions))
		return
	reaction_results = new
	var/temp = temperature
	var/ener = THERMAL_ENERGY(src)

	reaction_loop:
		for(var/r in reactions)
			var/datum/gas_reaction/reaction = r

			var/list/min_reqs = reaction.min_requirements
			if((min_reqs["TEMP"] && temp < min_reqs["TEMP"]) \
			|| (min_reqs["ENER"] && ener < min_reqs["ENER"]))
				continue

			for(var/id in min_reqs)
				if (id == "TEMP" || id == "ENER")
					continue
				if(cached_gases[id] < min_reqs[id])
					continue reaction_loop
			//at this point, all minimum requirements for the reaction are satisfied.

			/*	currently no reactions have maximum requirements, so we can leave the checks commented out for a slight performance boost
				PLEASE DO NOT REMOVE THIS CODE. the commenting is here only for a performance increase.
				enabling these checks should be as easy as possible and the fact that they are disabled should be as clear as possible

			var/list/max_reqs = reaction.max_requirements
			if((max_reqs["TEMP"] && temp > max_reqs["TEMP"]) \
			|| (max_reqs["ENER"] && ener > max_reqs["ENER"]))
				continue
			for(var/id in max_reqs)
				if(id == "TEMP" || id == "ENER")
					continue
				if(cached_gases[id] && cached_gases[id][MOLES] > max_reqs[id])
					continue reaction_loop
			//at this point, all requirements for the reaction are satisfied. we can now react()
			*/
			. |= reaction.react(src, holder)
			if (. & STOP_REACTIONS)
				break
	if(.)
		GAS_GARBAGE_COLLECT(gases)

//Takes the amount of the gas you want to PP as an argument
//So I don't have to do some hacky switches/defines/magic strings
//eg:
//Tox_PP = get_partial_pressure(gas_mixture.toxins)
//O2_PP = get_partial_pressure(gas_mixture.oxygen)

/datum/gas_mixture/proc/get_breath_partial_pressure(gas_pressure)
	return (gas_pressure * R_IDEAL_GAS_EQUATION * temperature) / BREATH_VOLUME
//inverse
/datum/gas_mixture/proc/get_true_breath_pressure(partial_pressure)
	return (partial_pressure * BREATH_VOLUME) / (R_IDEAL_GAS_EQUATION * temperature)

//Mathematical proofs:
/*
get_breath_partial_pressure(gas_pp) --> gas_pp/total_moles()*breath_pp = pp
get_true_breath_pressure(pp) --> gas_pp = pp/breath_pp*total_moles()

10/20*5 = 2.5
10 = 2.5/5*20
*/

/**
  * Turf gas mixtures
  */
/datum/gas_mixture/turf





/datum/gas_mixture_old
	//Associative list of gas moles.
	//Gases with 0 moles are not tracked and are pruned by update_values()
	var/list/gas
	//Temperature in Kelvin of this gas mix.
	var/temperature = 0

	//Sum of all the gas moles in this mix.  Updated by update_values()
	var/total_moles = 0
	//Volume of this mix.
	var/volume = CELL_VOLUME
	//Size of the group this gas_mixture is representing.  1 for singletons.
	var/group_multiplier = 1

	//List of active tile overlays for this gas_mixture.  Updated by check_tile_graphic()
	var/list/graphic

/datum/gas_mixture_old/New(vol = CELL_VOLUME)
	volume = vol
	gas = list()


//Same as adjust_gas(), but takes a temperature which is mixed in with the gas.
/datum/gas_mixture_old/proc/adjust_gas_temp(gasid, moles, temp, update = 1)
	if(moles == 0)
		return

	if(moles > 0 && abs(temperature - temp) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/giver_heat_capacity = gas_data.specific_heat[gasid] * moles
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (temp * giver_heat_capacity + temperature * self_heat_capacity) / combined_heat_capacity

	if (group_multiplier != 1)
		gas[gasid] += moles/group_multiplier
	else
		gas[gasid] += moles

	if(update)
		update_values()



//Merges all the gas from another mixture into this one.  Respects group_multipliers and adjusts temperature correctly.
//Does not modify giver in any way.
/datum/gas_mixture_old/proc/merge(const/datum/gas_mixture_old/giver)
	if(!giver)
		return

	if(abs(temperature-giver.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
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
/datum/gas_mixture_old/proc/equalize(datum/gas_mixture_old/sharer)
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	// Special exception: there isn't enough air around to be worth processing this edge next tick, zap both to zero.
	if(total_moles + sharer.total_moles <= MINIMUM_AIR_TO_SUSPEND)
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


//Returns the heat capacity of the gas mix based on the specific heat of the gases.
/datum/gas_mixture_old/proc/heat_capacity()
	. = 0
	for(var/g in gas)
		. += gas_data.specific_heat[g] * gas[g]
	. *= group_multiplier


//Adds or removes thermal energy. Returns the actual thermal energy change, as in the case of removing energy we can't go below TCMB.
/datum/gas_mixture_old/proc/add_thermal_energy(var/thermal_energy)
	if (total_moles == 0)
		return 0

	var/heat_capacity = heat_capacity()
	if (thermal_energy < 0)
		if (temperature < TCMB)
			return 0
		var/thermal_energy_limit = -(temperature - TCMB)*heat_capacity	//ensure temperature does not go below TCMB
		thermal_energy = max( thermal_energy, thermal_energy_limit )	//thermal_energy and thermal_energy_limit are negative here.
	temperature += thermal_energy/heat_capacity
	return thermal_energy

//Returns the thermal energy change required to get to a new temperature
/datum/gas_mixture_old/proc/get_thermal_energy_change(var/new_temperature)
	return heat_capacity()*(max(new_temperature, 0) - temperature)


//Technically vacuum doesn't have a specific entropy. Just use a really big number (infinity would be ideal) here so that it's easy to add gas to vacuum and hard to take gas out.
#define SPECIFIC_ENTROPY_VACUUM		150000


//Returns the ideal gas specific entropy of the whole mix. This is the entropy per mole of /mixed/ gas.
/datum/gas_mixture_old/proc/specific_entropy()
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
/datum/gas_mixture_old/proc/specific_entropy_gas(var/gasid)
	if (!(gasid in gas) || gas[gasid] == 0)
		return SPECIFIC_ENTROPY_VACUUM	//that gas isn't here

	//group_multiplier gets divided out in volume/gas[gasid] - also, V/(m*T) = R/(partial pressure)
	var/molar_mass = gas_data.molar_mass[gasid]
	var/specific_heat = gas_data.specific_heat[gasid]
	return R_IDEAL_GAS_EQUATION * ( log( (IDEAL_GAS_ENTROPY_CONSTANT*volume/(gas[gasid] * temperature)) * (molar_mass*specific_heat*temperature)**(2/3) + 1 ) +  15 )

	//alternative, simpler equation
	//var/partial_pressure = gas[gasid] * R_IDEAL_GAS_EQUATION * temperature / volume
	//return R_IDEAL_GAS_EQUATION * ( log (1 + IDEAL_GAS_ENTROPY_CONSTANT/partial_pressure) + 20 )


/**
  * Remove a specific amount of moles of gas by a given gas_flag.
  *
  * Returns a gas mixture containing the removed air.
  *
  * @params
  * * flag - gas flag to check for
  * * amount - moles to remove
  * * all - If TRUE, all flags have to be on it, rather than just one of the flags specified.
  */
/datum/gas_mixture/proc/remove_by_flag(flag, amount, all = TRUE)
	if(!flag || (amount <= 0))
		return
	var/total_moles = 0
	var/list/gases = src.gases
	var/list/flags = GLOB.meta_gas_flags
	for(var/gasid in gases)
		if(all? ((flags[gasid] & flag) == flag) : (flags[gasid] & flag))
			total_moles += gases[gasid]
	var/datum/gas_mixture/removed = new
	var/list/removed_gases = removed.gases
	for(var/gasid in gases)
		if(all? ((flags[gasid] & flag) == flag) : (flags[gasid] & flag))
			removed_gases[gasid] = (gases[gasid] / total_moles) * amount
			gases[gasid] -= removed_gases[gasid]
	GAS_GARBAGE_COLLECT(gases)
	GAS_GARBAGE_COLLECT(removed_gases)
	return removed


//Checks if we are within acceptable range of another gas_mixture to suspend processing or merge.
/datum/gas_mixture_old/proc/compare(const/datum/gas_mixture_old/sample, var/vacuum_exception = 0)
	if(!sample) return 0

	if(vacuum_exception)
		// Special case - If one of the two is zero pressure, the other must also be zero.
		// This prevents suspending processing when an air-filled room is next to a vacuum,
		// an edge case which is particually obviously wrong to players
		if(total_moles == 0 && sample.total_moles != 0 || sample.total_moles == 0 && total_moles != 0)
			return 0

	var/list/marked = list()
	for(var/g in gas)
		if((abs(gas[g] - sample.gas[g]) > MINIMUM_AIR_TO_SUSPEND) && \
		((gas[g] < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g]) || \
		(gas[g] > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g])))
			return 0
		marked[g] = 1

	for(var/g in sample.gas)
		if(!marked[g])
			if((abs(gas[g] - sample.gas[g]) > MINIMUM_AIR_TO_SUSPEND) && \
			((gas[g] < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g]) || \
			(gas[g] > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g])))
				return 0

	if(total_moles > MINIMUM_AIR_TO_SUSPEND)
		if((abs(temperature - sample.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) && \
		((temperature < (1 - MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature) || \
		(temperature > (1 + MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature)))
			return 0

	return 1


/datum/gas_mixture_old/proc/react()
	zburn(null, force_burn=0, no_check=0) //could probably just call zburn() here with no args but I like being explicit.


//Rechecks the gas_mixture and adjusts the graphic list if needed.
//Two lists can be passed by reference if you need know specifically which graphics were added and removed.
/datum/gas_mixture_old/proc/check_tile_graphic(list/graphic_add = null, list/graphic_remove = null)
	var/list/cur_graphic = graphic // Cache for sanic speed
	for(var/g in gas_data.overlay_limit)
		if(cur_graphic && cur_graphic.Find(gas_data.tile_overlay[g]))
			//Overlay is already applied for this gas, check if it's still valid.
			if(gas[g] <= gas_data.overlay_limit[g])
				LAZYADD(graphic_remove, gas_data.tile_overlay[g])
		else
			//Overlay isn't applied for this gas, check if it's valid and needs to be added.
			if(gas[g] > gas_data.overlay_limit[g])
				LAZYADD(graphic_add, gas_data.tile_overlay[g])

	. = 0
	//Apply changes
	if(LAZYLEN(graphic_add))
		LAZYADD(graphic, graphic_add)
		. = 1
	if(LAZYLEN(graphic_remove))
		LAZYREMOVE(graphic, graphic_remove)
		. = 1

//Shares gas with another gas_mixture based on the amount of connecting tiles and a fixed lookup table.
/datum/gas_mixture_old/proc/share_ratio(datum/gas_mixture_old/other, connecting_tiles, share_size = null, one_way = 0)
	var/static/list/sharing_lookup_table = list(0.30, 0.40, 0.48, 0.54, 0.60, 0.66)
	//Shares a specific ratio of gas between mixtures using simple weighted averages.
	var/ratio = sharing_lookup_table[6]

	var/size = max(1, group_multiplier)
	if(isnull(share_size)) share_size = max(1, other.group_multiplier)

	var/full_heat_capacity = heat_capacity()
	var/s_full_heat_capacity = other.heat_capacity()

	var/list/avg_gas = list()

	for(var/g in gas)
		avg_gas[g] += gas[g] * size

	for(var/g in other.gas)
		avg_gas[g] += other.gas[g] * share_size

	for(var/g in avg_gas)
		avg_gas[g] /= (size + share_size)

	var/temp_avg = 0
	if(full_heat_capacity + s_full_heat_capacity)
		temp_avg = (temperature * full_heat_capacity + other.temperature * s_full_heat_capacity) / (full_heat_capacity + s_full_heat_capacity)

	//WOOT WOOT TOUCH THIS AND YOU ARE AN IDIOT.
	if(sharing_lookup_table.len >= connecting_tiles) //6 or more interconnecting tiles will max at 42% of air moved per tick.
		ratio = sharing_lookup_table[connecting_tiles]
	//WOOT WOOT TOUCH THIS AND YOU ARE AN IDIOT

	for(var/g in avg_gas)
		gas[g] = max(0, (gas[g] - avg_gas[g]) * (1 - ratio) + avg_gas[g])
		if(!one_way)
			other.gas[g] = max(0, (other.gas[g] - avg_gas[g]) * (1 - ratio) + avg_gas[g])

	temperature = max(0, (temperature - temp_avg) * (1-ratio) + temp_avg)
	if(!one_way)
		other.temperature = max(0, (other.temperature - temp_avg) * (1-ratio) + temp_avg)

	update_values()
	other.update_values()

	return compare(other)


//A wrapper around share_ratio for spacing gas at the same rate as if it were going into a large airless room.
/datum/gas_mixture_old/proc/share_space(datum/gas_mixture_old/unsim_air)
	return share_ratio(unsim_air, unsim_air.group_multiplier, max(1, max(group_multiplier + 3, 1) + unsim_air.group_multiplier), one_way = 1)


//Equalizes a list of gas mixtures.  Used for pipe networks.
/proc/equalize_gases(datum/gas_mixture_old/list/gases)
	//Calculate totals from individual components
	var/total_volume = 0
	var/total_thermal_energy = 0
	var/total_heat_capacity = 0

	var/list/total_gas = list()
	for(var/datum/gas_mixture_old/gasmix in gases)
		total_volume += gasmix.volume
		var/temp_heatcap = gasmix.heat_capacity()
		total_thermal_energy += gasmix.temperature * temp_heatcap
		total_heat_capacity += temp_heatcap
		for(var/g in gasmix.gas)
			total_gas[g] += gasmix.gas[g]

	if(total_volume > 0)
		var/datum/gas_mixture_old/combined = new(total_volume)
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
		for(var/datum/gas_mixture_old/gasmix in gases)
			gasmix.gas = combined.gas.Copy()
			gasmix.temperature = combined.temperature
			gasmix.multiply(gasmix.volume)

	return 1

/**
  * Parses and copies itself from a specially formatted string.
  */
/datum/gas_mixture_old/proc/parse_gas_string(gas_string)
	var/list/gases = src.gases
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
	return TRUE
