/**
 * A continuous
 */
/datum/pipeline
	var/datum/gas_mixture/air

	var/list/obj/machinery/atmospherics/pipe/members
	var/list/obj/machinery/atmospherics/pipe/edges //Used for building networks

	var/datum/pipe_network/network

	var/alert_pressure = 0

/datum/pipeline/Destroy()
	QDEL_NULL(network)

	if(air && air.volume)
		temporarily_store_air()
	for(var/obj/machinery/atmospherics/pipe/P in members)
		P.parent = null
	members = null
	edges = null
	. = ..()

/datum/pipeline/process(delta_time)//This use to be called called from the pipe networks

	//Check to see if pressure is within acceptable limits
	var/pressure = air.return_pressure()
	if(pressure > alert_pressure)
		for(var/obj/machinery/atmospherics/pipe/member in members)
			if(!member.check_pressure(pressure))
				break //Only delete 1 pipe per process

/datum/pipeline/proc/temporarily_store_air()
	//Update individual gas_mixtures by volume ratio

	for(var/obj/machinery/atmospherics/pipe/member in members)
		member.air_temporary = new
		member.air_temporary.copy_from(air)
		member.air_temporary.volume = member.volume
		member.air_temporary.multiply(member.volume / air.volume)

/datum/pipeline/proc/build_pipeline(obj/machinery/atmospherics/pipe/base)
	air = new

	var/list/possible_expansions = list(base)
	members = list(base)
	edges = list()

	var/volume = base.volume
	base.parent = src
	alert_pressure = base.alert_pressure

	if(base.air_temporary)
		air = base.air_temporary
		base.air_temporary = null
	else
		air = new


	while(possible_expansions.len>0)
		for(var/obj/machinery/atmospherics/pipe/borderline in possible_expansions)

			var/list/result = borderline.pipeline_expansion()
			var/edge_check = result.len

			if(result.len>0)
				for(var/obj/machinery/atmospherics/pipe/item in result)

					//if(item.in_stasis)
					//	continue

					if(!members.Find(item))
						members += item
						possible_expansions += item

						volume += item.volume
						item.parent = src

						alert_pressure = min(alert_pressure, item.alert_pressure)

						if(item.air_temporary)
							air.merge(item.air_temporary)


					edge_check--

			if(edge_check>0)
				edges += borderline

			possible_expansions -= borderline

	air.volume = volume

/datum/pipeline/proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)

	if(new_network.line_members.Find(src))
		return 0

	new_network.line_members += src

	network = new_network

	for(var/obj/machinery/atmospherics/pipe/edge in edges)
		for(var/obj/machinery/atmospherics/result in edge.pipeline_expansion())
			if(!istype(result,/obj/machinery/atmospherics/pipe) && (result!=reference))
				result.network_expand(new_network, edge)

	return 1

/datum/pipeline/proc/return_network(obj/machinery/atmospherics/reference)
	if(!network)
		network = new /datum/pipe_network()
		network.build_network(src, null)
			//technically passing these parameters should not be allowed
			//however pipe_network.build_network(..) and pipeline.network_extend(...)
			//		were setup to properly handle this case

	return network

// todo: this should be re-evaluated in the context of passive vents and what we should do with them.
/datum/pipeline/proc/mingle_with_turf(turf/simulated/target, mingle_volume)
	var/datum/gas_mixture/air_sample = air.remove_ratio(mingle_volume/air.volume)
	air_sample.volume = mingle_volume

	if(istype(target) && target.zone)
		//Have to consider preservation of group statuses
		var/datum/gas_mixture/turf_copy = new
		var/datum/gas_mixture/turf_original = new

		turf_copy.copy_from(target.zone.air)
		turf_copy.volume = target.zone.air.volume //Copy a good representation of the turf from parent group
		turf_original.copy_from(turf_copy)

		equalize_gases(list(air_sample, turf_copy))
		air.merge(air_sample)


		target.zone.air.remove(turf_original.total_moles)
		target.zone.air.merge(turf_copy)

	else
		var/datum/gas_mixture/turf_air = target.return_air()

		equalize_gases(list(air_sample, turf_air))
		air.merge(air_sample)
		//turf_air already modified by equalize_gases()

	if(network)
		network.update = 1

//* Sharing - Temperature *//

