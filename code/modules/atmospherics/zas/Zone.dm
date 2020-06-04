/**
  * Atmospherics - Zones
  *
  * ZAS zone mixtures, both holding data of the zone as well as of the air inside.
  * Zone datums being separate was deprecated to save memory as all zones had air mixtures anyways.
  *
  * Each zone is a self-contained area where gas values would be the same if equalized across the entirety of it.
  * This is the basics of how zone-based atmospherics works.
  *
  * Dynamic ZAS:
  * The concept of zone blocking is removed in dynamic ZAS.
  * Instead, you have a situation similar to LINDA/fastmos, in which only air block is used.
  * The difference is, instead of every tile having its own air, air moves as a zone instead.
  * Zone edges transmit air across zones, but also allow zones to "take over" others as needed.
  *
  * High level primer to new dynamic ZAS:
  *
  * ////WIP////
  *
  */
/datum/gas_mixture/turf/zone
	/// Name of the zone, mostly for debugging.
	var/name
	/// Unique ID, ascending.
	var/static/uid_next = 0
	/// If TRUE, this zone is invalid for air processing due to being in the middle of a rebuild, sectioning, merge, or otherwise.
	var/invalid = TRUE
	/// List of turfs
	var/list/turf/turfs = list()
	/// List of zone edges. This is what connects us and flows air between us and other zones.
	var/list/datum/zone_edge/edges = list()
	/// The last SSair cycle we archived our gas.
	var/cycle_archived
	/// The last SSair cycle we processed our edges.

/datum/gas_mixture/turf/zone/New()
	. = ..()
	name = "Zone [++uid_next]"

/datum/gas_mixture/turf/zone/Destroy(force, merged)
	invalid = TRUE

	turfs = null
	edges = null
	return ..()

/**
  * Initial propagation.
  *
  */
/datum/gas_mixture/turf/zone/proc/initialization_propagation(turf/T, flags)

/datum/gas_mixture/turf/zone/proc/zone_share(list/connected)


/**
  * Immediately and forcefully takes over another zone, taking them into ourselves.
  * WARNING: This makes no attempt at verifying if the merging is valid.
  * DO NOT USE THIS PROC UNLESS YOU KNOW WHAT YOU ARE DOING!
  */
/datum/gas_mixture/turf/zone/proc/force_zone_merge(datum/gas_mixture/turf/zone/other)
	if(length(other.turfs) > length(turfs))
		return other.force_zone_merge(src)
	// just in case
	invalid = TRUE
	other.invalid = TRUE
	// gas mixture merge
	merge(other)
	volume += other.volume
	// turfs can't be in two zones at once
	turfs += other.turfs
	// get rid of zones between us and them, but not any other zone.
	var/datum/zone_edge/E
	for(var/i in edges)
		E = i
		if(((E.zone_1 == src) && (E.zone_2 == other)) || ((E.zone_2 == src) && (E.zone_1) == other))
	#warn WIP
	// finally, reset the turfs to point to us and dispose of the other
	var/list/L = other.turfs
	var/turf/T
	for(var/i in L)
		T = i
		T.air_zone = src
	qdel(other, TRUE, TRUE)

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

	c_merge(zone/into)
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


/zone/var/name
/zone/var/invalid = 0
/zone/var/list/contents = list()
/zone/var/list/fire_tiles = list()
/zone/var/list/fuel_objs = list()

/zone/var/needs_update = 0

/zone/var/list/edges = list()

/zone/var/datum/gas_mixture_old/air = new

/zone/var/list/graphic_add = list()
/zone/var/list/graphic_remove = list()

/zone/New()
	air_master.add_zone(src)
	air.temperature = TCMB
	air.group_multiplier = 1
	air.volume = CELL_VOLUME

