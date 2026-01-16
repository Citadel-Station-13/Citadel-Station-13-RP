//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * zoom system for items to let you zoom around in a radius around you
 *
 * mouse-reactive, unlike just boosting vision range
 */
/datum/component/client_freezoom_handler
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

	var/last_update

	/// max zoom radius
	var/max_zoom_pixels = WORLD_ICON_SIZE * 7
	/// center ignore radius
	/// * in normal mode, this is area in center we don't zoom anywhere else while inside
	var/center_ignore_pixels = 0

	/// current pixel offset
	var/current_pixel_x = 0
	/// current pixel offset
	var/current_pixel_y = 0

/datum/component/client_freezoom_handler/Initialize(max_zoom_pixels, center_ignore_pixels, scrolling_mode)
	if((. = ..()) == COMPONENT_INCOMPATIBLE)
		return
	if(!istype(parent, /client))
		return COMPONENT_INCOMPATIBLE
	if(!isnull(max_zoom_pixels))
		src.max_zoom_pixels = max_zoom_pixels
	if(!isnull(center_ignore_pixels))
		src.center_ignore_pixels = center_ignore_pixels
	// if(!isnull(scrolling_mode))
	// 	src.scrolling_mode = scrolling_mode

/datum/component/client_freezoom_handler/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_CLIENT_MOUSE_MOVED, PROC_REF(on_mouse_moved))
	on_mouse_moved(parent)

/datum/component/client_freezoom_handler/UnregisterFromParent()
	..()
	UnregisterSignal(parent, COMSIG_CLIENT_MOUSE_MOVED)
	var/client/client = parent
	client.pixel_x = client.pixel_y = 0

/datum/component/client_freezoom_handler/proc/on_mouse_moved(client/source)
	SIGNAL_HANDLER
	if(world.time - last_update < GLOB.client_mouse_fast_update_backoff)
		return
	last_update = world.time
	update_zoom(source.get_mouse_params())

/datum/component/client_freezoom_handler/proc/update_zoom(list/mouse_params)
	var/client/client = parent

	var/screen_loc = mouse_params["screen-loc"]
	var/list/split = splittext(screen_loc, ",")
	var/list/x_split = splittext(split[1], ":")
	var/list/y_split = splittext(split[2], ":")
	var/s_x = text2num(x_split[1])
	var/s_px = text2num(x_split[2])
	var/s_y = text2num(y_split[1])
	var/s_py = text2num(y_split[2])

	var/calc_x
	var/calc_y

	var/scr_x = s_x * WORLD_ICON_SIZE + s_px
	var/scr_y = s_y * WORLD_ICON_SIZE + s_py

	// normal mode: scroll to % of max zoom with % determined by
	//              the cursor's position from the edge of no-detection box
	//              to 100% of the screen's edge
	// TODO: make it 95% instead

	var/halfway_x = client.current_viewport_width * WORLD_ICON_SIZE * 0.5
	var/halfway_y = client.current_viewport_height * WORLD_ICON_SIZE * 0.5
	var/ranging_x = max(0, halfway_x - center_ignore_pixels)
	var/ranging_y = max(0, halfway_y - center_ignore_pixels)
	if(ranging_x)
		if(scr_x > halfway_x)
			calc_x = max(0, (((scr_x - halfway_x) - center_ignore_pixels) / ranging_x)) * max_zoom_pixels
		else
			calc_x = -max(0, (((halfway_x - scr_x) - center_ignore_pixels) / ranging_x)) * max_zoom_pixels
	if(ranging_y)
		if(scr_y > halfway_y)
			calc_y = max(0, (((scr_y - halfway_y) - center_ignore_pixels) / ranging_y)) * max_zoom_pixels
		else
			calc_y = -max(0, (((halfway_y - scr_y) - center_ignore_pixels) / ranging_y)) * max_zoom_pixels

	// TODO: scrolling mode

	move_to(calc_x, calc_y)

/datum/component/client_freezoom_handler/proc/move_to(pixel_x, pixel_y)
	current_pixel_x = pixel_x
	current_pixel_y = pixel_y

	var/client/scrolling = parent
	animate(scrolling, pixel_x = pixel_x, pixel_y = pixel_y, time = 0.15 SECONDS, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
