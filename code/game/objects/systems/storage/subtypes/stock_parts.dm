//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/object_system/storage/stock_parts
	ui_numerical_mode = TRUE

/datum/object_system/storage/stock_parts/uses_volumetric_ui()
	return FALSE

/datum/object_system/storage/stock_parts/uses_numerical_ui()
	return TRUE

/datum/object_system/storage/stock_parts/mass_dumping_query()
	var/lowest_rating = INFINITY
	var/list/current_lowest = list()
	for(var/obj/item/item in real_contents_loc())
		var/rating = item.rped_rating()
		if(rating > lowest_rating)
			continue
		else if(rating == lowest_rating)
			current_lowest += item
		else
			current_lowest.len = 0
			current_lowest += item
			lowest_rating = rating
	if(lowest_rating != INFINITY)
		return current_lowest
	return ..()
