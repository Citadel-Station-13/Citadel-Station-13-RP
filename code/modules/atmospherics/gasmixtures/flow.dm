//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * @params
 * * source - mixture to pump from
 * * sink - mixture to pump into
 * * limit_moles - if set, only pump this many moles of gas at most
 * * limit_power - power limit in joules
 */
/proc/xgm_pump_gas(datum/gas_mixture/source, datum/gas_mixture/sink, limit_moles, limit_power)
	// not enough to pump
	if(source.total_moles < MINIMUM_MOLES_TO_PUMP)
		return 0

	var/specific_power = calculate_specific_power(source, sink) / ATMOS_ABSTRACT_PUMP_EFFICIENCY
	limit_moles = isnull(limit_moles)? source.total_moles : min(limit_moles, source.total_moles)
	if(!isnull(limit_power) && (specific_power > 0))
		limit_moles = min(limit_moles, limit_power / specific_power)

	if(limit_moles < MINIMUM_MOLES_TO_PUMP)
		return

	sink.merge(source.remove(limit_moles))

	return specific_power * limit_moles

/**
 * @params
 * * source - mixture to scrub
 * * sink - mixture to scrub into
 * * gas_ids - list of gas ids to scrub
 * * gas_groups - list of gas groups to scrub
 * * limit_moles - if set, only scrubs this many moles of gas at most
 * * limit_power - power limit in joules
 *
 * @return power draw
 */
/proc/xgm_scrub_gas(datum/gas_mixture/source, datum/gas_mixture/sink, list/gas_ids, gas_groups, limit_moles, limit_power)
	// not enough to scrub
	if(source.total_moles < MINIMUM_MOLES_TO_SCRUB)
		return 0

	// get actually existing gas
	var/list/filtered_ids
	if(gas_groups)
		filtered_ids = list()
		// sigh; iterate through source
		for(var/id in source.gas)
			if(global.gas_data.groups[id] & gas_groups)
				filtered_ids += id
		// then get the explicitly filtered ones if needed
		if(length(gas_ids))
			filtered_ids |= (source.gas & gas_ids)
	else if(length(gas_ids))
		filtered_ids = gas_ids & source.gas

	// gather
	var/total_filterable_moles = 0
	var/total_specific_power = 0
	for(var/id in filtered_ids)
		if(source.gas[id] < MINIMUM_MOLES_TO_SCRUB)
			continue
		total_filterable_moles += source.gas[id]
		total_specific_power += calculate_specific_power_gas(id, source, sink)
	total_specific_power /= ATMOS_ABSTRACT_SCRUB_EFFICIENCY

	// limit by both moles and power
	limit_moles = isnull(limit_moles)? total_filterable_moles : min(limit_moles, total_filterable_moles)
	if(!isnull(limit_power) && (total_specific_power > 0))
		limit_moles = min(limit_moles, limit_power / total_specific_power)

	// can't transfer enough
	if(limit_moles < MINIMUM_MOLES_TO_SCRUB)
		return 0

	// unlike in the other procs, ratio here is the amount we can filter vs the amount there is to filter
	var/ratio = limit_moles / total_filterable_moles

	// do the actual scrubbing
	for(var/id in filtered_ids)
		var/transfer = source.gas[id] * ratio
		source.adjust_gas(id, -transfer, FALSE)
		sink.adjust_gas_temp(id, transfer, source.temperature, FALSE)

	// update values
	source.update_values()
	sink.update_values()

	// return power used in J
	return limit_moles * total_specific_power

/**
 * @params
 * * source - mixture to scrub
 * * sink - mixture to scrub into
 * * gas_ids - list of gas ids to scrub
 * * gas_groups - list of gas groups to scrub
 * * limit_flow - if set, only scrubs this many liters of gas at most from source. this does *NOT* respect group multiplier.
 * * limit_power - power limit in joules
 * * mole_boost - ignore limit_flow to filter atleast this many moles. This is so it doesn't take too long to scrub.
 *
 * @return power draw
 */
