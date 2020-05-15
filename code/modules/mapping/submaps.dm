/datum/map_template/submap
	abstract_type = /datum/map_template/submap
	var/fixed_orientation = FALSE			//Do not allow random rotations
	var/cost								//cost of spawning - SEE code/__DEFINES/map.dm for guidelines. Set to 0 for free spawns.
	var/default_cost = STANDARD_RUIN_COST	//If cost is not set it defaults to that, if it's null it'll try to calculate automatically.
	var/group_id = SUBMAP_GROUP_ID_DEFAULT
	// The map generator has a set 'budget' it spends to place down different submaps. It will pick available submaps randomly until \
	it runs out. The cost of a submap should roughly corrispond with several factors such as size, loot, difficulty, desired scarcity, etc.

	//Vorestation stuff start
	var/discard_prob = 0
	var/allow_duplicates = FALSE
	var/template_group
	//Vorestation stuff end

/*		Seeding algorithms 2.0 soon(tm)
	var/max_spawns_per_seeding = 1			//max number of times to spawn per seeding
	var/min_spawns_per_seeding = 0			//self explanatory.
	var/max_spawns_global = INFINITY		//across all load operations including admin, only prevents submap seeding though.
	var/priority = 100						//higher priority = seeded first.
	var/priority_decrease_per_spawn = 0		//never goes below 0
	var/discard_prob = 0					//If set to nonzero, mapgen has that chance to completely toss it out for the duration of the seeding pass.
	var/only_one_of_group					//if set, only one template of the group will be spawned.
	var/min_distance_self = 0				//keeps away from other submaps during a single seeding this much
	var/min_distance_other = 3				//keeps other submaps during a single seeding this far away
*/

/datum/map_template/submap/New()
	. = ..()
	if(isnull(cost))
		if(!isnull(default_cost))
			cost = default_cost
		else if(height && width)
			cost = STANDARD_RUIN_COST_CALC_TILES(width * height)

/*
/datum/map_template/submap/proc/standard_autoplace(z,
	var/sanity = RUIN_PLACEMENT_TRIES
	while(sanity > 0)

*/

/datum/submap_group
	var/name = "Group Of Submaps"
	var/desc = "In theory, this is a group of submaps."
	var/id
	var/abstract_type = /datum/submap_group
	var/list/submap_ids
	/*		WIP
	var/min_spawns_per_seeding = 0
	var/max_spawns_per_seeding = INFINITY
	var/max_spawns_global = INFINITY
	var/loaded = 0
	*/

