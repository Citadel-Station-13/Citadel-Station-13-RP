#define ROD_RADIATION_MULTIPLIER 1.5
#define ROD_TEMPERATURE_CUTOFF 10000
#define ROD_EXPOSED_POWER 0.1

/obj/item/weapon/fuelrod
	name = "Fuel Rod"
	desc = "A nuclear rod."
	icon = 'icons/obj/machines/power/fission.dmi'
	icon_state = "rod"
	var/gasefficiency = 0.05
	var/insertion = 0
	var/integrity = 100
	var/life = 100
	var/lifespan = 3600
	var/reflective = 1
	var/temperature = T20C
	var/specific_heat = 1	// J/(mol*K) - Caluclated by: (specific heat) [kJ/kg*K] * (molar mass) [g/mol] (g/mol = kg/mol * 1000, duh.)
	var/molar_mass = 1	// kg/mol
	var/mass = 1 // kg
	var/melting_point = 3000 // Entering the danger zone.
	var/decay_heat = 0 // MJ/mol (Yes, using MegaJoules per Mole. Techincally reduces power, but that reflects reduced lifespan.)

/obj/item/weapon/fuelrod/New()
	..()
	processing_objects.Add(src)

/obj/item/weapon/fuelrod/process()
	if(isnull(loc))
		return PROCESS_KILL

	if(!istype(loc, /obj/machinery/power/fission))
		var/turf/T = get_turf(src)
		equalize(T.return_air(), gasefficiency)

		if(decay_heat > 0 && !istype(loc, /obj/item/weapon/storage/briefcase/fission))
			var/insertion_multiplier = ROD_EXPOSED_POWER
			if(integrity == 0)
				insertion_multiplier = 1
			var/power = (tick_life(0, insertion_multiplier) / REACTOR_RADS_TO_MJ)
			add_thermal_energy(power)
			radiation_repository.radiate(src, max(power * ROD_RADIATION_MULTIPLIER, 0))

/obj/item/weapon/fuelrod/proc/equalize(var/E, var/efficiency)
	var/our_heatcap = heat_capacity()
	// Ugly code ahead. Thanks for not allowing polymorphism, Byond.
	if(istype(E, /obj/machinery/power/fission))
		var/obj/machinery/power/fission/sharer = E
		var/share_heatcap = sharer.heat_capacity()

		if(our_heatcap + share_heatcap)
			var/new_temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
			temperature += (new_temperature - temperature) * efficiency // Add efficiency here, since there's no gas.remove for non-gas objects.
			temperature = between(0, temperature, ROD_TEMPERATURE_CUTOFF)
			sharer.temperature += (new_temperature - sharer.temperature) * efficiency
			sharer.temperature = between(0, sharer.temperature, ROD_TEMPERATURE_CUTOFF)
	else if(istype(E, /datum/gas_mixture))
		var/datum/gas_mixture/env = E
		var/datum/gas_mixture/sharer = env.remove(efficiency * env.total_moles)
		var/share_heatcap = sharer.heat_capacity()

		if(our_heatcap + share_heatcap)
			var/new_temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
			temperature += (new_temperature - temperature) * efficiency
			temperature = between(0, temperature, ROD_TEMPERATURE_CUTOFF)
			sharer.temperature += (new_temperature - sharer.temperature)
			sharer.temperature = between(0, sharer.temperature, ROD_TEMPERATURE_CUTOFF)
		env.merge(sharer)

	var/integrity_lost = integrity
	if(temperature > melting_point && melting_point > 0)
		integrity = max(0, integrity - (temperature / melting_point))
	else if(temperature > (melting_point * 0.9))
		integrity = max(0, integrity - ((1 / lifespan) * 100))
	if(integrity == 0 && integrity_lost > 0) // Meltdown time.
		meltdown()