/proc/xgm_scrub_gas_volume(datum/gas_mixture/source, datum/gas_mixture/sink, list/gas_ids, gas_groups, limit_flow, limit_power, mole_boost)
	// not enough to scrub
	if(source.total_moles < MINIMUM_MOLES_TO_SCRUB)
		return 0

	// get actually existing gas
	var/list/filtered_ids
	if(gas_groups)
		filtered_ids = list()
		// sigh; iterate through source
		for(var/id in source.gas)
			if(global.gas_data.groups[id] & gas_groups)
				filtered_ids += id
		// then get the explicitly filtered ones if needed
		if(length(gas_ids))
			filtered_ids |= (source.gas & gas_ids)
	else if(length(gas_ids))
		filtered_ids = gas_ids & source.gas

	// gather
	var/total_filterable_moles = 0
	var/total_specific_power = 0
	for(var/id in filtered_ids)
		if(source.gas[id] < MINIMUM_MOLES_TO_SCRUB)
			continue
		total_filterable_moles += source.gas[id]
		total_specific_power += calculate_specific_power_gas(id, source, sink)
	total_specific_power /= ATMOS_ABSTRACT_SCRUB_EFFICIENCY

	// limit by both moles and power
	var/limit_moles = isnull(limit_flow)? total_filterable_moles : min(max(mole_boost, total_filterable_moles * (limit_flow / source.volume)), total_filterable_moles)
	if(!isnull(limit_power) && (total_specific_power > 0))
		limit_moles = min(limit_moles, limit_power / total_specific_power)

	// can't transfer enough
	if(limit_moles < MINIMUM_MOLES_TO_SCRUB)
		return 0

	// unlike in the other procs, ratio here is the amount we can filter vs the amount there is to filter
	var/ratio = limit_moles / total_filterable_moles

	// do the actual scrubbing
	for(var/id in filtered_ids)
		var/transfer = source.gas[id] * ratio
		source.adjust_gas(id, -transfer, FALSE)
		sink.adjust_gas_temp(id, transfer, source.temperature, FALSE)

	// update values
	source.update_values()
	sink.update_values()

	// return power used in J
	return limit_moles * total_specific_power

/**
 * @params
 * * source - mixture to filter
 * * sink - mixture to send unfiltered gas into
 * * divert - mixture to send filtered gas into
 * * to_filter - what to filter, either a gas id or a set of gas groups.
 * * limit_moles - if set, only scrubs this many moles of gas at most
 * * limit_power - power limit in joules
 *
 * @return power draw
 */
/proc/xgm_filter_gas(datum/gas_mixture/source, datum/gas_mixture/sink, datum/gas_mixture/divert, to_filter, limit_moles, limit_power)
	// not enough to filter
	if(source.total_moles < MINIMUM_MOLES_TO_FILTER)
		return 0

	// gather - faster than scrub
	var/filterable_moles = 0
	var/list/filter_ids
	if(isnum(to_filter))
		// groups
		filter_ids = list()
		for(var/id in source.gas)
			if(global.gas_data.groups[id] & to_filter)
				filterable_moles += source.gas[id]
				filter_ids += id
		if(!length(filter_ids))
			// not there
			return xgm_pump_gas(source, sink, limit_moles, limit_power)
	else
		// ids
		if(!(source.gas[to_filter]))
			// not there
			return xgm_pump_gas(source, sink, limit_moles, limit_power)
		filter_ids = list(to_filter)
		filterable_moles = source.gas[to_filter]

	// calculate work per mole moved through filter, diverting as necessary
	var/total_specific_power = 0
	var/list/not_filtered = source.gas - filter_ids
	for(var/id in not_filtered)
		total_specific_power += calculate_specific_power_gas(id, source, sink) * source.gas[id] / source.total_moles
	for(var/id in filter_ids)
		total_specific_power += calculate_specific_power_gas(id, source, divert) * source.gas[id] / source.total_moles
	total_specific_power /= ATMOS_ABSTRACT_FILTER_EFFICIENCY

	// limit
	limit_moles = isnull(limit_moles)? source.total_moles : min(limit_moles, source.total_moles)
	if(!isnull(limit_power) && (total_specific_power > 0))
		limit_moles = min(limit_moles, limit_power / total_specific_power)

	var/ratio = limit_moles / source.total_moles

	// not enough to filter
	if(limit_moles < MINIMUM_MOLES_TO_FILTER)
		return 0

	// transfer
	for(var/id in filter_ids)
		var/transfer = source.gas[id] * ratio
		source.adjust_gas(id, -transfer, FALSE)
		divert.adjust_gas_temp(id, transfer, source.temperature, FALSE)
	for(var/id in not_filtered)
		var/transfer = source.gas[id] * ratio
		source.adjust_gas(id, -transfer, FALSE)
		sink.adjust_gas_temp(id, transfer, source.temperature, FALSE)

	// update values
	source.update_values()
	sink.update_values()
	divert.update_values()

	// return power used in J
	return limit_moles * total_specific_power

/**
 * @params
 * * source - mixture to filter
 * * sink - mixture to send unfiltered gas into
 * * filtering - gas ids associated to mixtures to send them to.
 * * limit_moles - if set, only scrubs this many moles of gas at most
 * * limit_power - power limit in joules
 *
 * @return power draw
 */
