/datum/map_template
	/// abstract type
	abstract_type = /datum/map_template

	var/name = "Default Template Name"
	var/desc = "Some text should go here. Maybe."
	/// If this is set, no more than one template in the same group will be spawned, per submap seeding.
	var/template_group = null
	var/width = 0
	var/height = 0
	var/mappath = null
	/// Times loaded this round.
	var/loaded = 0
	/// If true, all (movable) atoms at the location where the map is loaded will be deleted before the map is loaded in.
	var/annihilate = FALSE

	/// The map generator has a set 'budget' it spends to place down different submaps. It will pick available submaps randomly until
	/// it runs out. The cost of a submap should roughly corrispond with several factors such as size, loot, difficulty, desired scarcity, etc.
	/// Set to -1 to force the submap to always be made.
	var/cost = null
	/// If false, only one map template will be spawned by the game. Doesn't affect admins spawning then manually.
	var/allow_duplicates = FALSE
	/// If non-zero, there is a chance that the map seeding algorithm will skip this template when selecting potential templates to use.
	var/discard_prob = 0

	var/static/dmm_suite/maploader = new
	// For ruins
	var/fixed_orientation = FALSE

	/// Zlevel traits
	var/list/ztraits

/datum/map_template/New(path = null, rename = null)
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path, orientation = SOUTH)
	var/bounds = maploader.load_map(file(path), 1, 1, 1, cropMap=FALSE, measureOnly=TRUE, orientation=orientation)
	if(bounds)
		if(orientation & (90 | 270))
			width = bounds[MAP_MAXY]
			height = bounds[MAP_MAXX]
		else
			width = bounds[MAP_MAXX]	// Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
			height = bounds[MAP_MAXY]
	return bounds

/datum/map_template/proc/initTemplateBounds(var/list/bounds)
	if (SSatoms.initialized == INITIALIZATION_INSSATOMS)
		return	// Let proper initialisation handle it later

	var/prev_shuttle_queue_state = SSshuttle.block_init_queue
	SSshuttle.block_init_queue = TRUE

	var/list/atom/atoms = list()
	var/list/area/areas = list()
	var/list/obj/structure/cable/cables = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/turf/turfs = block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
	                   			locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	for(var/L in turfs)
		var/turf/B = L
		B.queue_zone_update()
		QUEUE_SMOOTH(B)
		atoms += B
		areas |= B.loc
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
			else if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A
	atoms |= areas

	admin_notice("<span class='danger'>Initializing newly created atom(s) in submap.</span>", R_DEBUG)
	SSatoms.InitializeAtoms(atoms)

	admin_notice("<span class='danger'>Initializing atmos pipenets and machinery in submap.</span>", R_DEBUG)
	SSmachines.setup_atmos_machinery(atmos_machines)

	admin_notice("<span class='danger'>Rebuilding powernets due to submap creation.</span>", R_DEBUG)
	SSmachines.setup_powernets_for_cables(cables)

	// Ensure all machines in loaded areas get notified of power status
	for(var/I in areas)
		var/area/A = I
		A.power_change()

	SSshuttle.block_init_queue = prev_shuttle_queue_state
	SSshuttle.process_init_queues()	// We will flush the queue unless there were other blockers, in which case they will do it.

	admin_notice("<span class='danger'>Submap initializations finished.</span>", R_DEBUG)

/datum/map_template/proc/load_new_z(var/centered = FALSE, var/orientation = SOUTH, list/traits = src.ztraits || list(ZTRAIT_AWAY = TRUE))
	var/x = 1
	var/y = 1

	if(centered)
		x = round((world.maxx - width)/2)
		y = round((world.maxy - height)/2)

	var/list/bounds = maploader.load_map(file(mappath), x, y, no_changeturf = TRUE, orientation=orientation)
	if(!bounds)
		return FALSE
	SSmapping.add_new_zlevel(name, traits)

	repopulate_sorted_areas()

	// Initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
	log_game("Z-level [name] loaded at at [x],[y],[world.maxz]")
	on_map_loaded(world.maxz)
	return TRUE

/datum/map_template/proc/load(turf/T, centered = FALSE, orientation = SOUTH)
	var/old_T = T
	if(centered)
		T = locate(T.x - round(((orientation & NORTH|SOUTH) ? width : height)/2) , T.y - round(((orientation & NORTH|SOUTH) ? height : width)/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	if(annihilate)
		annihilate_bounds(old_T, centered, orientation)

	var/list/bounds = maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE, orientation = orientation)
	if(!bounds)
		return

//	if(!SSmapping.loading_ruins)	// Will be done manually during mapping ss init
	if(SSmapping.initialized)
		repopulate_sorted_areas()

	// Initialize things that are normally initialized after map load
	initTemplateBounds(bounds)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	loaded++
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE, orientation = SOUTH)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(((orientation & NORTH|SOUTH) ? width : height)/2), placement.y - round(((orientation & NORTH|SOUTH) ? height : width)/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+((orientation & NORTH|SOUTH) ? width : height)-1, placement.y+((orientation & NORTH|SOUTH) ? height : width)-1, placement.z))

/datum/map_template/proc/annihilate_bounds(turf/origin, centered = FALSE, orientation = SOUTH)
	var/deleted_atoms = 0
	log_debug(SPAN_DEBUG("Annihilating objects in submap loading locatation."))
	var/list/turfs_to_clean = get_affected_turfs(origin, centered, orientation)
	if(turfs_to_clean.len)
		for(var/turf/T in turfs_to_clean)
			for(var/atom/movable/AM in T)
				++deleted_atoms
				qdel(AM)
	log_debug(SPAN_DEBUG("Annihilated [deleted_atoms] objects."))