/obj/item/weapon/fuelrod/proc/add_thermal_energy(var/thermal_energy)
	if(mass < 1)
		return 0

	var/heat_capacity = heat_capacity()
	if(thermal_energy < 0)
		if(temperature < TCMB)
			return 0
		var/thermal_energy_limit = -(temperature - TCMB)*heat_capacity	//ensure temperature does not go below TCMB
		thermal_energy = max(thermal_energy, thermal_energy_limit)	//thermal_energy and thermal_energy_limit are negative here.
	temperature += thermal_energy/heat_capacity
	return thermal_energy

/obj/item/weapon/fuelrod/proc/heat_capacity()
	. = specific_heat * (mass / molar_mass)

/obj/item/weapon/fuelrod/proc/tick_life(var/apply_heat = 0, var/insertion_override = 0)
	var/applied_insertion = get_insertion()
	if(insertion_override)
		applied_insertion = insertion_override
	if(lifespan < 1 && life > 0)
		life = 0
	else if(life > 0)
		if(decay_heat > 0 || apply_heat)
			life = max(0, life - ((1 / lifespan) * applied_insertion * 100))
		if(life == 0 && health > 0)
			name = "depleted [name]"
		else if(decay_heat > 0)
			return ((decay_heat * (mass / molar_mass)) / lifespan) * (min(life, 100) / 100) * applied_insertion
	return 0

/obj/item/weapon/fuelrod/proc/get_insertion()
	var/applied_insertion = 1
	if(istype(loc, /obj/machinery/power/fission) && icon_state != "rod_melt")
		applied_insertion = insertion
	return between(0, applied_insertion, 1)

/obj/item/weapon/fuelrod/proc/is_melted()
	return (icon_state == "rod_melt") ? 1 : 0

/obj/item/weapon/fuelrod/proc/meltdown()
	if(!is_melted())
		if(decay_heat > 0)
			life = life * 10
			decay_heat = decay_heat * 10
		else
			life = 0
		name = "melted [name]"
		icon_state = "rod_melt"
		integrity = 0

/obj/item/weapon/fuelrod/uranium
	name = "uranium fuel rod"
	desc = "A nuclear fuel rod."
	color = "#75716E"
	specific_heat = 28	// J/(mol*K)
	molar_mass = 0.235	// kg/mol
	mass = 20 // kg
	melting_point = 1405
	decay_heat = 19536350 // MJ/mol

/obj/item/weapon/fuelrod/plutonium
	name = "plutonium fuel rod"
	desc = "A nuclear fuel rod."
	color = "#cbcbcb"
	specific_heat = 36	// J/(mol*K)
	molar_mass = 0.244	// kg/mol
	mass = 5 // kg
	melting_point = 914
	decay_heat = 20342002 // MJ/mol
	lifespan = 1800

/obj/item/weapon/fuelrod/beryllium
	name = "beryllium reflector"
	desc = "A neutron reflector."
	color = "#878B96"
	specific_heat = 16	// J/(mol*K)
	molar_mass = 0.009	// kg/mol
	mass = 2 // kg
	melting_point = 1560
	lifespan = 7200

/obj/item/weapon/fuelrod/tungstencarbide
	name = "tungsten carbide reflector"
	desc = "A neutron reflector."
	color = "#525252"
	specific_heat = 40	// J/(mol*K)
	molar_mass = 0.196	// kg/mol
	mass = 19 // kg
	melting_point = 3058
	lifespan = 14400

/obj/item/weapon/fuelrod/silver
	name = "silver control rod"
	desc = "A nuclear control rod."
	color = "#D1C9B6"
	reflective = 0
	specific_heat = 25	// J/(mol*K)
	molar_mass = 0.108	// kg/mol
	mass = 10 // kg
	melting_point = 1235
	lifespan = 4800

/obj/item/weapon/fuelrod/boron
	name = "boron control rod"
	desc = "A nuclear control rod."
	color = "#6F6E6A"
	reflective = 0
	specific_heat = 11	// J/(mol*K)
	molar_mass = 0.011	// kg/mol
	mass = 2 // kg
	melting_point = 2349
	lifespan = 4800
