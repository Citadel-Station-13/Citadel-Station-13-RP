/*

Overview:
	These are what handle gas transfers between zones and into space.
	They are found in a zone's edges list and in SSair.edges.
	Each edge updates every air tick due to their role in gas transfer.
	They come in two flavors, /datum/zas_edge/zone and /datum/zas_edge/unsimulated.
	As the type names might suggest, they handle inter-zone and spacelike connections respectively.

Class Vars:

	A - This always holds a zone. In unsimulated edges, it holds the only zone.

	connecting_turfs - This holds a list of connected turfs, mainly for the sake of airflow.

	coefficient - This is a marker for how many connections are on this edge. Used to determine the ratio of flow.

	datum/zas_edge/zone

		B - This holds the second zone with which the first zone equalizes.

		direct - This counts the number of direct (i.e. with no doors) connections on this edge.
		         Any value of this is sufficient to make the zones mergeable.

	datum/zas_edge/unsimulated

		B - This holds an unsimulated turf which has the gas values this edge is mimicing.

		air - Retrieved from B on creation and used as an argument for the legacy ShareSpace() proc.

Class Procs:

	add_connection(datum/zas_connection/c)
		Adds a connection to this edge. Usually increments the coefficient and adds a turf to connecting_turfs.

	remove_connection(datum/zas_connection/c)
		Removes a connection from this edge. This works even if c is not in the edge, so be careful.
		If the coefficient reaches zero as a result, the edge is erased.

	contains_zone(datum/zas_zone/Z)
		Returns true if either A or B is equal to Z. Unsimulated connections return true only on A.

	erase()
		Removes this connection from processing and zone edge lists.

	tick()
		Called every air tick on edges in the processing list. Equalizes gas.

	flow(list/movable, differential, repelled)
		Airflow proc causing all objects in movable to be checked against a pressure differential.
		If repelled is true, the objects move away from any turf in connecting_turfs, otherwise they approach.
		A check against vsc.lightest_airflow_pressure should generally be performed before calling this.

	get_connected_zone(datum/zas_zone/from)
		Helper proc that allows getting the other zone of an edge given one of them.
		Only on /datum/zas_edge/zone, otherwise use A.

*/


/datum/zas_edge
	var/datum/zas_zone/A
	var/list/connecting_turfs = list()
	var/direct = 0
	var/sleeping = 1
	var/coefficient = 0

/datum/zas_edge/New()
	CRASH("Cannot make connection edge without specifications.")

/datum/zas_edge/proc/add_connection(datum/zas_connection/c)
	coefficient++
	if(c.direct()) direct++
	//to_chat(world, "Connection added: [type] Coefficient: [coefficient]")

/datum/zas_edge/proc/remove_connection(datum/zas_connection/c)
	//to_chat(world, "Connection removed: [type] Coefficient: [coefficient-1]")
	coefficient--
	if(coefficient <= 0)
		erase()
	if(c.direct()) direct--

/datum/zas_edge/proc/contains_zone(datum/zas_zone/Z)

/datum/zas_edge/proc/erase()
	SSair.remove_edge(src)
	//to_chat(world, "[type] Erased.")

/datum/zas_edge/proc/tick()

/datum/zas_edge/proc/recheck()

/datum/zas_edge/proc/flow(list/movable, differential, repelled)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/retrigger_delay, retrigger_delay)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/stun_pressure, stun_pressure)
	for(var/i = 1; i <= movable.len; i++)
		var/atom/movable/M = movable[i]

		//If they're already being tossed, don't do it again.
		if(M.last_airflow > world.time - retrigger_delay)
			continue
		if(M.airflow_speed)
			continue

		//Check for knocking people over
		if(ismob(M) && differential > stun_pressure)
			if(M:status_flags & STATUS_GODMODE)
				continue
			M:airflow_stun()

		if(M.check_airflow_movable(differential))
			//Check for things that are in range of the midpoint turfs.
			var/list/close_turfs = list()
			for(var/turf/U in connecting_turfs)
				if(get_dist(M,U) < world.view) close_turfs += U
			if(!close_turfs.len)
				continue

			M.airflow_dest = pick(close_turfs) //Pick a random midpoint to fly towards.

			if(repelled)
				spawn
					if(M) M.RepelAirflowDest(differential/5)
			else
				spawn
					if(M) M.GotoAirflowDest(differential/10)

/**
 * immediately equalize air across the edge
 */
/datum/zas_edge/proc/equalize()
	CRASH("unimplemented proc")

// todo: what is this for? tile conduction? that sounds fun...
/proc/ShareHeat(datum/gas_mixture/A, datum/gas_mixture/B, connecting_tiles)
	//This implements a simplistic version of the Stefan-Boltzmann law.
	var/energy_delta = ((A.temperature - B.temperature) ** 4) * STEFAN_BOLTZMANN_CONSTANT * connecting_tiles * 2.5
	var/maximum_energy_delta = max(0, min(A.temperature * A.heat_capacity() * A.group_multiplier, B.temperature * B.heat_capacity() * B.group_multiplier))
	if(maximum_energy_delta > abs(energy_delta))
		if(energy_delta < 0)
			maximum_energy_delta *= -1
		energy_delta = maximum_energy_delta

	A.temperature -= energy_delta / (A.heat_capacity() * A.group_multiplier)
	B.temperature += energy_delta / (B.heat_capacity() * B.group_multiplier)