/*
/datum/map_template/ruin/proc/try_to_place(z,allowed_areas)
	var/sanity = PLACEMENT_TRIES
	while(sanity > 0)
		sanity--
		var/width_border = TRANSITIONEDGE + SPACERUIN_MAP_EDGE_PAD + round(width / 2)
		var/height_border = TRANSITIONEDGE + SPACERUIN_MAP_EDGE_PAD + round(height / 2)
		var/turf/central_turf = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z)
		var/valid = TRUE

		for(var/turf/check in get_affected_turfs(central_turf,1))
			var/area/new_area = get_area(check)
			if(!(istype(new_area, allowed_areas)) || check.flags_1 & NO_RUINS_1)
				valid = FALSE
				break

		if(!valid)
			continue

		testing("Ruin \"[name]\" placed at ([central_turf.x], [central_turf.y], [central_turf.z])")

		for(var/i in get_affected_turfs(central_turf, 1))
			var/turf/T = i
			for(var/mob/living/simple_animal/monster in T)
				qdel(monster)
			for(var/obj/structure/flora/ash/plant in T)
				qdel(plant)

		load(central_turf,centered = TRUE)
		loaded++

		for(var/turf/T in get_affected_turfs(central_turf, 1))
			T.flags_1 |= NO_RUINS_1

		new /obj/effect/landmark/ruin(central_turf, src)
		return TRUE
	return FALSE

/datum/submap_loader
	var/list/potentialRuins = list()
	var/budget = 0
	var/z_levels = list()
	//Blacklists override whitelists in a conflict
	var/list/turfWhitelistTypecache
	var/list/turfBlacklistTypecache
	var/list/areaWhitelistTypecache
	var/list/areaBlacklistTypecache

	var/list/map
	var/list/BPrioritySortedRuins
	var/list/


#define SEED_STOPCHECK if(SSmapping.force_stop_seeding) CRASH("SEEDING FORCE STOPPED")
/proc/seedSubmaps(list/z_levels = list(), budget = 0, list/turfWhitelist = STANDARD_SUBMAP_BLOCKING_TURFS, list/areaWhitelist = STANDARD_SUBMAP_BLOCKING_AREAS, list/ruinList)
	SEED_STOPCHECK
	if(!length(z_levels))
		CRASH("No Z levels provided")
	for(var/z in z_levels)
		if(!isturf(locate(1, 1, z)))
			CRASH("Z [z] doesn't exist!")
	turfWhitelist = typecacheof(turfWhitelist)
	areaWhitelist = typecacheof(areaWhitelist)
	ruinList = ruinList.Copy()





	var/list/forced_ruins = list()		//These go first on the z level associated (same random one by default)
	var/list/ruins_availible = list()	//we can try these in the current pass
	var/forced_z	//If set we won't pick z level and use this one instead.

	//Set up the starting ruin list
	for(var/key in ruins)
		var/datum/map_template/ruin/R = ruins[key]
		if(R.cost > budget) //Why would you do that
			continue
		if(R.always_place)
			forced_ruins[R] = -1
		if(R.unpickable)
			continue
		ruins_availible[R] = R.placement_weight

	while(budget > 0 && (ruins_availible.len || forced_ruins.len))
		var/datum/map_template/ruin/current_pick
		var/forced = FALSE
		if(forced_ruins.len) //We have something we need to load right now, so just pick it
			for(var/ruin in forced_ruins)
				current_pick = ruin
				if(forced_ruins[ruin] > 0) //Load into designated z
					forced_z = forced_ruins[ruin]
				forced = TRUE
				break
		else //Otherwise just pick random one
			current_pick = pickweight(ruins_availible)

		var/placement_tries = PLACEMENT_TRIES
		var/failed_to_place = TRUE
		var/z_placed = 0
		while(placement_tries > 0)
			placement_tries--
			z_placed = pick(z_levels)
			if(!current_pick.try_to_place(forced_z ? forced_z : z_placed,whitelist))
				continue
			else
				failed_to_place = FALSE
				break

		//That's done remove from priority even if it failed
		if(forced)
			//TODO : handle forced ruins with multiple variants
			forced_ruins -= current_pick
			forced = FALSE

		if(failed_to_place)
			for(var/datum/map_template/ruin/R in ruins_availible)
				if(R.id == current_pick.id)
					ruins_availible -= R
			log_world("Failed to place [current_pick.name] ruin.")
		else
			budget -= current_pick.cost
			if(!current_pick.allow_duplicates)
				for(var/datum/map_template/ruin/R in ruins_availible)
					if(R.id == current_pick.id)
						ruins_availible -= R
			if(current_pick.never_spawn_with)
				for(var/blacklisted_type in current_pick.never_spawn_with)
					for(var/possible_exclusion in ruins_availible)
						if(istype(possible_exclusion,blacklisted_type))
							ruins_availible -= possible_exclusion
			if(current_pick.always_spawn_with)
				for(var/v in current_pick.always_spawn_with)
					for(var/ruin_name in SSmapping.ruins_templates) //Because we might want to add space templates as linked of lava templates.
						var/datum/map_template/ruin/linked = SSmapping.ruins_templates[ruin_name] //why are these assoc, very annoying.
						if(istype(linked,v))
							switch(current_pick.always_spawn_with[v])
								if(PLACE_SAME_Z)
									forced_ruins[linked] = forced_z ? forced_z : z_placed //I guess you might want a chain somehow
								if(PLACE_LAVA_RUIN)
									forced_ruins[linked] = pick(SSmapping.levels_by_trait(ZTRAIT_LAVA_RUINS))
								if(PLACE_SPACE_RUIN)
									forced_ruins[linked] = pick(SSmapping.levels_by_trait(ZTRAIT_SPACE_RUINS))
								if(PLACE_DEFAULT)
									forced_ruins[linked] = -1
		forced_z = 0

		//Update the availible list
		for(var/datum/map_template/ruin/R in ruins_availible)
			if(R.cost > budget)
				ruins_availible -= R

	log_world("Ruin loader finished with [budget] left to spend.")

*/


