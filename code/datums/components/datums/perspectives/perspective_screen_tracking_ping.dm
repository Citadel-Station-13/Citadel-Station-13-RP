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

	var/cached_view_x
	var/cached_view_y

/datum/component/perspective_screen_tracking_ping/Initialize(
	atom/movable/target,
	use_icon = 'icons/effects/motion_blip.dmi',
	use_onscreen_icon_state = "cm-motion",
	use_offscreen_icon_state = "cm-motion-offscreen",
	use_text,
)
	if(!istype(parent, /datum/perspective))
		return COMPONENT_INCOMPATIBLE
	if((. = ..()) == COMPONENT_INCOMPATIBLE)
		return
	if(!ismovable(target))
		return COMPONENT_INCOMPATIBLE
	src.target = target
	src.overlay_text = use_text
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(on_target_del))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_target_move))

/datum/component/perspective_screen_tracking_ping/Destroy()
	QDEL_NULL(generated_image)
	return ..()

/datum/component/perspective_screen_tracking_ping/RegisterWithParent()
	..()
	var/datum/perspective/joining = parent
	RegisterSignal(joining, COMSIG_PERSPECTIVE_VIEWSIZE_UPDATE, PROC_REF(on_viewsize_update))
	on_viewsize_update()
	generate_image_if_not_exists()
	update_image()
	if(generated_image)
		joining.add_image(generated_image)

/datum/component/perspective_screen_tracking_ping/UnregisterFromParent()
	..()
	var/datum/perspective/leaving = parent
	if(generated_image)
		leaving.remove_image(generated_image)
	UnregisterSignal(leaving, COMSIG_PERSPECTIVE_VIEWSIZE_UPDATE)

/datum/component/perspective_screen_tracking_ping/proc/on_viewsize_update()
	var/datum/perspective/casted = parent
	cached_view_x = casted.cached_view_width
	cached_view_y = casted.cached_view_height
	update_image()

/datum/component/perspective_screen_tracking_ping/proc/on_target_move()
	update_image()

/datum/component/perspective_screen_tracking_ping/proc/generate_image_if_not_exists()
	#warn impl

/datum/component/perspective_screen_tracking_ping/proc/on_target_del()
	qdel(src)

/datum/component/perspective_screen_tracking_ping/proc/update_image()
	if(!generated_image)
		return
	var/atom/movable/target = src.target

#warn impl; motion sensor state by default
