//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Hard reset, rebuild from composition.
 *
 * todo: better name?
 */
/mob/living/silicon/robot/proc/rebuild()

/**
 * Annihilate composition
 *
 * todo: better name?
 */
/mob/living/silicon/robot/proc/wipe_for_gc()
	set_chassis(null, TRUE)
	set_iconset(null, TRUE)
	set_module(null, TRUE)

/**
 * Hard reset, to unformatted
 *
 * todo: better name?
 * todo: rework maybe?
 */
/mob/living/silicon/robot/proc/perform_module_reset(perform_transform_animation)
	set_chassis(null, TRUE)
	set_module(null, TRUE)
	set_iconset(RSrobot_iconsets.fetch_local_or_throw(/datum/prototype/robot_iconset/baseline_standard/standard), TRUE)
	rebuild()

	can_repick_frame = TRUE
	can_repick_module = TRUE

	//! legacy
	lights_on = FALSE
	radio.set_light(0)
	if(perform_transform_animation)
		transform_with_anim()
	//! end
	#warn impl

/**
 * Initialize to a chassis
 */
/mob/living/silicon/robot/proc/set_chassis(datum/prototype/robot_chassis/chassis, skip_rebuild)

/**
 * Initialize to a iconset
 */
/mob/living/silicon/robot/proc/set_iconset(datum/prototype/robot_iconset/iconset, skip_rebuild)
	src.iconset = iconset

	if(iconset)
		if(iconset.icon_dimension_x > WORLD_ICON_SIZE || iconset.icon_dimension_y > WORLD_ICON_SIZE)
			zmm_flags |= ZMM_WIDE_LOAD
		else
			zmm_flags &= ~ZMM_WIDE_LOAD
		base_icon_state = iconset.icon_state
		icon = iconset.icon
		// todo: should this be set and not adjust?
		set_base_pixel_x(iconset.base_pixel_x)
		icon_x_dimension = iconset.icon_dimension_x
		icon_y_dimension = iconset.icon_dimension_y
	else
		zmm_flags &= ~ZMM_WIDE_LOAD
		base_icon_state = initial(base_icon_state) || initial(icon_state)
		icon = initial(icon)
		// todo: should this be set and not adjust?
		set_base_pixel_x(0)
		icon_x_dimension = initial(icon_x_dimension)
		icon_y_dimension = initial(icon_y_dimension)

/**
 * Initialize to a module
 */
/mob/living/silicon/robot/proc/set_module(datum/prototype/robot_module/module, skip_rebuild)

/**
 * Set chassis / iconset from a frame.
 */
/mob/living/silicon/robot/proc/set_from_frame(datum/robot_frame/frame, skip_rebuild)
	set_chassis(frame.robot_chassis, TRUE)
	set_iconset(frame.robot_iconset, TRUE)

	if(!skip_rebuild)
		rebuild()

#warn impl
