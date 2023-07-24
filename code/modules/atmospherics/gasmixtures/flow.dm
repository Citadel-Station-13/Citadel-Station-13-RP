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
	if(!isnull(limit_power))
		limit_moles = min(limit_moles, specific_power / limit_power)

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
			filtered_ids |= (source.gas | gas_ids)
	else if(length(gas_ids))
		filtered_ids = gas_ids & source.gas

	// gather
	var/total_filterable_moles = 0
	var/list/specific_power_gas = list()
	for(var/id in filtered_ids)
		var/specific_power = calculate_specific_power_gas(id, source, sink) / ATMOS_ABSTRACT_SCRUB_EFFICIENCY
		specific_power_gas[id] = specific_power
		total_filterable_moles += source.gas[id]

	// not enough valid scrubbable gasses
	if(total_filterable_moles < MINIMUM_MOLES_TO_SCRUB)
		return 0

	// calculate work per mole in joules
	var/total_specific_power
	for(var/id in filtered_ids)
		var/ratio = source.gas[id] / total_filterable_moles
		total_specific_power += specific_power_gas[id] * ratio

	// limit by both moles and power
	limit_moles = isnull(limit_moles)? total_filterable_moles : min(limit_moles, total_filterable_moles)
	if(!isnull(limit_power))
		limit_moles = min(limit_moles, limit_power / total_specific_power)

	// can't transfer enough
	if(limit_moles < MINIMUM_MOLES_TO_SCRUB)
		return 0

	// do the actual filtering
	var/power_draw = 0
	for(var/id in filtered_ids)
		// todo: this esction isn't fully optimized/parsed
		var/transfer = source.gas[id]
		transfer = min(transfer, limit_moles * source.gas[id] / total_filterable_moles)
		source.adjust_gas(id, -transfer, FALSE)
		sink.adjust_gas_temp(id, transfer, source.temperature, FALSE)
		power_draw += specific_power_gas[id] * transfer

	// update values
	source.update_values()
	sink.update_values()

	// return power used in J
	return power_draw

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
		// flags
		filter_ids = list()
		for(var/id in source.gas)
			if(global.gas_data.flags[id] & to_filter)
				filterable_moles += source.gas[id]
				filter_ids += id
		if(!length(filter_ids))
			// not there
			return xgm_pump_gas(source, sink, limit_moles, limit_power)
	else
		// ids
		if(!(source.gas[filter_ids]))
			// not there
			return xgm_pump_gas(source, sink, limit_moles, limit_power)
		filter_ids = list(filter_ids)
		filterable_moles = source.gas[filter_ids]

	// not enough to filter but maybe enough to pump
	if(filterable_moles < MINIMUM_MOLES_TO_SCRUB)
		return xgm_pump_gas(source, sink, limit_moles, limit_power)

	// calculate work per mole moved through filter, diverting as necessary
	var/total_specific_power = 0
	var/list/not_filtered = source.gas - filter_ids
	for(var/id in not_filtered)
		total_specific_power += calculate_specific_power_gas(id, source, sink) * source.gas[id] / source.total_moles
	for(var/id in filter_ids)
		total_specific_power += calculate_specific_power_gas(id, source, divert) * source.gas[id] / source.total_moles
	total_specific_power /= ATMOS_ABSTRACT_SCRUB_EFFICIENCY

	// limit
	limit_moles = isnull(limit_moles)? source.total_moles : min(limit_moles, source.total_moles)
	if(!isnull(limit_power))
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
 * * filtering - mixture to send filtered gas into, associated to gas id or set of gas groups.
 * * limit_moles - if set, only scrubs this many moles of gas at most
 * * limit_power - power limit in joules
 *
 * @return power draw
 */
/proc/xgm_multi_filter_gas(datum/gas_mixture/source, datum/gas_mixture/sink, datum/gas_mixture/divert, to_filter, limit_moles, limit_power)
	// not enough to filter
	if(source.total_moles < MINIMUM_MOLES_TO_FILTER)
		return 0

	#warn impl

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

	// not enough to filter but maybe enough to pump
	if(filterable_moles < MINIMUM_MOLES_TO_SCRUB)
		return xgm_pump_gas(source, sink, limit_moles, limit_power)

	// calculate work per mole moved through filter, diverting as necessary
	var/total_specific_power = 0
	var/list/not_filtered = source.gas - filter_ids
	for(var/id in not_filtered)
		total_specific_power += calculate_specific_power_gas(id, source, sink) * source.gas[id] / source.total_moles
	for(var/id in filter_ids)
		total_specific_power += calculate_specific_power_gas(id, source, divert) * source.gas[id] / source.total_moles
	total_specific_power /= ATMOS_ABSTRACT_SCRUB_EFFICIENCY

	// limit
	limit_moles = isnull(limit_moles)? source.total_moles : min(limit_moles, source.total_moles)
	if(!isnull(limit_power))
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
