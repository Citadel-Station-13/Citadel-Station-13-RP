//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/dmm_scan_params
	var/list/trivial_typecache = null

	var/list/typepaths_of_interest = null
	/**
	 * * high-performance variant of typepaths_of_interest so it's not
	 *   regenerated every time. overrides it if set.
	 */
	var/list/zebra_typecache_of_interest = null

/datum/dmm_scan
	var/is_map_empty

	var/nontrivial_bl_x
	var/nontrivial_bl_y
	var/nontrivial_tr_x
	var/nontrivial_tr_y
	var/nontrivial_width
	var/nontrivial_height

	/// typepath --> list(list(x, y), ...)
	var/list/typepaths_of_interest

/datum/dmm_scan/proc/scan(datum/dmm_parsed/parsed, datum/dmm_scan_params/params)
	if(!parsed || !params)
		CRASH("invalid arguments to dmm_scan constructor")

	var/list/trivial_typecache = params.trivial_typecache || cached_typecacheof(list(
		/turf/template_noop,
		/area/template_noop,
	))
	var/list/interesting_typecache
	if(params.zebra_typecache_of_interest)
		interesting_typecache = params.zebra_typecache_of_interest
	else
		var/list/transformed_interesting_typepaths = list()
		for(var/typepath in params.typepaths_of_interest)
			transformed_interesting_typepaths[typepath] = typepath
		interesting_typecache = zebra_typecacheof(transformed_interesting_typepaths)

#warn impl all
