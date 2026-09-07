//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Generic area used for map-template-like chunks.
 */
/area/submap

/**
 * autodetecting area
 */
/area/submap/auto
	/// replaces [name] if it's not set by context
	var/fallback_name = "Unknown Area"
	/// [name] [count?] [descriptor?]
	var/count
	/// [name] [count?] [descriptor?]
	var/descriptor

/area/submap/auto/preloading_from_mapload(datum/dmm_context/context)
	..()
	auto_name_instance(context.provide_auto_name || fallback_name)

/area/submap/auto/proc/auto_name_instance(use_name)
	src.name = "[use_name][count && " [count]"][descriptor && " [descriptor]"]"
	src.display_name = use_name

/area/submap/auto/one_single_area
