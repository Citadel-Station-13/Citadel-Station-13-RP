/*

Overview:
	Each zone is a self-contained area where gas values would be the same if tile-based equalization were run indefinitely.
	If you're unfamiliar with ZAS, FEA's air groups would have similar functionality if they didn't break in a stiff breeze.

Class Vars:
	name - A name of the format "Zone [#]", used for debugging.
	needs_update - True if the zone has been added to the update list.
	edges - A list of edges that connect to this zone.

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
	var/list/fuel_objs = list()
	var/needs_update = 0
	var/list/edges = list()

	/// turfs in us
	var/list/turf/contents = list()
	/// invaild - if a turf ever has an invalid zone, something's awry.
	var/invalid = FALSE
	/// the air in us
	var/datum/gas_mixture/zone/air
	/// are we burning
	var/on_fire = FALSE
	/// turfs that are on fire
	var/list/turf/fire_tiles = list()
	/// turf graphics to put in turf vis contents
	var/list/turf_graphics = list()

/datum/zas_zone/New()
	air_master.add_zone(src)
	air = new(CELL_VOLUME)

/datum/zas_zone/Destroy()
	air_master.remove_zone(src)
	breakdown()
	return ..()

/**
 * adds a turf into us. this is cheap.
 */
/datum/zas_zone/proc/add(turf/T)
#ifdef ZAS_DEBUG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(!T.zone)
#endif
	// add
	if(T.air)
		air.merge_and_expand(T.air)
		qdel(T.air)
		T.air = null
	else
		air.volume += CELL_VOLUME
	T.zone = src
	contents += T

	// graphics
	if(T.allow_gas_overlays())
		T.vis_contents += turf_graphics

	// fire
	if(T.fire)
		fire_tiles += T
		if(!on_fire)
			mark_on_fire()
		// TODO: reactions, generic fuel fire
		var/obj/effect/deal/cleanable/liquid_fuel/fuel = locate() in T
		if(fuel)
			fuel_objs += fuel

/**
 * eats all the turfs from this list.
 */
/datum/zas_zone/proc/add_all(list/turf/turfs)
	for(var/turf/T as anything in turfs)
		add(T)

/**
 * removes a turf from us. avoid calling this alone! this is expensive.
 */
/datum/zas_zone/proc/remove(turf/T)
#ifdef ZAS_DEBUG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone == src)
	ASSERT(!T.air)
#endif

	// remove
	contents -= T
	T.zone = null
	T.vis_contents -= turf_graphics
	T.air = air.remove_and_shrink()

	// fire
	fire_tiles -= T
	if(!fire_tiles.len && on_fire)
		unmark_on_fire()
	if(T.fire)
		var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in T
		fuel_objs -= fuel

/**
 * removes all turfs from us. this is cheap in comparison to calling remove() on every turf!
 */
/datum/zas_zone/proc/breakdown()
	#warn fin


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
		#ifdef ZAS_DEBUG
		T.dbg(merged)
		#endif

	//rebuild the old zone's edges so that they will be possessed by the new zone
	for(var/datum/zas_edge/E in edges)
		if(E.contains_zone(into))
			continue //don't need to rebuild this edge
		for(var/turf/T in E.connecting_turfs)
			air_master.mark_for_update(T)

/datum/zas_zone/proc/mark_on_fire()
	on_fire = TRUE
	SSair.active_fire_zones += src

/datum/zas_fire/proc/unmark_on_fire()
	on_fire = FALSE
	SSair.active_fire_zones -= src

/datum/zas_zone/proc/c_invalidate()
	invalid = 1
	air_master.remove_zone(src)
	#ifdef ZAS_DEBUG
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
		T.needs_air_update = 0 //Reset the marker so that it will be added to the list.
		air_master.mark_for_update(T)

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
 * unsimulated, immutable zones
 */
/datum/zas_zone/unsimulated
#warn ugh
