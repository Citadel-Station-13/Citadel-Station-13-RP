/datum/map_template
	var/id = "default"
	var/abstract_type = /datum/map_template
	var/autoinit = FALSE			//Init this and keep this at load. Otherwise will be init + kept when needed.
	var/name = "Default Template Name"
	var/desc = "Some text should go here. Maybe."
	var/width = 0				//all these are for SOUTH!
	var/height = 0
	var/zdepth = 1
	var/mappath
	var/loaded = 0 // Times loaded this round
	var/datum/parsed_map/cached_map
	var/keep_cached_map = FALSE
	var/default_annihilate = TEMPLATE_NO_ANNIHILATE			//IMPORTANT: CHECK __DEFINES\map.dm FOR DETAILS!
	var/list/ztraits				//zlevel traits for load_new_z

/datum/map_template/New(path = null, rename = null, cache = FALSE, set_id = null)
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath, cache)
	if(cache)
		keep_cached_map = cache
	if(rename)
		name = rename
	if(set_id)
		id = set_id
	if(initial(id) == "default")
		id = path

/datum/map_template/Destroy()
	QDEL_NULL(cached_map)
	return ..()

/datum/map_template/proc/preload_size(path = mappath, force_cache = FALSE)
	if(cached_map)
		return cached_map.parsed_bounds
	var/datum/parsed_map/parsed = new(file(path))
	var/bounds = parsed?.parsed_bounds
	if(bounds)
		width = bounds[MAP_MAXX] - bounds[MAP_MINX] + 1
		height = bounds[MAP_MAXY] - bounds[MAP_MINY] + 1
		zdepth = bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1
		if(force_cache || keep_cached_map)
			cached_map = parsed
	return bounds

/datum/map_template/proc/get_parsed_bounds()
	. = preload_size(mappath)

/datum/map_template/proc/get_last_loaded_bounds()
	if(cached_map)
		return cached_map.bounds
	return get_parsed_bounds()

/datum/map_template/proc/get_size(orientation = SOUTH)
	if(!width || !height || !zdepth)
		preload_size(mappath)
	var/rotate = (orientation & (NORTH|SOUTH)) != NONE
	if(rotate)
		return list(height, width, zdepth)
	return list(width, height, zdepth)


/datum/parsed_map/proc/initTemplateBounds()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/structure/cable/cables = list()
	var/list/atom/atoms = list()
	var/list/area/areas = list()

	var/list/turfs = block(	locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
							locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	/*
	var/list/border = block(locate(max(bounds[MAP_MINX]-1, 1),			max(bounds[MAP_MINY]-1, 1),			 bounds[MAP_MINZ]),
							locate(min(bounds[MAP_MAXX]+1, world.maxx),	min(bounds[MAP_MAXY]+1, world.maxy), bounds[MAP_MAXZ])) - turfs
	*/
	for(var/L in turfs)
		var/turf/B = L
		atoms += B
		areas |= B.loc
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
				continue
			if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A
	/*
	for(var/L in border)
		var/turf/T = L
		T.air_update_turf(TRUE) //calculate adjacent turfs along the border to prevent runtimes
	*/

	SSmapping.reg_in_areas_in_z(areas)
	SSatoms.InitializeAtoms(atoms)
	SSmachines.setup_powernets_for_cables(cables)
	SSmachines.setup_atmos_machinery(atmos_machines)			//SSair when?!

/datum/map_template/proc/load_new_z(orientation = SOUTH, list/ztraits = src.ztraits || list(ZTRAIT_AWAY = TRUE), centered = TRUE)
	var/x = centered? max(FLOOR((world.maxx - width) / 2, 1), 1) : 1
	var/y = centered? max(FLOOR((world.maxy - height) / 2, 1), 1) : 1

	var/datum/space_level/level = SSmapping.add_new_zlevel(name, ztraits)
	var/datum/parsed_map/parsed = load_map(file(mappath), x, y, level.z_value, no_changeturf=(SSatoms.initialized == INITIALIZATION_INSSATOMS), placeOnTop = FALSE, orientation = orientation)
	var/list/bounds = parsed.bounds
	if(!bounds)
		return FALSE

	repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	parsed.initTemplateBounds()
	/*
	smooth_zlevel(world.maxz)
	*/
	log_game("Z-level [name] ([id]) loaded at at [x],[y],[world.maxz]")
	on_map_loaded(world.maxz, parsed.bounds)

	return level

//Override for custom behavior
/datum/map_template/proc/on_map_loaded(z, list/bounds)
	loaded++

/datum/map_template/proc/load(turf/T, centered = FALSE, orientation = SOUTH, annihilate = default_annihilate, force_cache = FALSE)
	var/old_T = T
	if(centered)
		T = locate(T.x - FLOOR(((orientation & (NORTH|SOUTH))? width : height) / 2, 1) , T.y - FLOOR(((orientation & (NORTH|SOUTH)) ? height : width) / 2, 1) , T.z) // %180 catches East/West (90,270) rotations on true, North/South (0,180) rotations on false
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	if(annihilate == TEMPLATE_ANNIHILATE_BEFORE_LOAD)
		annihilate_bounds(old_T, centered, orientation)

	// Accept cached maps, but don't save them automatically - we don't want
	// ruins clogging up memory for the whole round.
	var/is_cached = cached_map
	var/datum/parsed_map/parsed = is_cached || new(file(mappath))
	cached_map = (force_cache || keep_cached_map) ? parsed : is_cached
	if(!parsed.load(T.x, T.y, T.z, cropMap=TRUE, no_changeturf=(SSatoms.initialized == INITIALIZATION_INSSATOMS), placeOnTop=TRUE, orientation = orientation, annihilate_tiles = (annihilate == TEMPLATE_ANNIHILATE_IN_LOAD)))
		return
	var/list/bounds = parsed.bounds
	if(!bounds)
		return

	if(!SSmapping.loading_ruins) //Will be done manually during mapping ss init
		repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	parsed.initTemplateBounds()

	on_map_loaded(T.z, parsed.bounds)

	log_game("[name] ([id]) loaded at at [T.x],[T.y],[T.z]")
	return bounds

//This, get_affected_turfs, and load() calculations for bounds/center can probably be optimized. Later.
/datum/map_template/proc/annihilate_bounds(turf/origin, centered = FALSE, orientation = SOUTH)
	log_world("Annihilating objects in submap loading locatation.")
	var/list/turfs_to_clean = get_affected_turfs(origin, centered, orientation)
	if(turfs_to_clean.len)
		for(var/i in turfs_to_clean)
			var/turf/T = i
			T.empty(FALSE)

//for your ever biggening badminnery kevinz000
//❤ - Cyberboss
/proc/load_new_z_level(file, name, orientation, list/ztraits)
	var/datum/map_template/template = new(file, name)
	template.load_new_z(orientation, ztraits)

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE, orientation = SOUTH)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - FLOOR(((orientation & (NORTH|SOUTH))? width : height) / 2, 1), placement.y - FLOOR(((orientation & (NORTH|SOUTH))? height : width) / 2, 1), placement.z) // %180 catches East/West (90,270) rotations on true, North/South (0,180) rotations on false
		if(corner)
			placement = corner
	return block(placement, locate(placement.x + ((orientation & (NORTH|SOUTH)) ? width : height) - 1, placement.y + ((orientation & (NORTH|SOUTH))? height : width) - 1, placement.z))
