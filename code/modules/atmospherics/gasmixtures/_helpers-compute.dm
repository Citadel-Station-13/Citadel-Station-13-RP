//-----------------------------------------------------------------------------//
/**
 * Contains transfer helpers for operating with multiple gas mixtures
 * in a generic way.
 *
 * * All procs should be prefixed with 'xgm_' to namespace them in the global scope.
 * * This file contains 'check' helpers, which do not actually mutate the gas mixtures.
 */
//-----------------------------------------------------------------------------//

/**
 * cheaply calculates approximate moles to get to target pressure
 *
 * ! WARNING: Make sure temperature is set right. Gas mixtures default to 2.7 when empty; that isn't what you usually want. !
 * ! WARNING: Does not take into account source temperature. !
 *
 * @params
 * - pressure - pressure of target mixture
 * - temperature - temperature of target mixture
 * - volume - volume of target mixture
 * - target - how much to pump to
 */
/proc/xgm_static_cheap_transfer_moles(pressure, temperature, volume, target)
	return ((target - pressure) * volume) / (R_IDEAL_GAS_EQUATION * temperature)

/**
 * cheaply calculates approximate moles to get to target pressure for gasmixture
 *
 * ! WARNING: Will treat empty gas mixtures as ROOM TEMPERATURE. !
 * ! WARNING: Does not take into account source temperature. !
 *
 * @params
 * - sink - pumping to
 * - target_pressure - how much to pump to
 */
/proc/xgm_cheap_transfer_moles_single(datum/gas_mixture/sink, target_pressure)
	var/sink_pressure = XGM_PRESSURE(sink)
	var/sink_temperature = XGM_TEMPERATURE(sink)
	if(!sink_pressure)
		sink_temperature = T20C
	return (((target_pressure - sink_pressure) * XGM_VOLUME(sink)) / (R_IDEAL_GAS_EQUATION * sink_temperature)) * sink.group_multiplier

/**
 * cheaply calculates approximate moles to get to target pressure for gasmixture
 *
 * ! WARNING: SOURCE SHOULD NOT BE EMPTY !
 *
 * @params
 * - source - pumping from
 * - sink - pumping to
 * - target_pressure - how much to pump to
 * - extra_volume - treat sink as having extra volume for when you pump into pipe networks
 * - speedy - at risk of overshooting, make sure our calculations pump atleast 75% or 5 mol of the naive moles-required calc, whichever is bigger.
 */
/proc/xgm_cheap_transfer_moles(datum/gas_mixture/source, datum/gas_mixture/sink, target_pressure, extra_volume, speedy)
	//! LEGACY CODE; this is not mine.
	var/source_moles = XGM_TOTAL_MOLES(source)
	if(!source_moles)
		CRASH("source is empty, this proc is a waste of time")
	if(target_pressure == 0)
		return -XGM_TOTAL_MOLES(sink)
	var/sink_moles = XGM_TOTAL_MOLES(sink)
	if(!sink_moles)
		return (target_pressure * XGM_VOLUME(sink)) / (R_IDEAL_GAS_EQUATION * XGM_TEMPERATURE(source))

	var/output_volume = (XGM_VOLUME(sink) * sink.group_multiplier) + extra_volume
	var/pressure_delta = target_pressure - XGM_PRESSURE(sink)

	var/air_temperature = source.temperature
	var/sink_temperature = XGM_TEMPERATURE(sink)
	if(sink_temperature != air_temperature)
		//estimate the final temperature of the sink after transfer
		var/estimate_moles = (pressure_delta * output_volume) / (sink_temperature * R_IDEAL_GAS_EQUATION)
		var/sink_heat_capacity = sink.heat_capacity()
		var/transfer_heat_capacity = source.heat_capacity() * estimate_moles / source_moles
		air_temperature = (sink_temperature * sink_heat_capacity + air_temperature * transfer_heat_capacity) / (sink_heat_capacity + transfer_heat_capacity)

	if(!speedy)
		return (pressure_delta * output_volume) / (air_temperature * R_IDEAL_GAS_EQUATION)

	var/pvr = (pressure_delta * output_volume) / R_IDEAL_GAS_EQUATION
	var/naive = pvr / sink_temperature
	var/heuristic = pvr / air_temperature
	return max(heuristic, naive > (5 / 0.75)? naive * 0.75 : naive)
