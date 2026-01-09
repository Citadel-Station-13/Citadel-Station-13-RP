//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Hard reset, rebuild from composition.
 *
 * todo: better name?
 */
/mob/living/silicon/robot/proc/rebuild()
	set_chassis(chassis, TRUE)
	set_iconset(iconset, TRUE)
	set_module(module, TRUE)
	// TODO: what about upgrades
	update_icon()

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
	set_iconset(
		RSrobot_iconsets.fetch_local_or_throw(/datum/prototype/robot_iconset/baseline_standard/standard),
		TRUE,
	)
	update_icon()
	can_repick_frame = TRUE
	can_repick_module = TRUE

	//! legacy
	lights_on = FALSE
	radio.set_light(0)
	if(perform_transform_animation)
		transform_with_anim()
	//! end

/mob/living/silicon/robot/proc/get_module_pick_groups()
	SHOULD_NOT_OVERRIDE(TRUE)
	. = conf_module_pick_selection_groups ? conf_module_pick_selection_groups.Copy() : list()
	. |= get_module_pick_groups_special()
	. -= conf_module_pick_selection_groups_excluded

/mob/living/silicon/robot/proc/get_module_pick_groups_special()
	. = list(
		ROBOT_MODULE_SELECTION_GROUP_NANOTRASEN,
	)
	//! todo: rework security levels
	if(GLOB.security_level >= SEC_LEVEL_RED)
		. |= ROBOT_MODULE_SELECTION_GROUP_LEGACY_RED_ALERT
	//! end

/mob/living/silicon/robot/proc/get_default_iconset()
	if(module?.auto_iconsets?.len > 0)
		. = RSrobot_iconsets.fetch_local_or_throw(pick(module.auto_iconsets))
		if(.)
			return
	return RSrobot_iconsets.fetch_local_or_throw(/datum/prototype/robot_iconset/baseline_standard/standard)

/**
 * Initialize to a chassis
 *
 * * Will re-init if it's the same one.
 */
/mob/living/silicon/robot/proc/set_chassis(datum/prototype/robot_chassis/chassis, skip_icon_update)
	// cleanup
	if(chassis_provisioning)
		QDEL_NULL(chassis_provisioning)
	// set
	src.chassis = chassis
	// build
	if(!chassis)
		return
	chassis_provisioning = chassis.create_provisioning()
	chassis_provisioning.apply(src)

/**
 * Initialize to a iconset
 *
 * * Iconset may never be null, as otherwise we can't render.
 * * Will re-init if it's the same one.
 */
/mob/living/silicon/robot/proc/set_iconset(datum/prototype/robot_iconset/iconset, skip_icon_update)
	// Iconset will never be null.
	if(isnull(iconset))
		iconset = get_default_iconset()
	src.iconset = iconset

	if(iconset)
		if(iconset.icon_dimension_x > WORLD_ICON_SIZE || iconset.icon_dimension_y > WORLD_ICON_SIZE)
			zmm_flags |= ZMM_WIDE_LOAD
		else
			zmm_flags &= ~ZMM_WIDE_LOAD
		base_icon_state = iconset.icon_state
		icon = iconset.icon
		icon_x_dimension = iconset.icon_dimension_x
		icon_y_dimension = iconset.icon_dimension_y
		// reset resting variation if needed
		if(!iconset.variations?[picked_resting_variation])
			picked_resting_variation = null
	else
		zmm_flags &= ~ZMM_WIDE_LOAD
		base_icon_state = initial(base_icon_state) || initial(icon_state)
		icon = initial(icon)
		icon_x_dimension = initial(icon_x_dimension)
		icon_y_dimension = initial(icon_y_dimension)
		// reset resting variation
		picked_resting_variation = null

	auto_pixel_offset_to_center()
	if(!skip_icon_update)
		update_icon()

/**
 * Initialize to a module
 *
 * * Will re-init if it's the same one.
 */
/mob/living/silicon/robot/proc/set_module(datum/prototype/robot_module/module, skip_icon_update)
	// cleanup
	if(module_provisioning)
		QDEL_NULL(module_provisioning)
	if(module_legacy)
		module_legacy.Reset()
		QDEL_NULL(module_legacy)
	// set
	src.module = module

	//! -- LEGACY SCREEN / IDENTITY THINGY --
	src.hands?.icon_state = "none"
	src.modtype = "Default"
	//! -- END --

	// build
	if(!module)
		return
	module_provisioning = module.create_provisioning()
	module_provisioning.apply(src)
	module_legacy = new module.use_robot_module_path(src)
	can_repick_module = FALSE

	// this entire section is weird but it's the only way to do it for now
	// what we need is to not have magic regen materials so provisioning can also
	// be properly composition based and stateful, but for now we don't care
	resources.wipe_provisioning()
	resources.prep_provisioning()
	module.provision_resource_store(resources)
	resources.finish_provisioning()

	//! -- LEGACY SCREEN / IDENTITY THINGY --
	src.hands?.icon_state = module.module_hud_state
	src.modtype = module.get_display_name()
	//! -- END --

	if(!skip_icon_update)
		update_icon()

/**
 * Set chassis / iconset from a frame.
 */
/mob/living/silicon/robot/proc/set_from_frame(datum/robot_frame/frame)
	set_chassis(frame.robot_chassis, TRUE)
	set_iconset(frame.robot_iconset, TRUE)
	can_repick_frame = FALSE

/**
 * Apply a provisioning set; this is one of the things orchestrating composition.
 * * Should only be called by `/datum/robot_provisioning`.
 */
/mob/living/silicon/robot/proc/apply_provisioning(datum/robot_provisioning/provisioning)
	// TODO: this is unused?

/**
 * Remove a provisioning set; this is one of the things orchestrating composition.
 * * Should only be called by `/datum/robot_provisioning`.
 */
/mob/living/silicon/robot/proc/remove_provisioning(datum/robot_provisioning/provisioning)
	// TODO: this is unused?
