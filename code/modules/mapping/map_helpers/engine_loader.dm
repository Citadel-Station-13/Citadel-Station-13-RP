// Landmark for where to load in the engine on permament map
/obj/map_helper/engine_loader
	name = "Engine Loader"
	early = TRUE
	var/list/clean_turfs // A list of lists, where each list is (x, )
	// override for map, otherwise defaults to loaded station as we have no way of detecting what's being loaded right now
	var/for_map

/obj/map_helper/engine_loader/New()
	return ..()

/obj/map_helper/engine_loader/Initialize(mapload)
	return ..()

/obj/map_helper/engine_loader/map_initializations(list/bounds, lx, ly, lz, ldir)
	. = ..()
	if(istext(clean_turfs))
		clean_turfs = safe_json_decode(clean_turfs)
	if(ispath(for_map))
		var/datum/map/map_path = for_map
		for_map = initial(map_path.id)
	if(isnull(for_map))
		for_map = SSmapping.loaded_station.id

	var/datum/map_template/engine/chosen
	var/list/probabilities = CONFIG_GET(keyed_list/engine_submap)

	var/list/potential_subtypes = subtypesof(/datum/map_template/engine)
	var/list/potential_filtered = list()

	for(var/datum/map_template/engine/path as anything in potential_subtypes)
		if(initial(path.abstract_type) == path)
			continue
		var/their_for_map = initial(path.for_map)
		if(ispath(their_for_map))
			var/datum/map/map_path = their_for_map
			their_for_map = initial(map_path.id)
		if(their_for_map != src.for_map)
			continue
		var/name = initial(path.name)
		potential_filtered[path] = isnum(probabilities[name])? probabilities[name] : 1

	var/picked_path = pickweightAllowZero(potential_filtered)

	if(isnull(picked_path))
		STACK_TRACE("no chosen engine")
		qdel(src)

	chosen = new picked_path

	var/turf/our_loc = get_turf(src)
	var/real_x = our_loc.x
	var/real_y = our_loc.y
	switch(ldir)
		if(SOUTH)
		if(NORTH)
			real_x -= chosen.width - 1
			real_y -= chosen.height - 1
		if(EAST)
			real_x -= chosen.width - 1
		if(WEST)
			real_y -= chosen.height - 1

	var/turf/T = locate(real_x, real_y, our_loc.z)
	ASSERT(T)

	SSmapping.subsystem_log("initializing engine [chosen.name] at [COORD(T)]")
	if(!SSmapping.initialized)
		to_chat(world, SPAN_DANGER("Engine loaded: [chosen.display_name]"))

	annihilate_bounds(lx, ly, lz, ldir)
	chosen.load(T, orientation = ldir)

	qdel(src)


/obj/map_helper/engine_loader/proc/get_turfs_to_clean(lx, ly, lz, ldir)
	. = list()
	if(clean_turfs)
		for(var/list/coords in clean_turfs)
			var/bx = coords[1]
			var/by = coords[2]
			var/tx = coords[3]
			var/ty = coords[4]
			switch(ldir)
				if(SOUTH)
				else
					// this doesn't work because we can't reliably get width/height of load
					// we have list/bounds but we shouldn't rely on it
					// and this stupid annihilate bounds shit should be relative to the loader anyways.
					return list()
			. += block(locate(bx, by, z), locate(tx, ty, z))

/obj/map_helper/engine_loader/proc/annihilate_bounds(lx, ly, lz, ldir)
	var/deleted_atoms = 0
	admin_notice("<span class='danger'>Annihilating objects in engine loading locatation.</span>", R_DEBUG)
	var/list/turfs_to_clean = get_turfs_to_clean(lx, ly, lz, ldir)
	if(turfs_to_clean.len)
		for(var/x in 1 to 2) // Requires two passes to get everything.
			for(var/turf/T in turfs_to_clean)
				for(var/atom/movable/AM in T)
					++deleted_atoms
					qdel(AM)
	admin_notice("<span class='danger'>Annihilated [deleted_atoms] objects.</span>", R_DEBUG)

