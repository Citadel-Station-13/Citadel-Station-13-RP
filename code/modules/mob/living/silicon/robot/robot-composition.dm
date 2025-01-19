//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Hard reset, rebuild from composition.
 */
/mob/living/silicon/robot/proc/rebuild()

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
