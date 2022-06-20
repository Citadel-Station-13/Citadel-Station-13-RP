var/datum/controller/subsystem/air/air_master

var/tick_multiplier = 2

/*

Overview:
	The air controller does everything. There are tons of procs in here.

Class Vars:
	zones - All zones currently holding one or more turfs.
	edges - All processing edges.

	tiles_to_update - Tiles scheduled to update next tick.
	zones_to_update - Zones which have had their air changed and need air archival.
	active_hotspots - All processing fire objects.

	active_zones - The number of zones which were archived last tick. Used in debug verbs.
	next_id - The next UID to be applied to a zone. Mostly useful for debugging purposes as zones do not need UIDs to function.

Class Procs:

	mark_for_update(turf/T)
		Adds the turf to the update list. When updated, update_air_properties() will be called.
		When stuff changes that might affect airflow, call this. It's basically the only thing you need.

	add_zone(datum/zas_zone/Z) and remove_zone(datum/zas_zone/Z)
		Adds zones to the zones list. Does not mark them for update.

	air_blocked(turf/A, turf/B)
		Returns a bitflag consisting of:
		AIR_BLOCKED - The connection between turfs is physically blocked. No air can pass.
		ZONE_BLOCKED - There is a door between the turfs, so zones cannot cross. Air may or may not be permeable.

	merge(datum/zas_zone/A, datum/zas_zone/B)
		Called when zones have a direct connection and equivalent pressure and temperature.
		Merges the zones to create a single zone.

	connect(turf/simulated/A, turf/B)
		Called by turf/update_air_properties(). The first argument must be simulated.
		Creates a connection between A and B.

	mark_zone_update(datum/zas_zone/Z)
		Adds zone to the update list. Unlike mark_for_update(), this one is called automatically whenever
		air is returned from a simulated turf.

	equivalent_pressure(datum/zas_zone/A, datum/zas_zone/B)
		Currently identical to A.air.compare(B.air). Returns 1 when directly connected zones are ready to be merged.

	get_edge(datum/zas_zone/A, datum/zas_zone/B)
	get_edge(datum/zas_zone/A, turf/B)
		Gets a valid connection_edge between A and B, creating a new one if necessary.

	has_same_air(turf/A, turf/B)
		Used to determine if an unsimulated edge represents a specific turf.
		Simulated edges use datum/zas_edge/contains_zone() for the same purpose.
		Returns 1 if A has identical gases and temperature to B.

	remove_edge(datum/zas_edge/edge)
		Called when an edge is erased. Removes it from processing.

*/

//
// The rest of the air subsystem is defined in air.dm
//

/datum/controller/subsystem/air
	//Geometry lists
	var/list/zones = list()
	var/list/edges = list()
	//Geometry updates lists
	var/list/tiles_to_update = list()
	var/list/zones_to_update = list()
	var/list/active_fire_zones = list()
	var/list/active_hotspots = list()
	var/list/active_edges = list()

	var/active_zones = 0
	var/current_cycle = 0
	var/next_id = 1 //Used to keep track of zone UIDs.

/datum/controller/subsystem/air/proc/add_zone(datum/zas_zone/z)
	zones.Add(z)
	z.name = "Zone [next_id++]"
	mark_zone_update(z)

/datum/controller/subsystem/air/proc/remove_zone(datum/zas_zone/z)
	zones.Remove(z)
	zones_to_update.Remove(z)

/datum/controller/subsystem/air/proc/merge(datum/zas_zone/A, datum/zas_zone/B)
	#ifdef ZAS_DEBUG
	ASSERT(istype(A))
	ASSERT(istype(B))
	ASSERT(!A.invalid)
	ASSERT(!B.invalid)
	ASSERT(A != B)
	#endif
	if(A.contents.len < B.contents.len)
		A.c_merge(B)
		mark_zone_update(B)
	else
		B.c_merge(A)
		mark_zone_update(A)

