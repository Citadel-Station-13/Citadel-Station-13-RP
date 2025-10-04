//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/machinery/airlock_component/cycler
	name = "airlock cycler"
	desc = "A set of machinery used for manipulating the atmosphere inside of an airlock. Doubles as a gas sensor."
	#warn sprite

	controller_linking = TRUE

	/// does pumping with gradient (favorable) require power
	var/thermal_favorable_requires_power = FALSE
	/// power efficiency of favorable regulation; 10 = takes 1 joule to move 10 joules of heat
	var/thermal_favorable_efficiency = THERMODYNAMICS_AIRLOCK_HEAT_PUMP_EFFICIENCY_FAVORABLE
	/// power efficiency of unfavorable regulation; 10 = takes 1 joule to move 10 joules of heat
	var/thermal_unfavorable_efficiency = THERMODYNAMICS_AIRLOCK_HEAT_PUMP_EFFICIENCY_UNFAVORABLE
	/// power efficiency of electric heating. > 1 breaks thermodynamics but that's fine
	var/thermal_electrical_heating_efficiency = THERMODYNAMICS_AIRLOCK_ELECTRIC_HEATING_EFFICIENCY
	/// thermal pumping or heating power in kw
	var/thermal_power = 50

	/// pumping power in kw
	var/pumping_power = 50

	/// last status during cycling
	var/last_op_status

#warn impl

/**
 * siphons gas into expel buffers or exterior vents
 *
 * @params
 * * wanted_pressure - how much to siphon to.
 * * tolerance - how many kpa we can be above this to be considered success if we can't pump any more
 * * no_gas_venting - do not expel gas through external vents. used on shuttles to save gas.
 *
 * @return op status
 */
/obj/machinery/airlock_component/cycler/proc/siphon_gas(wanted_pressure, tolerance, no_gas_venting)
	var/datum/gas_mixture/manipulating = loc.return_air_mutable()
	if(!manipulating || !manipulating.total_moles)
		return AIRLOCK_CYCLER_OP_FINISHED


/**
 * vents gas from injection buffers without caring about temperature
 *
 * @params
 * * wanted_pressure - how much to fill to
 * * tolerance - how many kpa we can be below this to be considered success if we can't pump any more
 *
 * @return op status
 */
/obj/machinery/airlock_component/cycler/proc/inject_gas_naive(wanted_pressure, tolerance)

/**
 * vents gas from injection buffers with temperature taken into account
 *
 * @params
 * * wanted_pressure - how much to fill to
 * * wanted_temperature - how hot it should be
 * * pressure_tolerance - how many kpa we can be below this to be considered success if we can't pump any more
 * * temperature_tolerance - how many K above or below we can be to be considered success if we can't heat/cool any more
 *
 * @return op status
 */
/obj/machinery/airlock_component/cycler/proc/inject_gas_smart(wanted_pressure, wanted_temperature, pressure_tolerance, temperature_tolerance)

/**
 * dynamic cycle stabilization
 *
 * we will automatically expel bad gases, stabilize temperature, and inject wanted gas as necessary
 * dynamic injection will occur (we will inject missing gases to stabilize the ratio directly)
 */
/obj/machinery/airlock_component/cycler/proc/dynamic_cycle(
	towards,
	config_toggles,
	pressure_tolerance,
	temperature_tolerance,
	ratio_tolerance,
)
	var/wanted_pressure
	var/wanted_temperature
	var/list/wanted_gas_ratios

	if(istype(towards, /datum/gas_mixture))
		var/datum/gas_mixture/mixture = towards
		wanted_pressure = mixture.return_pressure()
		wanted_temperature = mixture.temperature

		// todo: optimize
		var/list/ratios = list()
		for(var/id in mixture.gas)
			ratios[id] = mixture.gas[id] / mixture.total_moles

	else if(istype(towards, /datum/airlock_environment))
		var/datum/airlock_environment/environment = towards
		wanted_pressure = environment.pressure_ideal
		wanted_temperature = environment.temperature_ideal
		wanted_gas_ratios = environment.gas_ratios_ideal
	else
		return AIRLOCK_CYCLER_OP_FATAL

	#warn impl
