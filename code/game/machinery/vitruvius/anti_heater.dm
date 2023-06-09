/// The "Idro Repression Injection System" uses fusion fuel gas to remove heat from the area
/obj/machinery/portable_atmospherics/idro
	name = "Idro Repression Injection System"
	desc = "A weird machine, it seems to have a connector that fits the standard atmospherics port. It has been marked by the Nanotrasen Artifact Recovery and Utilisation Group as 'Safe for standard NT operations'"

	volume = 100

	var/cooling_power = -160 KILOWATTS //per mol of fusion fuel

	var/lowest_temp = 100
	//if we wanted to go by the Oxygen not included consumption, this would be 2.5, which would drain a cannister of hydrogen in 12 minutes
	// with 1 it lasts for about 30 mintues

/obj/machinery/portable_atmospherics/idro/process(delta_time)
	. = ..()
	var/datum/gas_mixture/env = loc.return_air()
	var/energy_to_target = env.get_thermal_energy_change(100)
	var/moles_to_cool = clamp(energy_to_target / cooling_power,0,10)
	var/datum/gas_mixture/fuel_found = get_fusion_fuel(moles_to_cool)
	env.adjust_thermal_energy(fuel_found.total_moles * cooling_power)


/obj/machinery/portable_atmospherics/idro/proc/get_fusion_fuel(moles_needed)
	return air_contents.remove_by_flag(GAS_FLAG_FUSION_FUEL, moles_needed)

/obj/machinery/portable_atmospherics/idro/anomaly
	desc = "A weird machine, it seems to have a connector that fits the standard atmospherics port. It is bearing marks of 'Vitruvius' who ever that is."