/zone/proc/add(turf/simulated/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(!air_master.has_valid_zone(T))
#endif

	if(!istype(T))
		return
	var/datum/gas_mixture_old/turf_air = T.return_air()
	add_tile_air(turf_air)
	T.zone = src
	contents.Add(T)
	if(T.fire)
		var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in T
		fire_tiles.Add(T)
		air_master.active_fire_zones |= src
		if(fuel) fuel_objs += fuel
	if(air.graphic)
		T.update_graphic(air.graphic)

/zone/proc/remove(turf/simulated/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone == src)
	soft_assert(T in contents, "Lists are weird broseph")
#endif
	contents.Remove(T)
	fire_tiles.Remove(T)
	if(T.fire)
		var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in T
		fuel_objs -= fuel
	T.zone = null
	if(air.graphic)
		T.update_graphic(graphic_remove = air.graphic)
	if(contents.len)
		air.group_multiplier = contents.len
	else
		c_invalidate()

/zone/proc/c_merge(zone/into)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif
	c_invalidate()
	var/list/air_graphic = air.graphic // Cache for sanic speed
	for(var/turf/simulated/T in contents)
		into.add(T)
		if(air_graphic)
			T.update_graphic(graphic_remove = air_graphic)
		#ifdef ZASDBG
		T.dbg(merged)
		#endif

	//rebuild the old zone's edges so that they will be possessed by the new zone
	for(var/connection_edge/E in edges)
		if(E.contains_zone(into))
			continue //don't need to rebuild this edge
		for(var/turf/T in E.connecting_turfs)
			air_master.mark_for_update(T)

/zone/proc/c_invalidate()
	invalid = 1
	air_master.remove_zone(src)
	#ifdef ZASDBG
	for(var/turf/simulated/T in contents)
		T.dbg(invalid_zone)
	#endif

/zone/proc/rebuild()
	if(invalid) return //Short circuit for explosions where rebuild is called many times over.
	c_invalidate()
	var/list/air_graphic = air.graphic // Cache for sanic speed
	for(var/turf/simulated/T in contents)
		if(air_graphic)
			T.update_graphic(graphic_remove = air_graphic) //we need to remove the overlays so they're not doubled when the zone is rebuilt
		//T.dbg(invalid_zone)
		T.needs_air_update = 0 //Reset the marker so that it will be added to the list.
		air_master.mark_for_update(T)

/zone/proc/add_tile_air(datum/gas_mixture_old/tile_air)
	//air.volume += CELL_VOLUME
	air.group_multiplier = 1
	air.multiply(contents.len)
	air.merge(tile_air)
	air.divide(contents.len+1)
	air.group_multiplier = contents.len+1

/zone/proc/tick()
	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/firelevel_multiplier, firelevel_multiplier)
	if(air.temperature >= PHORON_FLASHPOINT && !(src in air_master.active_fire_zones) && air.check_combustability() && contents.len)
		var/turf/T = pick(contents)
		if(istype(T))
			T.create_fire(firelevel_multiplier)

	if(air.check_tile_graphic(graphic_add, graphic_remove))
		for(var/turf/simulated/T in contents)
			T.update_graphic(graphic_add, graphic_remove)
		graphic_add.len = 0
		graphic_remove.len = 0

	for(var/connection_edge/E in edges)
		if(E.sleeping)
			E.recheck()

/zone/proc/dbg_data(mob/M)
	M << name
	for(var/g in air.gas)
		to_chat(M, "[gas_data.name[g]]: [air.gas[g]]")
	M << "P: [air.return_pressure()] kPa V: [air.volume]L T: [air.temperature]�K ([air.temperature - T0C]�C)"
	M << "O2 per N2: [(air.gas["nitrogen"] ? air.gas["oxygen"]/air.gas["nitrogen"] : "N/A")] Moles: [air.total_moles]"
	to_chat(M, "Simulated: [contents.len] ([air.group_multiplier])")
	//M << "Unsimulated: [unsimulated_contents.len]"
	//M << "Edges: [edges.len]"
	if(invalid) M << "Invalid!"
	var/zone_edges = 0
	var/space_edges = 0
	var/space_coefficient = 0
	for(var/connection_edge/E in edges)
		if(E.type == /connection_edge/zone) zone_edges++
		else
			space_edges++
			space_coefficient += E.coefficient
			to_chat(M, "[E:air:return_pressure()]kPa")

	to_chat(M, "Zone Edges: [zone_edges]")
	to_chat(M, "Space Edges: [space_edges] ([space_coefficient] connections)")

	//for(var/turf/T in unsimulated_contents)
	//	M << "[T] at ([T.x],[T.y])"