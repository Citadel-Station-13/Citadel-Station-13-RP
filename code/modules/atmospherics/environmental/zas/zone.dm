/*

Overview:
	Each zone is a self-contained area where gas values would be the same if tile-based equalization were run indefinitely.
	If you're unfamiliar with ZAS, FEA's air groups would have similar functionality if they didn't break in a stiff breeze.

Class Vars:
	name - A name of the format "Zone [#]", used for debugging.
	invalid - True if the zone has been erased and is no longer eligible for processing.
	needs_update - True if the zone has been added to the update list.
	edges - A list of edges that connect to this zone.
	air - The gas mixture that any turfs in this zone will return. Values are per-tile with a group multiplier.

Class Procs:
	add(turf/simulated/T)
		Adds a turf to the contents, sets its zone and merges its air.

	remove(turf/simulated/T)
		Removes a turf, sets its zone to null and erases any gas graphics.
		Invalidates the zone if it has no more tiles.

	c_merge(datum/zas_zone/into)
		Invalidates this zone and adds all its former contents to into.

	c_invalidate()
		Marks this zone as invalid and removes it from processing.

	rebuild()
		Invalidates the zone and marks all its former tiles for updates.

	add_tile_air(turf/simulated/T)
		Adds the air contained in T.air to the zone's air supply. Called when adding a turf.

	tick()
		Called only when the gas content is changed. Archives values and changes gas graphics.

	dbg_data(mob/M)
		Sends M a printout of important figures for the zone.

*/

/datum/zas_zone
	var/name
	var/invalid = 0
	var/list/contents = list()
	var/list/fire_tiles = list()
	var/list/fuel_objs = list()
	var/needs_update = 0
	var/list/edges = list()
	var/datum/gas_mixture/air = new

	var/list/turf_graphics = list()

/datum/zas_zone/New()
	air_master.add_zone(src)
	air.temperature = TCMB
	air.group_multiplier = 1
	air.volume = CELL_VOLUME

/datum/zas_zone/proc/add(turf/simulated/T)
#ifdef ZAS_DEBUG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(!T.has_valid_zone())
#endif

	var/datum/gas_mixture/turf_air = T.return_air()
	add_tile_air(turf_air)
	T.zone = src
	contents.Add(T)
	if(T.fire)
		var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in T
		fire_tiles.Add(T)
		air_master.active_fire_zones |= src
		if(fuel) fuel_objs += fuel
	if(T.allow_gas_overlays && !T.outdoors)
		T.vis_contents += turf_graphics

/datum/zas_zone/proc/remove(turf/simulated/T)
#ifdef ZAS_DEBUG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone == src)
#endif
#ifdef ZAS_DEBUG_EXPENSIVE
	if(!(T in contents))
		stack_trace("Turf was not in contents.")
#endif
	contents.Remove(T)
	fire_tiles.Remove(T)
	if(T.fire)
		var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in T
		fuel_objs -= fuel
	T.zone = null
	T.vis_contents -= turf_graphics
	if(contents.len)
		air.group_multiplier = contents.len
	else
		c_invalidate()

/datum/zas_zone/proc/c_merge(datum/zas_zone/into)
#ifdef ZAS_DEBUG
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif

	c_invalidate()
	for(var/turf/simulated/T in contents)
		T.vis_contents -= turf_graphics
		into.add(T)
		#ifdef ZAS_DEBUG_GRAPHICS
		T.dbg(merged)
		#endif

	//rebuild the old zone's edges so that they will be possessed by the new zone
	for(var/datum/zas_edge/E in edges)
		if(E.contains_zone(into))
			continue //don't need to rebuild this edge
		for(var/turf/T in E.connecting_turfs)
			T.queue_zone_update()

/datum/zas_zone/proc/c_invalidate()
	invalid = 1
	air_master.remove_zone(src)
	#ifdef ZAS_DEBUG_GRAPHICS
	for(var/turf/simulated/T in contents)
		T.dbg(invalid_zone)
	#endif

/datum/zas_zone/proc/rebuild()
	if(invalid)
		return //Short circuit for explosions where rebuild is called many times over.
	c_invalidate()
	for(var/turf/simulated/T in contents)
		T.vis_contents -= turf_graphics
		//T.dbg(invalid_zone)
		T.queue_zone_update()

/datum/zas_zone/proc/add_tile_air(datum/gas_mixture/tile_air)
	//air.volume += CELL_VOLUME
	air.group_multiplier = 1
	air.multiply(contents.len)
	air.merge(tile_air)
	air.divide(contents.len+1)
	air.group_multiplier = contents.len+1

/datum/zas_zone/proc/tick()
	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/firelevel_multiplier, firelevel_multiplier)
	if(air.temperature >= PHORON_FLASHPOINT && !(src in air_master.active_fire_zones) && air.check_combustability() && contents.len)
		var/turf/T = pick(contents)
		if(istype(T))
			T.create_fire(firelevel_multiplier)

	var/list/returned = air.get_turf_graphics()
	if(!(returned ~= turf_graphics))
		var/list/removed = turf_graphics - returned
		var/list/added = returned - turf_graphics
		for(var/turf/simulated/T in contents)
			T.vis_contents -= removed
			if(T.allow_gas_overlays && !T.outdoors)
				T.vis_contents += added
		turf_graphics = returned

	for(var/datum/zas_edge/E in edges)
		if(E.sleeping)
			E.recheck()

/datum/zas_zone/proc/dbg_data(mob/M)
	to_chat(M, name)
	for(var/g in air.gas)
		to_chat(M, "[GLOB.meta_gas_names[g]]: [air.gas[g]]")
	to_chat(M, "P: [air.return_pressure()] kPa V: [air.volume]L T: [air.temperature]�K ([air.temperature - T0C]�C)")
	to_chat(M, "O2 per N2: [(air.gas[/datum/gas/nitrogen] ? air.gas[/datum/gas/oxygen]/air.gas[/datum/gas/nitrogen] : "N/A")] Moles: [air.total_moles]")
	to_chat(M, "Simulated: [contents.len] ([air.group_multiplier])")
	//to_chat(M, "Unsimulated: [unsimulated_contents.len]")
	//to_chat(M, "Edges: [edges.len]")
	if(invalid) to_chat(M, "Invalid!")
	var/zone_edges = 0
	var/space_edges = 0
	var/space_coefficient = 0
	for(var/datum/zas_edge/E in edges)
		if(E.type == /datum/zas_edge/zone) zone_edges++
		else
			space_edges++
			space_coefficient += E.coefficient
			to_chat(M, "[E:air:return_pressure()]kPa")

	to_chat(M, "Zone Edges: [zone_edges]")
	to_chat(M, "Space Edges: [space_edges] ([space_coefficient] connections)")

	//for(var/turf/T in unsimulated_contents)
	//	to_chat(M, "[T] at ([T.x],[T.y])")

/**
 * TODO: SUPERCONDUCTION
 */