/datum/pipeline/proc/share_heat_with_turf(turf/target, share_volume, thermal_conductivity)
	var/total_heat_capacity = air.heat_capacity()
	var/partial_heat_capacity = total_heat_capacity*(share_volume/air.volume)

	if(istype(target, /turf/simulated))
		var/turf/simulated/modeled_location = target
		if(modeled_location.special_temperature)//First do special interactions then the usuall stuff
			CACHE_VSC_PROP(atmos_vsc, /atmos/hepipes/thermal_conductivity, thermal_conductivity_setting)
			var/delta_temp = modeled_location.special_temperature - air.temperature//2200C - 20C = 2180K
			//assuming aluminium with thermal conductivity 235 W * K / m, Copper (400), Silver (430), steel (50), gold (320)
			var/heat_gain = thermal_conductivity_setting * 100 * delta_temp//assuming 1 cm wall thickness, so delta_temp isnt multiplied
			heat_gain = clamp(heat_gain, air.get_thermal_energy_change(modeled_location.special_temperature), -air.get_thermal_energy_change(modeled_location.special_temperature))
			air.adjust_thermal_energy(heat_gain)
			if(network)
				network.update = 1
		if(modeled_location.blocks_air)

			if((modeled_location.heat_capacity>0) && (partial_heat_capacity>0))
				var/delta_temperature = air.temperature - modeled_location.temperature

				var/heat = thermal_conductivity*delta_temperature* \
					(partial_heat_capacity*modeled_location.heat_capacity/(partial_heat_capacity+modeled_location.heat_capacity))

				air.temperature -= heat/total_heat_capacity
				modeled_location.temperature += heat/modeled_location.heat_capacity

		else
			var/delta_temperature = 0
			var/sharer_heat_capacity = 0

			if(modeled_location.zone)
				delta_temperature = (air.temperature - modeled_location.zone.air.temperature)
				sharer_heat_capacity = modeled_location.zone.air.heat_capacity()
			else
				delta_temperature = (air.temperature - modeled_location.air.temperature)
				sharer_heat_capacity = modeled_location.air.heat_capacity()

			var/self_temperature_delta = 0
			var/sharer_temperature_delta = 0

			if((sharer_heat_capacity>0) && (partial_heat_capacity>0))
				var/heat = thermal_conductivity*delta_temperature* \
					(partial_heat_capacity*sharer_heat_capacity/(partial_heat_capacity+sharer_heat_capacity))

				self_temperature_delta = -heat/total_heat_capacity
				sharer_temperature_delta = heat/sharer_heat_capacity
			else
				return 1

			air.temperature += self_temperature_delta

			if(modeled_location.zone)
				modeled_location.zone.air.temperature += sharer_temperature_delta/modeled_location.zone.air.group_multiplier
			else
				modeled_location.air.temperature += sharer_temperature_delta


	else
		if((target.heat_capacity>0) && (partial_heat_capacity>0))
			var/delta_temperature = air.temperature - target.temperature

			var/heat = thermal_conductivity*delta_temperature* \
				(partial_heat_capacity*target.heat_capacity/(partial_heat_capacity+target.heat_capacity))

			air.temperature -= heat/total_heat_capacity
	if(network)
		network.update = 1

/**
 * Runs space radiation simulation on the pipeline.
 *
 * todo: emissivity, solar_absorptivity to model emission of low-frequency IR vs absorption of high-frequency solar radiation
 *
 * @params
 * * surface - the m^2 surface area of the exposed surface to space
 * * thermal_conductivity - relative thermal conductivity (so, cheat / penalty multiplier).
 */
//surface must be the surface area in m^2
/datum/pipeline/proc/share_heat_with_space(surface, thermal_conductivity)
	// in mol / L
	var/gas_density = air.total_moles / air.volume

	/**
	 * * becomes, with gas density, (n * r * t) / (p * v)
	 * * ~240 mol for 70L
	 * * ~8356kPa at 20C, 70 L
	 */
	thermal_conductivity *= min(
		gas_density / (THERMODYNAMICS_OPTIMAL_RADIATOR_PRESSURE / (R_IDEAL_GAS_EQUATION * THERMODYANMICS_CRITICAL_TEMPERATURE_OF_AIR)),
		1,
	)

	/**
	 * Because we're so high-roleplay and realistic!!!! we actually simulate heat *gain* as well.
	 * You can actually heat things up.
	 *
	 * * This currently does not take into account solar absorptivity.
	 */
	var/heat_gain = THERMODYNAMICS_THEORETICAL_STAR_EXPOSED_POWER_DENSITY * (THERMODYNAMICS_THEORETICAL_STAR_EXPOSURE_RATIO * surface) * thermal_conducitivity

	/**
	 * Perform radiation.
	 */
	heat_gain -= surface * STEFAN_BOLTZMANN_CONSTANT * thermal_conductivity * (air.temperature - COSMIC_RADIATION_TEMPERATURE) ** 4

	air.adjust_thermal_energy(heat_gain)
	network?.update = TRUE