// For your ever biggening badminnery kevinz000
// ❤ - Cyberboss
/proc/load_new_z_level(var/file, var/name, var/orientation = SOUTH)
	var/datum/map_template/template = new(file, name)
	template.load_new_z(orientation)

// Very similar to the /tg/ version.
/proc/seed_submaps(var/list/z_levels, var/budget = 0, var/whitelist = /area/space, var/desired_map_template_type = null)
	set background = TRUE

	if(!z_levels || !z_levels.len)
		CRASH("seed_submaps() was not given any Z-levels.")

	for(var/zl in z_levels)
		var/turf/T = locate(1, 1, zl)
		if(!T)
			CRASH("Z level [zl] does not exist - Not generating submaps")
	log_debug(SPAN_DEBUG("Seeding submaps for levels [english_list(z_levels)] with budget [budget], whitelist [whitelist] and template type [desired_map_template_type]"))

	var/overall_sanity = 100	// If the proc fails to place a submap more than this, the whole thing aborts.
	var/list/potential_submaps = list()	// Submaps we may or may not place.
	var/list/priority_submaps = list()	// Submaps that will always be placed.

	// Lets go find some submaps to make.
	for(var/map in SSmapping.map_templates)
		var/datum/map_template/MT = SSmapping.map_templates[map]
		if(!MT.allow_duplicates && MT.loaded > 0)	// This probably won't be an issue but we might as well.
			continue
		if(!istype(MT, desired_map_template_type))	// Not the type wanted.
			continue
		if(MT.discard_prob && prob(MT.discard_prob))
			continue
		if(MT.cost && MT.cost < 0)	// Negative costs always get spawned.
			priority_submaps += MT
		else
			potential_submaps += MT

	CHECK_TICK

	var/list/loaded_submap_names = list()
	var/list/template_groups_used = list()	// Used to avoid spawning three seperate versions of the same PoI.
	log_debug(SPAN_DEBUG("[potential_submaps.len] potential with [priority_submaps.len] priority maps. Beginning placement."))

	// Now lets start choosing some.
	while(budget > 0 && overall_sanity > 0)
		overall_sanity--
		var/datum/map_template/chosen_template = null

		if(potential_submaps.len)
			if(priority_submaps.len)	// Do these first.
				chosen_template = pick(priority_submaps)
			else
				chosen_template = pick(potential_submaps)

		else	// We're out of submaps.
			log_debug(SPAN_DEBUG("Submap loader had no submaps to pick from with [budget] left to spend."))
			break

		CHECK_TICK

		// Can we afford it?
		if(chosen_template.cost > budget)
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// Did we already place down a very similar submap?
		if(chosen_template.template_group && (chosen_template.template_group in template_groups_used))
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// If so, try to place it.
		var/specific_sanity = 100	// A hundred chances to place the chosen submap.
		while(specific_sanity > 0)
			specific_sanity--
			var/orientation = SOUTH
			chosen_template.preload_size(chosen_template.mappath, orientation)
			var/width_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(((orientation & NORTH|SOUTH) ? chosen_template.width : chosen_template.height) / 2)
			var/height_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(((orientation & NORTH|SOUTH) ? chosen_template.height : chosen_template.width) / 2)
			var/z_level = pick(z_levels)
			var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z_level)
			var/valid = TRUE

			for(var/turf/check in chosen_template.get_affected_turfs(T,TRUE,orientation))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist)))
					valid = FALSE	// Probably overlapping something important.
					// to_chat(world, "Invalid due to overlapping with area [new_area.type] at ([check.x], [check.y], [check.z]), when attempting to place at ([T.x], [T.y], [T.z]).")
					break
				CHECK_TICK

			CHECK_TICK

			if(!valid)
				continue

			log_debug(SPAN_DEBUG("Submap \"[chosen_template.name]\" placed at ([T.x], [T.y], [T.z])[ADMIN_JMP(T)]"))

			// Do loading here.
			chosen_template.load(T, centered = TRUE, orientation=orientation)	// This is run before the main map's initialization routine, so that can initilize our submaps for us instead.

			CHECK_TICK

			// For pretty maploading statistics.
			if(loaded_submap_names[chosen_template.name])
				loaded_submap_names[chosen_template.name] += 1
			else
				loaded_submap_names[chosen_template.name] = 1

			// To avoid two 'related' similar submaps existing at the same time.
			if(chosen_template.template_group)
				template_groups_used += chosen_template.template_group

			// To deduct the cost.
			if(chosen_template.cost >= 0)
				budget -= chosen_template.cost

			// Remove the submap from our options.
			if(chosen_template in priority_submaps)	// Always remove priority submaps.
				priority_submaps -= chosen_template
			else if(!chosen_template.allow_duplicates)
				potential_submaps -= chosen_template

			break	// Load the next submap.

	var/list/pretty_submap_list = list()
	for(var/submap_name in loaded_submap_names)
		var/count = loaded_submap_names[submap_name]
		if(count > 1)
			pretty_submap_list += "[count] [submap_name]"
		else
			pretty_submap_list += "[submap_name]"

	if(!overall_sanity)
		log_debug(SPAN_DEBUG("Submap loader gave up with [budget] left to spend."))
	else
		log_debug(SPAN_DEBUG("Submaps loaded."))
	log_debug(SPAN_DEBUG("Loaded: [english_list(pretty_submap_list)]"))
