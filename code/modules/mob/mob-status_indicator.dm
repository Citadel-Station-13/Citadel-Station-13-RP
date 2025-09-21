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
		if(!length(status_indicators)
			status_indicators = null)
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
	for(var/datum/status_indicator/indicator_path as anything in status_indicators)
		var/image/indicator_image = image(indicator_path.icon, indicator_path.icon_state)
		#warn impl
	add_overlay(status_indicator_overlays)
