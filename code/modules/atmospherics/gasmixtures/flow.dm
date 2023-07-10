/**
 * @params
 * * source - mixture to scrub
 * * sink - mixture to scrub into
 * * gas_ids - list of gas ids to scrub
 * * gas_groups - list of gas groups to scrub
 * * limit_moles - if set, only scrubs this many moles of gas at most
 * * limit_power - power limit in watts
 *
 * @return power draw
 */
/proc/xgm_scrub_gas(datum/gas_mixture/source, datum/gas_mixture/sink, list/gas_ids, gas_groups, limit_moles, limit_power)
	// not enough to scrub
	if(source.total_moles < MINIMUM_MOLES_TO_SCRUB)
		return 0

	// get actually existing gas
	gas_ids = gas_ids & source.gas

	// gather
	var/total_filterable_moles = 0
	var/list/specific_power_gas = list()
	for(var/id in gas_ids)
		var/specific_power = calculate_specific_power_gas(id, source, sink) / ATMOS_ABSTRACT_SCRUB_EFFICIENCY
		specific_power_gas[id] = specific_power
		total_filterable_moles += source.gas[id]

	// not enough valid scrubbable gasses
	if(total_filterable_moles < MINIMUM_MOLES_TO_SCRUB)
		return 0

	// calculate work per mole in watts
	var/total_specific_power
	for(var/id in gas_ids)
		var/ratio = source.gas[id] / total_filterable_moles
		total_specific_power += specific_power_gas[id] * ratio

	// limit by both moles and power
	limit_moles = isnull(limit_moles)? total_filterable_moles : min(limit_moles, total_filterable_moles)
	if(!isnull(limit_power))
		limit_moles = min(limit_moles, limit_power / total_specific_power)

	// can't transfer enough
	if(limit_moles < MINIMUM_MOLES_TO_SCRUB)
		return 0

	#warn impl

	// update values
	source.update_values()
	sink.update_values()

/**
 * @params
 * * source - mixture to filter
 * * sink - mixture to send unfiltered gas into
 * * divert - mixture to send filtered gas into
 * * gas_ids - list of gas ids to filter
 * * gas_groups - list of gas groups to filter
 * * limit_moles - if set, only scrubs this many moles of gas at most
 * * limit_power - power limit in watts
 *
 * @return power draw
 */
/proc/xgm_filter_gas(datum/gas_mixture/source, datum/gas_mixture/sink, datum/gas_mixture/divert, list/gas_ids, gas_groups, limit_moles, limit_power)

	#warn impl

/**
 * @params
 * * source - mixture to filter
 * * sink - mixture to send unfiltered gas into
 * * divert - mixture to send filtered gas into; this is anything with molar mass between lower and upper, inclusive
 * * lower - lower bound of moles we're targeting
 * * upper - upper bound of moles we're targeting
 * * limit_moles - if set, only scrubs this many moles of gas at most
 * * limit_power - power limit in watts
 *
 * @return power draw
 */
/proc/xgm_molar_filter_gas(datum/gas_mixture/source, datum/gas_mixture/sink, datum/gas_mixture/divert, lower, upper, limit_moles, limit_power)

	#warn impl
