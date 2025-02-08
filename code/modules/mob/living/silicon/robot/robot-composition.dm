//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Hard reset, rebuild from composition.
 */
/mob/living/silicon/robot/proc/rebuild()

/**
 * Hard reset, to unformatted
 *
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

	if(iconset.icon_dimension_x > 32 || iconset.icon_dimension_y > 32)
		zmm_flags |= ZMM_LOOKAHEAD
	else
		zmm_flags &= ~ZMM_LOOKAHEAD

	base_icon_state = iconset.icon_state

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
