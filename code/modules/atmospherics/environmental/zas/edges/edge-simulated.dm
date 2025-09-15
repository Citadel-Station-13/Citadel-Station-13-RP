// todo: /zas_edge/simulated
/datum/zas_edge/zone
	var/datum/zas_zone/B

/datum/zas_edge/zone/New(datum/zas_zone/A, datum/zas_zone/B)

	src.A = A
	src.B = B
	A.edges.Add(src)
	B.edges.Add(src)
	//id = edge_id(A,B)
	//to_chat(world, "New edge between [A] and [B]")

/datum/zas_edge/zone/add_connection(datum/zas_connection/c)
	. = ..()
	connecting_turfs.Add(c.A)

/datum/zas_edge/zone/remove_connection(datum/zas_connection/c)
	connecting_turfs.Remove(c.A)
	. = ..()

/datum/zas_edge/zone/contains_zone(datum/zas_zone/Z)
	return A == Z || B == Z

/datum/zas_edge/zone/erase()
	A.edges.Remove(src)
	B.edges.Remove(src)
	. = ..()

/datum/zas_edge/zone/tick()
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/lightest_pressure, lightest_pressure)
	if(A.invalid || B.invalid)
		erase()
		return

	var/equiv = A.air.environmental_share_simulated(B.air, coefficient)

	var/differential = A.air.return_pressure() - B.air.return_pressure()
	if(abs(differential) >= lightest_pressure)
		var/list/attracted
		var/list/repelled
		if(differential > 0)
			attracted = A.movables()
			repelled = B.movables()
		else
			attracted = B.movables()
			repelled = A.movables()

		flow(attracted, abs(differential), 0)
		flow(repelled, abs(differential), 1)

	if(equiv)
		if(direct)
			erase()
			SSair.merge(A, B)
			return
		else
			equalize()
			SSair.mark_edge_sleeping(src)

	SSair.mark_zone_update(A)
	SSair.mark_zone_update(B)

/datum/zas_edge/zone/recheck()
	// Edges with only one side being vacuum need processing no matter how close.
	if(!A.air.compare(B.air, vacuum_exception = 1))
		SSair.mark_edge_active(src)

//Helper proc to get connections for a zone.
/datum/zas_edge/zone/proc/get_connected_zone(datum/zas_zone/from)
	if(A == from) return B
	else return A

/datum/zas_edge/zone/equalize()
	var/datum/gas_mixture/air_A = A.air
	var/datum/gas_mixture/air_B = B.air

	// this proc assumes that the only thing different between A and B's actual volume is the group multiplier
	#ifdef CF_ATMOS_ZAS_DEBUG_ASSERTIONS
	ASSERT(air_A.volume == air_B.volume)
	#endif

	// if there's not enough air to bother simulating, just turn both into a vacuum
	if(air_A.total_moles + air_B.total_moles <= MINIMUM_MOLES_TO_DISSIPATE)
		air_A.empty()
		air_B.empty()
		return

	var/combined_group_multiplier = air_A.group_multiplier + air_B.group_multiplier

	// the proportions of A and B to their full groups
	// this lets us calculate everything pretty quickly with minimal floating point precision issues from large numbers
	var/scaler_A = air_A.group_multiplier / combined_group_multiplier
	var/scaler_B = air_B.group_multiplier / combined_group_multiplier

	// get these before the gas transfer
	var/heat_capacity_A_scaled = air_A.heat_capacity_singular() * scaler_A
	var/heat_capacity_B_scaled = air_B.heat_capacity_singular() * scaler_B

	for(var/gas in air_A.gas | air_B.gas)
		var/per_tile = air_A.gas[gas] * scaler_A + air_B.gas[gas] * scaler_B
		air_A.gas[gas] = per_tile
		air_B.gas[gas] = per_tile

	var/average_temperature = ((heat_capacity_A_scaled * air_A.temperature) + (heat_capacity_B_scaled * air_B.temperature)) \
		/ (heat_capacity_A_scaled + heat_capacity_B_scaled)
	air_A.temperature = average_temperature
	air_B.temperature = average_temperature

	air_A.update_values()
	air_B.update_values()
