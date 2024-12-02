/datum/zas_edge/unsimulated
	var/turf/B
	var/datum/gas_mixture/air

/datum/zas_edge/unsimulated/New(datum/zas_zone/A, turf/B)
	src.A = A
	src.B = B
	A.edges.Add(src)
	air = B.return_air()
	//id = 52*A.id
	//to_chat(world, "New edge from [A] to [B].")

/datum/zas_edge/unsimulated/add_connection(datum/zas_connection/c)
	. = ..()
	connecting_turfs.Add(c.B)
	air.group_multiplier = coefficient

/datum/zas_edge/unsimulated/remove_connection(datum/zas_connection/c)
	connecting_turfs.Remove(c.B)
	air.group_multiplier = coefficient
	. = ..()

/datum/zas_edge/unsimulated/erase()
	A.edges.Remove(src)
	. = ..()

/datum/zas_edge/unsimulated/contains_zone(datum/zas_zone/Z)
	return A == Z

/datum/zas_edge/unsimulated/tick()
	if(A.invalid)
		erase()
		return

	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/lightest_pressure, lightest_pressure)

	var/equiv = A.air.environmental_share_unsimulated(air)

	var/differential = A.air.return_pressure() - air.return_pressure()
	if(abs(differential) >= lightest_pressure)
		var/list/attracted = A.movables()
		flow(attracted, abs(differential), differential < 0)

	if(equiv)
		A.air.copy_from(air)
		SSair.mark_edge_sleeping(src)

	SSair.mark_zone_update(A)

/datum/zas_edge/unsimulated/recheck()
	// Edges with only one side being vacuum need processing no matter how close.
	// Note: This handles the glaring flaw of a room holding pressure while exposed to space, but
	// does not specially handle the less common case of a simulated room exposed to an unsimulated pressurized turf.
	if(!A.air.compare(air, vacuum_exception = 1))
		SSair.mark_edge_active(src)