///////////////VORESTATION STUFF BELOW
GLOBAL_VAR_INIT(kill_submap_seeding, FALSE)		//emergency kill for this long running proc
// Very similar to the /tg/ version.
/proc/seed_submaps(var/list/z_levels, var/budget = 0, var/whitelist = /area/space, var/desired_map_template_type = null, overall_sanity = 250, default_specific_sanity = 250)
	if(!z_levels || !z_levels.len)
		admin_notice("seed_submaps() was not given any Z-levels.", R_DEBUG)
		return

	for(var/zl in z_levels)
		var/turf/T = locate(1, 1, zl)
		if(!T)
			admin_notice("Z level [zl] does not exist - Not generating submaps", R_DEBUG)
			return

	var/list/potential_submaps = list() // Submaps we may or may not place.
	var/list/priority_submaps = list() // Submaps that will always be placed.

	// Lets go find some submaps to make.
	for(var/map in SSmapping.submap_templates)
		var/datum/map_template/submap/MT = SSmapping.get_map_template(map)
		if(!MT.allow_duplicates && MT.loaded > 0) // This probably won't be an issue but we might as well.
			continue
		if(!istype(MT, desired_map_template_type)) // Not the type wanted.
			continue
		if(MT.discard_prob && prob(MT.discard_prob))
			continue
		if(MT.cost && MT.cost < 0) // Negative costs always get spawned.
			priority_submaps += MT
		else
			potential_submaps += MT

	CHECK_TICK

	var/list/loaded_submap_names = list()
	var/list/template_groups_used = list() // Used to avoid spawning three seperate versions of the same PoI.

	var/list/datum/parsed_map/temp_cache = list()		//delete this after, we're forcing all maps to be cached rn.

	// Now lets start choosing some.
	while(budget > 0 && overall_sanity > 0)
		overall_sanity--
		var/datum/map_template/submap/chosen_template

		if(potential_submaps.len)
			if(priority_submaps.len) // Do these first.
				chosen_template = pick(priority_submaps)
			else
				chosen_template = pick(potential_submaps)

		else // We're out of submaps.
			admin_notice("Submap loader had no submaps to pick from with [budget] left to spend.", R_DEBUG)
			break

		CHECK_TICK
		if(GLOB.kill_submap_seeding)
			return

		var/cache_normally = chosen_template.keep_cached_map

		// Can we afford it?
		if(chosen_template.cost > budget)
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// Did we already place down a very similar submap?
		if(chosen_template.template_group && chosen_template.template_group in template_groups_used)
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue
		chosen_template.preload_size(force_cache = TRUE)
		if(!cache_normally)
			temp_cache += chosen_template.cached_map
		// If so, try to place it.
		var/specific_sanity = default_specific_sanity // A hundred chances to place the chosen submap.
		while(specific_sanity > 0)
			specific_sanity--

			var/orientation
			if(chosen_template.fixed_orientation || !config.random_submap_orientation)
				orientation = SOUTH
			else
				orientation = pick(GLOB.cardinals)

			var/flip_45 = orientation & (NORTH|SOUTH)
			var/width_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + FLOOR((flip_45? chosen_template.height : chosen_template.width) / 2, 1) // %180 catches East/West (90,270) rotations on true, North/South (0,180) rotations on false
			var/height_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + FLOOR((flip_45 ? chosen_template.width : chosen_template.height) / 2, 1)
			var/z_level = pick(z_levels)
			var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z_level)
			var/valid = TRUE

			for(var/turf/check in chosen_template.get_affected_turfs(T,TRUE,orientation))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist)))
					valid = FALSE // Probably overlapping something important.
			//		world << "Invalid due to overlapping with area [new_area.type] at ([check.x], [check.y], [check.z]), when attempting to place at ([T.x], [T.y], [T.z])."
					break
				CHECK_TICK

			CHECK_TICK
			if(GLOB.kill_submap_seeding)
				return

			if(!valid)
				continue

			admin_notice("Submap \"[chosen_template.name]\" placed at ([T.x], [T.y], [T.z])", R_DEBUG)

			// Do loading here.
			chosen_template.load(T, centered = TRUE, orientation = orientation)		// This is run before the main map's initialization routine, so that can initilize our submaps for us instead.

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
			if(chosen_template in priority_submaps) // Always remove priority submaps.
				priority_submaps -= chosen_template
			else if(!chosen_template.allow_duplicates)
				potential_submaps -= chosen_template

			break // Load the next submap.
	QDEL_LIST(temp_cache)
	var/list/pretty_submap_list = list()
	for(var/submap_name in loaded_submap_names)
		var/count = loaded_submap_names[submap_name]
		if(count > 1)
			pretty_submap_list += "[count] <b>[submap_name]</b>"
		else
			pretty_submap_list += "<b>[submap_name]</b>"

	if(!overall_sanity)
		admin_notice("Submap loader gave up with [budget] left to spend.", R_DEBUG)
	else
		admin_notice("Submaps loaded.", R_DEBUG)
	admin_notice("Loaded: [english_list(pretty_submap_list)]", R_DEBUG)
