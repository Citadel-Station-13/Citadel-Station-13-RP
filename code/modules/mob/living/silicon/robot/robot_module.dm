//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

#warn #define DECLARE_ROBOT_MODULE?

/**
 * The baseline configuration for a silicon.
 *
 * Contains:
 *
 * * Inbuilt items
 * * WIP
 */
/datum/prototype/robot_module
	abstract_type = /datum/prototype/robot_module

	/// Allow selection
	//  todo: replace with selection class / groups / something to that effect
	var/selectable = FALSE

	/// /obj/item/robot_module typepath
	var/use_robot_module_path = /obj/item/robot_module/robot

	/// Allowed robot frames.
	/// * set to list of typepaths/anonymous types to init
	var/list/datum/robot_frame/allowed_frames = list()

#warn impL
#warn init frames
