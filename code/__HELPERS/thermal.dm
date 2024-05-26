//* This file is explicitly licensed under the MIT license. *//
//* Copyrigth (c) 2024 LordME								*//

/**
 * Calculates the new temperature and returns it.
 *
 * @params
 * * initial_temperature - the temperature before the adding of the specified energy
 * * heat_capacity - The thermal energy capacity of the object, may NEVER be 0
 * * amount_in_joules - the amount of energy to be injected into the object
 *
 * @return the new temperature
 */
/proc/add_thermal_energy(initial_temperature, heat_capacity, amount_in_joules)
	. = initial_temperature
	if(heat_capacity)
		. += amount_in_joules / heat_capacity
	else
		STACK_TRACE("Called add_thermal_energy with heat_capacity = 0")

/**
 * Calculates the energy needed to change the temperature to target_temperature
 *
 * @params
 * * current_temperature - the temperature before the adding of the specified energy
 * * heat_capacity - The thermal energy capacity of the object, may NEVER be 0
 * * target_temperature - the temperature target
 *
 * @return the energy in joules
 */
/proc/get_thermal_energy_needed(current_temperature, heat_capacity, target_temperature)
	return (target_temperature - current_temperature) * heat_capacity

/**
 * Calculates shared new temperature of the two objects, assuming infinite amount of time for energy to transfer
 *
 * @params
 * * temperature_1 - temperature of thermal storage 1
 * * heat_capacity_1 - thermal energy capacity of thermal storage 1
 * * temperature_2 - temperature of thermal storage 2
 * * heat_capacity_2 - thermal energy capacity of thermal storage 2
 *
 * @return the new temperature of both
 */
/proc/share_thermal_energy(temperature_1, heat_capacity_1, temperature_2, heat_capacity_2)
	if(heat_capacity_1 || heat_capacity_2)//We are just catching math errors
		return (temperature_1 * heat_capacity_1 + temperature_2 * heat_capacity_2) / heat_capacity_1 + heat_capacity_2
	CRASH("Called share_thermal_energy with invalid heat_capacity_1 and heat_capacity_2")

/**
 * Calculates shared new temperature of the two objects, assuming one second for energy to transfer
 * takes conductivity into account, stepsize is 1 second
 *
 * @params
 * * temperature_1 - temperature of thermal storage 1
 * * heat_capacity_1 - thermal energy capacity of thermal storage 1
 * * temperature_2 - temperature of thermal storage 2
 * * heat_capacity_2 - thermal energy capacity of thermal storage 2
 *
 * @return the new temperature of thermal object 1
 */
/proc/share_thermal_energy_conductivity(temperature_1, heat_capacity_1, temperature_2, heat_capacity_2, thermal_conductivity)
	return (temperature_1 + thermal_conductivity * (temperature_1 - temperature_2) / heat_capacity_1)


