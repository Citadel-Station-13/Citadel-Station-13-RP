/datum/map_injection/legacy_seed_submaps
	var/budget = 0
	var/whitelist = /area/space
	var/desired_map_template_type = null

/datum/map_injection/legacy_seed_submaps/New(seed, budget, whitelist, desired_map_template_type)
	..()
	// TODO: seed?
	src.budget = budget
	src.whitelist = whitelist
	src.desired_map_template_type = desired_map_template_type

/datum/map_injection/legacy_seed_submaps/on_map_pre_init(datum/map_context/map_context, datum/dmm_context/dmm_context)
	..()
	var/list/collected_zlevels = collect_zlevels(map_context, dmm_context)
	seed_submaps(collected_zlevels, src.budget, src.whitelist, src.desired_map_template_type)

/datum/map_injection/legacy_seed_submaps/proc/collect_zlevels(datum/map_context/map_context, datum/dmm_context/dmm_context)
	return list()

/datum/map_injection/legacy_seed_submaps/on_dmm_zlevel/collect_zlevels(datum/map_context/map_context, datum/dmm_context/dmm_context)
	. = list()
	for(var/z in dmm_context.loaded_bounds[MAP_MINZ] to dmm_context.loaded_bounds[MAP_MAXZ])
		. += z
