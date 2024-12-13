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

	/// /obj/item/robot_module typepath
	var/use_robot_module_path = /obj/item/robot_module/robot

	/// Allowed robot frames.
	var/list/datum/allowed_frames = list()

#warn impL
