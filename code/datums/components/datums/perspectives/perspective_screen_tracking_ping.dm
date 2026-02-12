//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/component/perspective_screen_tracking_ping
	dupe_mode = COMPONENT_DUPE_ALLOWED

	var/atom/movable/target
	var/turf/last_turf
	var/image/generated_image

	var/update_throttle = 0.2 SECONDS
	var/last_update

	var/overlay_text

#warn default icon/icon state, use_text
/datum/component/perspective_screen_tracking_ping/Initialize(atom/movable/target, use_icon, use_onscreen_icon_state, use_offscreen_icon_state, use_text)
	if(!istype(parent, /datum/perspective))
		return COMPONENT_INCOMPATIBLE
	if((. = ..()) == COMPONENT_INCOMPATIBLE)
		return
	if(!ismovable(target))
		return COMPONENT_INCOMPATIBLE
	src.target = target

/datum/component/perspective_screen_tracking_ping/RegisterWithParent()
	..()
	generate_image_if_not_exists()
	update_image()
	var/datum/perspective/joining = parent
	joining.add_image(generated_image)

/datum/component/perspective_screen_tracking_ping/UnregisterFromParent()
	..()
	var/datum/perspective/leaving = parent
	leaving.remove_image(generated_image)

/datum/component/perspective_screen_tracking_ping/proc/on_target_move()
	update_image()

/datum/component/perspective_screen_tracking_ping/proc/generate_image_if_not_exists()

/datum/component/perspective_screen_tracking_ping/proc/on_target_del()
	qdel(src)

/datum/component/perspective_screen_tracking_ping/proc/update_image()
	var/atom/movable/target = src.target

#warn impl; motion sensor state by default
