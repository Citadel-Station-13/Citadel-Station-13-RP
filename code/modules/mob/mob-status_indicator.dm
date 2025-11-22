//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/mob/proc/add_status_indicator(path, source)
	if(!status_indicators)
		status_indicators = list()
	if(!status_indicators[path])
		status_indicators[path] = list()
		add_status_indicator_internal(path)
	status_indicators[path] |= source
	return TRUE

/mob/proc/remove_status_indicator(path, source)
	if(!status_indicators?[path])
		return TRUE
	status_indicators[path] -= source
	if(!length(status_indicators[path]))
		clear_status_indicator(path)
	return TRUE

/mob/proc/clear_status_indicator(path)
	if(!status_indicators)
		return TRUE
	if(status_indicators[path])
		status_indicators -= path
		if(!length(status_indicators))
			status_indicators = null
		remove_status_indicator_internal(path)
	return TRUE

/mob/proc/clear_status_indicators()
	for(var/path in status_indicators)
		clear_status_indicator(path)
	return TRUE

/mob/proc/add_status_indicator_internal(path)
	PRIVATE_PROC(TRUE)
	reload_status_indicators()

/mob/proc/remove_status_indicator_internal(path)
	PRIVATE_PROC(TRUE)
	reload_status_indicators()

/mob/proc/reload_status_indicators()
	cut_overlay(status_indicator_overlays, TRUE)
	status_indicator_overlays = list()
	var/const/row_max = 3
	var/row_count = ceil(length(status_indicators) / row_max)
	// the pixel right below the current row
	var/current_y = icon_y_dimension
	for(var/row in 1 to row_count)
		var/row_start = (row - 1) * row_count
		var/row_size = min(row_max, length(status_indicators) - row_start)
		var/row_total_width = 0
		var/row_max_height = 0
		var/list/image/row_images = list()
		for(var/i in 1 to row_size)
			var/pos = row_start + i
			var/datum/status_indicator/indicator_path = status_indicators[row]
			var/datum/status_indicator/indicator = GLOB.status_indicators[indicator_path]
			if(!indicator)
				status_indicators -= indicator_path
				CRASH("indicator [indicator_path] not found, removing and aborting reload")
			row_total_width += indicator.indicator_size_x
			row_max_height = max(row_max_height, indicator.indicator_size_y)
			var/image/indicator_image = image(indicator_path.icon, indicator_path.icon_state)
			indicator_image.appearance_flags = RESET_COLOR | KEEP_APART
			indicator_image.plane = FLOAT_PLANE
			indicator_image.layer = FLOAT_LAYER
			indicator_image.pixel_y = indicator.alignment_offset_y
			indicator_image.pixel_x = indicator.alignment_offset_x
			indicator_image.pixel_w = indicator.indicator_size_x
			row_images += indicator_image
		var/row_current_x = (WORLD_ICON_SIZE - row_total_width) / 2
		for(var/i in 1 to row_size)
			var/image/image = row_images[i]
			image.pixel_y += current_y
			image.pixel_x += row_current_x
			row_current_x += image.pixel_z
			image.pixel_z = 0
			status_indicator_overlays += image
	add_overlay(status_indicator_overlays)
