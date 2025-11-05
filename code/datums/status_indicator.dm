//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

GLOBAL_LIST_INIT(status_indicators, init_status_indicators())

/proc/init_status_indicators()
	. = list()
	for(var/datum/status_indicator/path as anything in subtypesof(/datum/status_indicator))
		if(path.abstract_type == path)
			continue
		. += new path
	// quack. duck typing to the rescue (and chagrin of whoever has to fix this 2 years later)
	tim_sort(., /proc/cmp_name_asc)

/**
 * A status indicator to be flicked by mobs, primarily.
 * * That said, this ideally contains alignment data that can be used to align it to any atom, so...
 * * Icon states are assumed to be aligned to top right of the icon size. Provide alignment offsets if needed.
 */
/datum/status_indicator
	abstract_type = /datum/status_indicator
	var/name
	var/icon
	var/icon_state

	var/icon_size_x = 32
	var/icon_size_y = 32

#warn impl
