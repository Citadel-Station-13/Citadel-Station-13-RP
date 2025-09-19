//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * zoom system for items to let you zoom around in a radius around you
 *
 * mouse-reactive, unlike just boosting vision range
 */
/datum/component/client_freezoom_handler
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

	/// max zoom
	var/max_zoom_x = WORLD_ICON_SIZE * 7
	/// max zoom
	var/max_zoom_y = WORLD_ICON_SIZE * 7

	/// * in normal mode, this is area in center we don't zoom anywhere else while inside
	var/detection_x = WORLD_ICON_SIZE * 2.5
	/// * in normal mode, this is area in center we don't zoom anywhere else while inside
	var/detection_y = WORLD_ICON_SIZE * 2.5

	/// current pixel offset
	var/current_pixel_x = 0
	/// current pixel offset
	var/current_pixel_y = 0

/datum/component/client_freezoom_handler/Initialize(max_zoom_x, max_zoom_y, detection_x, detection_y, scrolling_mode)
	if((. = ..()) == COMPONENT_INCOMPATIBLE)
		return
	if(!isclient(parent))
		return COMPONENT_INCOMPATIBLE
	if(!isnull(max_zoom_x))
		src.max_zoom_x = max_zoom_x
	if(!isnull(max_zoom_y))
		src.max_zoom_y = max_zoom_y
	if(!isnull(detection_x))
		src.detection_x = detection_x
	if(!isnull(detection_y))
		src.detection_y = detection_y
	if(!isnull(scrolling_mode))
		src.scrolling_mode = scrolling_mode

/datum/component/client_freezoom_handler/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_CLIENT_MOUSE_MOVED, PROC_REF(on_mouse_moved))

/datum/component/client_freezoom_handler/UnregisterFromParent()
	..()
	UnregisterSignal(parent)

/datum/component/client_freezoom_handler/proc/on_mouse_moved(client/source)
	update_zoom(source.mouse_last_move_params)

/datum/component/client_freezoom_handler/proc/update_zoom(list/mouse_params)
	var/client/client = parent

	var/screen_loc = mouse_params["screen-loc"]
	var/list/split = splittext(screen_loc, ":")
	var/list/x_split = splittext(split[1], ",")
	var/list/y_split = splittext(split[2], ",")
	var/s_x = text2num(x_split[1])
	var/s_px = text2num(x_split[2])
	var/s_y = text2num(y_split[1])
	var/s_py = text2num(y_split[2])

	var/calc_x
	var/calc_y

	var/scr_x = s_x * WORLD_ICON_SIZE + s_px
	var/scr_y = s_y * WORLD_ICON_SIZE + s_py

	// normal mode
	var/halfway_x = client.current_viewport_width * 0.5
	var/halfway_y = client.current_viewport_height * 0.5
	var/ranging_x = max(0, halfway_x - detection_x)
	var/ranging_y = max(0, halfway_y - detection_y)
	if(scr_x > halfway_x)
		calc_x = abs(abs((scr_x - halfway_x) - detection_x) / ranging_x) * max_zoom_x
	else
		calc_x = abs(abs((scr_x - halfway_x) + detection_x) / ranging_x) * max_zoom_x
	if(scr_y < halfway_y)
		calc_y = abs(abs((scr_y - halfway_y) - detection_y) / ranging_y) * max_zoom_y
	else
		calc_y = abs(abs((scr_y - halfway_y) + detection_y) / ranging_y) * max_zoom_y

	// TODO: scrolling mode

	move_to(calc_x, calc_y)

/datum/component/client_freezoom_handler/proc/move_to(pixel_x, pixel_y)
	current_pixel_x = pixel_x
	current_pixel_y = pixel_y

	var/client/scrolling = parent
	scrolling.pixel_x = pixel_x
	scrolling.pixel_y = pixel_y
