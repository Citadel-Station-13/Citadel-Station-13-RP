/// The "Idro Repression Injection System" uses fusion fuel gas to remove heat from the area
/obj/machinery/portable_atmospherics/aether_displacement_engine
	name = "Aether Displacement Engine"
	desc = "A weird machine, it seems to have a connector that fits the standard atmospherics port. It has been marked by the Nanotrasen Artifact Recovery and Utilisation Group as 'Safe for standard NT operations'"

	icon = 'icons/machinery/vitruvius/iris.dmi'
	icon_state = "iris_idle"

	base_pixel_x = -16
	base_pixel_y = -16

	density = TRUE
	volume = 100

	var/cooling_power = -160 KILOWATTS //per mol of fusion fuel

	var/lowest_temp = 100

	var/mol_cap_modifier = 1//The higher the more moles are consumed per second, and the more is cooled, to increase cost to cool lower cooling power
	//if we wanted to go by the Oxygen not included consumption, this would be 2.5, which would drain a cannister of hydrogen in 12 minutes
	// with 1 it lasts for about 30 mintues

/obj/machinery/portable_atmospherics/aether_displacement_engine/process(delta_time)
	. = ..()
	var/datum/gas_mixture/env = loc.return_air()
	var/energy_to_target = env.get_thermal_energy_change(100)
	var/moles_to_cool = clamp(energy_to_target / cooling_power,0,delta_time * mol_cap_modifier)//10 moles per second, delta time is in 1/10 seconds, so delta_time is our moles count
	var/datum/gas_mixture/fuel_found = get_fusion_fuel(moles_to_cool)
	env.adjust_thermal_energy(fuel_found.total_moles * cooling_power)


/obj/machinery/portable_atmospherics/aether_displacement_engine/proc/get_fusion_fuel(moles_needed)
	return air_contents.remove_by_flag(GAS_FLAG_FUSION_FUEL, moles_needed)

/obj/machinery/portable_atmospherics/aether_displacement_engine/anomaly
	desc = "A weird machine, it seems to have a connector that fits the standard atmospherics port. It is bearing marks of 'Vitruvius' who ever that is."


