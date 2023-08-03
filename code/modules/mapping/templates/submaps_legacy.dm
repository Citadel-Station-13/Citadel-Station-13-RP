
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
			var/width_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(((orientation & NORTH|SOUTH) ? chosen_template.width : chosen_template.height) / 2)
			var/height_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(((orientation & NORTH|SOUTH) ? chosen_template.height : chosen_template.width) / 2)
			var/z_level = pick(z_levels)
			var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z_level)
			var/valid = TRUE

			for(var/turf/check in chosen_template.get_affecting_turfs(T,TRUE,orientation))
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