/datum/controller/subsystem/air/proc/connect(turf/simulated/A, turf/simulated/B, given_block, given_dir)
	#ifdef ZAS_DEBUG
	ASSERT(istype(A))
	ASSERT(isturf(B))
	ASSERT(A.has_valid_zone())
	//ASSERT(B.zone)
	ASSERT(A != B)
	#endif
	// TODO: find a better way
	// reason we do this here is because if a turf postpones a connect due to no zone,
	// but then joins a zone, it'll try to merge into itself.


	var/block = isnull(given_block)? A.CheckAirBlock(B) : given_block
	if(block == ATMOS_PASS_AIR_BLOCKED)
		return

	var/direct = block == ATMOS_PASS_NOT_BLOCKED

	if(istype(B))
		// we're simulated, not unsim edge
		if(A.zone == B.zone)
			return
		if(min(A.zone.contents.len, B.zone.contents.len) < ZONE_MIN_SIZE || (direct && (equivalent_pressure(A.zone,B.zone) || current_cycle == 0)))
			merge(A.zone, B.zone)
			return

	var/a_to_b = given_dir || get_dir_multiz(A, B)
	var/b_to_a = REVERSE_DIR(a_to_b)

	if(!A.connections)
		A.connections = new
	if(!B.connections)
		B.connections = new

	if(A.connections.get(a_to_b))
		return
	if(B.connections.get(b_to_a))
		return

	var/datum/zas_connection/c = new(A, B)

	A.connections.place(c, a_to_b)
	B.connections.place(c, b_to_a)

	if(direct)
		c.mark_direct()

/datum/controller/subsystem/air/proc/mark_for_update(turf/T)
	#ifdef ZAS_DEBUG
	ASSERT(isturf(T))
	#endif
	tiles_to_update += T
	#ifdef ZAS_DEBUG_GRAPHICS
	T.overlays += mark
	#endif

/datum/controller/subsystem/air/proc/mark_zone_update(datum/zas_zone/Z)
	#ifdef ZAS_DEBUG
	ASSERT(istype(Z))
	#endif
	if(Z.needs_update)
		return
	zones_to_update += Z
	Z.needs_update = 1

/datum/controller/subsystem/air/proc/mark_edge_sleeping(datum/zas_edge/E)
	#ifdef ZAS_DEBUG
	ASSERT(istype(E))
	#endif
	if(E.sleeping)
		return
	active_edges -= E
	E.sleeping = 1

/datum/controller/subsystem/air/proc/mark_edge_active(datum/zas_edge/E)
	#ifdef ZAS_DEBUG
	ASSERT(istype(E))
	#endif
	if(!E.sleeping)
		return
	active_edges += E
	E.sleeping = 0

/datum/controller/subsystem/air/proc/equivalent_pressure(datum/zas_zone/A, datum/zas_zone/B)
	return A.air.compare(B.air)

/datum/controller/subsystem/air/proc/get_edge(datum/zas_zone/A, datum/zas_zone/B)

	if(istype(B))
		for(var/datum/zas_edge/zone/edge in A.edges)
			if(edge.contains_zone(B))
				return edge
		var/datum/zas_edge/edge = new/datum/zas_edge/zone(A,B)
		edges.Add(edge)
		edge.recheck()
		return edge
	else
		for(var/datum/zas_edge/unsimulated/edge in A.edges)
			if(has_same_air(edge.B,B))
				return edge
		var/datum/zas_edge/edge = new/datum/zas_edge/unsimulated(A,B)
		edges.Add(edge)
		edge.recheck()
		return edge

/datum/controller/subsystem/air/proc/has_same_air(turf/A, turf/B)
	return A.initial_gas_mix == B.initial_gas_mix		// bad idea but fuck it.
/*
	if(A.oxygen != B.oxygen) return 0
	if(A.nitrogen != B.nitrogen) return 0
	if(A.phoron != B.phoron) return 0
	if(A.carbon_dioxide != B.carbon_dioxide) return 0
	if(A.temperature != B.temperature) return 0
	return 1
*/

/datum/controller/subsystem/air/proc/remove_edge(datum/zas_edge/E)
	edges.Remove(E)
	if(!E.sleeping) active_edges.Remove(E)
