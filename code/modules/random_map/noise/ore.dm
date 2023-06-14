/datum/random_map/noise/ore
	descriptor = "ore distribution map"
	var/deep_val = 0.8              // Threshold for deep metals, set in new as percentage of cell_range.
	var/rare_val = 0.7              // Threshold for rare metal, set in new as percentage of cell_range.
	var/chunk_size = 4              // Size each cell represents on map

	var/list/surface_metals = list(
		/datum/material/solid/metal/iron =              list(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX),
		/datum/material/solid/metal/copper =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/datum/material/solid/metal/gold =              list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/datum/material/solid/metal/silver =            list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/datum/material/solid/metal/uranium =           list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
	)
	var/list/rare_metals = list(
		/datum/material/solid/metal/gold =              list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/datum/material/solid/metal/silver =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/datum/material/solid/metal/uranium =           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/datum/material/solid/metal/osmium =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/datum/material/solid/exotic/phoron =           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
	)
	var/list/deep_metals = list(
		/datum/material/solid/metal/uranium =           list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/datum/material/solid/gemstone/diamond =        list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/datum/material/solid/metal/osmium =            list(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX),
		/datum/material/solid/nuclear/mhydrogen =       list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/datum/material/solid/exotic/verdantium =       list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
	)
	var/list/common_resources = list(
		/datum/material/solid/sand =   list(3,5),
		/datum/material/solid/organic/carbon = list(3,5)
	)

/datum/random_map/noise/ore/New()
	rare_val = cell_range * rare_val
	deep_val = cell_range * deep_val
	..()

/datum/random_map/noise/ore/check_map_sanity()

	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	// Sanity check.
	if(surface_count < MIN_SURFACE_COUNT)
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < MIN_RARE_COUNT)
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < MIN_DEEP_COUNT)
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1

/datum/random_map/noise/ore/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process)
				sleep(-1)
			LAZYINITLIST(T.resources)

			for(var/val in common_resources)
				var/list/ranges = common_resources[val]
				var/res_num = rand(ranges[1], ranges[2])
				if(res_num == 0)
					continue
				T.resources[val] = res_num

			var/tmp_cell
			var/spawning
			if(tmp_cell < rare_val)
				spawning = surface_metals
			else if(tmp_cell < deep_val)
				spawning = rare_metals
			else
				spawning = deep_metals

			for(var/val in spawning)
				var/list/ranges = spawning[val]
				var/res_num = rand(ranges[1], ranges[2])
				if(res_num == 0)
					continue
				T.resources[val] = res_num

	return

/datum/random_map/noise/ore/get_map_char(var/value)
	if(value < rare_val)
		return "S"
	else if(value < deep_val)
		return "R"
	else
		return "D"
