//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* This file contains expensive, cached queries. *//

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
