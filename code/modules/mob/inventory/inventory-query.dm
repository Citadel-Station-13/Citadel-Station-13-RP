//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//! This file contains expensive, cached queries. !//

//* Coverage *//

/**
 * todo: better coverage checks, coverage levels / flags
 *
 * @return null or list() of covering items
 */
/datum/inventory/proc/query_coverage(body_cover_flags) as /list
	if((. = cache["coverage-[body_cover_flags]"]))
		return (.):Copy()
	trim_coverage_cache()
	. = cache["coverage-[body_cover_flags]"] = list()
	for(var/obj/item/worn as anything in get_everything(~INV_FILTER_EQUIPMENT, TRUE))
		if(worn.body_cover_flags & body_cover_flags)
			. += worn
	. = (.):Copy()

/datum/inventory/proc/trim_coverage_cache()
	if(length(cache) > 100)
		cache.len = 100

/datum/inventory/proc/invalidate_coverage_cache()
	cache = list()

//* Siemens Coefficient *//

/**
 * Returns overall siemens coefficient as a result of all covering items.
 *
 * * If multiple cover flags are specified, all items touching any of those coverages are considered.
 *   That's why this says 'simple'.
 *
 * @return overall siemens coefficient as multiplier
 */
/datum/inventory/proc/query_simple_covered_siemens_coefficient(body_cover_flags) as /list
	if(!isnull((. = cache["siemens-single-[body_cover_flags]"])))
		return
	trim_simple_covered_siemens_coefficient_cache()
	. = 1
	for(var/obj/item/worn as anything in get_everything(~INV_FILTER_EQUIPMENT, TRUE))
		if(worn.body_cover_flags & body_cover_flags)
			. *= worn.siemens_coefficient
	cache["siemens-single-[body_cover_flags]"] = .

/datum/inventory/proc/trim_simple_covered_siemens_coefficient_cache()
	if(length(cache) > 100)
		cache.len = 100

/datum/inventory/proc/invalidate_simple_covered_siemens_coefficient_cache()
	cache = list()