/proc/xgm_multi_filter_gas_specific(datum/gas_mixture/source, datum/gas_mixture/sink, list/filtering, limit_moles, limit_power)
	// not enough to filter
	if(source.total_moles < MINIMUM_MOLES_TO_FILTER)
		return 0

	// nothing to filter
	if(!length(filtering))
		return xgm_pump_gas(source, sink, limit_moles, limit_power)

	// gather - faster than scrub
	var/filterable_moles = 0
	var/total_specific_power = 0
	var/list/not_filtered = source.gas - filtering
	for(var/id in filtering)
		filterable_moles[id] += source.gas[id]
		total_specific_power += calculate_specific_power_gas(id, source, filtering[id]) * source.gas[id] / source.total_moles
	for(var/id in not_filtered)
		total_specific_power += calculate_specific_power_gas(id, source, sink) * source.gas[id] / source.total_moles
	total_specific_power /= ATMOS_ABSTRACT_FILTER_EFFICIENCY

	// limit
	limit_moles = isnull(limit_moles)? source.total_moles : min(limit_moles, source.total_moles)
	if(!isnull(limit_power) && (total_specific_power > 0))
		limit_moles = min(limit_moles, limit_power / total_specific_power)

	var/ratio = limit_moles / source.total_moles

	// not enough to filter
	if(limit_moles < MINIMUM_MOLES_TO_FILTER)
		return 0

	// transfer
	for(var/id in filtering)
		var/transfer = source.gas[id] * ratio
		source.adjust_gas(id, -transfer, FALSE)
		var/datum/gas_mixture/divert = filtering[id]
		// update immediately, we don't have overlap most of the time.
		divert.adjust_gas_temp(id, transfer, source.temperature, TRUE)
	for(var/id in not_filtered)
		var/transfer = source.gas[id] * ratio
		source.adjust_gas(id, -transfer, FALSE)
		sink.adjust_gas_temp(id, transfer, source.temperature, FALSE)

	// update values
	source.update_values()
	sink.update_values()

	// return power used in J
	return limit_moles * total_specific_power

/**
 * @params
 * * source - mixture to filter
 * * sink - mixture to send unfiltered gas into
 * * divert - mixture to send filtered gas into; this is anything with molar mass between lower and upper, inclusive
 * * lower - lower bound of target in kg/mol
 * * upper - upper bound of target in kg/mol
 * * limit_moles - if set, only scrubs this many moles of gas at most
 * * limit_power - power limit in joules
 *
 * @return power draw
 */
/proc/xgm_molar_filter_gas(datum/gas_mixture/source, datum/gas_mixture/sink, datum/gas_mixture/divert, lower, upper, limit_moles, limit_power)
	// not enough to filter
	if(source.total_moles < MINIMUM_MOLES_TO_FILTER)
		return 0

	// gather - faster than scrub
	var/filterable_moles = 0
	var/list/filter_ids = list()
	for(var/id in source.gas)
		var/mass = global.gas_data.molar_masses[id]
		if(lower > mass || upper < mass)
			continue
		filterable_moles += source.gas[id]
		filter_ids += id

	// calculate work per mole moved through filter, diverting as necessary
	var/total_specific_power = 0
	var/list/not_filtered = source.gas - filter_ids
	for(var/id in not_filtered)
		total_specific_power += calculate_specific_power_gas(id, source, sink) * source.gas[id] / source.total_moles
	for(var/id in filter_ids)
		total_specific_power += calculate_specific_power_gas(id, source, divert) * source.gas[id] / source.total_moles
	total_specific_power /= ATMOS_ABSTRACT_FILTER_EFFICIENCY

	// limit
	limit_moles = isnull(limit_moles)? source.total_moles : min(limit_moles, source.total_moles)
	if(!isnull(limit_power) && (total_specific_power > 0))
		limit_moles = min(limit_moles, limit_power / total_specific_power)

	var/ratio = limit_moles / source.total_moles

	// not enough to filter
	if(limit_moles < MINIMUM_MOLES_TO_FILTER)
		return 0

	// transfer
	for(var/id in filter_ids)
		var/transfer = source.gas[id] * ratio
		source.adjust_gas(id, -transfer, FALSE)
		divert.adjust_gas_temp(id, transfer, source.temperature, FALSE)
	for(var/id in not_filtered)
		var/transfer = source.gas[id] * ratio
		source.adjust_gas(id, -transfer, FALSE)
		sink.adjust_gas_temp(id, transfer, source.temperature, FALSE)

	// update values
	source.update_values()
	sink.update_values()
	divert.update_values()

	// return power used in J
	return limit_moles * total_specific_power
