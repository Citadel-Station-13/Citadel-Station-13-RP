//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Hard reset, rebuild from composition.
 *
 * todo: better name?
 */
/mob/living/silicon/robot/proc/rebuild()
	// todo: wipe whatever state is left
	set_chassis(chassis)
	set_iconset(iconset)
	set_module(module)

/**
 * Annihilate composition
 *
 * todo: better name?
 */
/mob/living/silicon/robot/proc/wipe_for_gc()
	set_chassis(null)
	set_iconset(null)
	set_module(null)

/**
 * Hard reset, to unformatted
 *
 * todo: better name?
 * todo: rework maybe?
 */
/mob/living/silicon/robot/proc/perform_module_reset(perform_transform_animation)
	set_chassis(null)
	set_module(null)
	set_iconset(RSrobot_iconsets.fetch_local_or_throw(/datum/prototype/robot_iconset/baseline_standard/standard))

	can_repick_frame = TRUE
	can_repick_module = TRUE

	//! legacy
	lights_on = FALSE
	radio.set_light(0)
	if(perform_transform_animation)
		transform_with_anim()
	//! end
	#warn impl

/mob/living/silicon/robot/proc/get_module_pick_groups()
	SHOULD_NOT_OVERRIDE(TRUE)
	. = conf_module_pick_selection_groups ? conf_module_pick_selection_groups.Copy() : list()
	. |= get_module_pick_groups_special()
	. -= conf_module_pick_selection_groups_excluded

/mob/living/silicon/robot/proc/get_module_pick_groups_special()
	. = list()
	//! todo: rework security levels
	if(get_security_level() >= SEC_LEVEL_RED)
		. |= ROBOT_MODULE_SELECTION_GROUP_LEGACY_RED_ALERT
	//! end

/**
 * Initialize to a chassis
 */
/mob/living/silicon/robot/proc/set_chassis(datum/prototype/robot_chassis/chassis)
	src.chassis = chassis

	#warn impl

/**
 * Initialize to a iconset
 */
/mob/living/silicon/robot/proc/set_iconset(datum/prototype/robot_iconset/iconset)
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

	update_icon()

/**
 * Initialize to a module
 */
/mob/living/silicon/robot/proc/set_module(datum/prototype/robot_module/module)
	src.module = module

	#warn impl

/**
 * Set chassis / iconset from a frame.
 */
/mob/living/silicon/robot/proc/set_from_frame(datum/robot_frame/frame)
	set_chassis(frame.robot_chassis, TRUE)
	set_iconset(frame.robot_iconset, TRUE)

	#warn impl
