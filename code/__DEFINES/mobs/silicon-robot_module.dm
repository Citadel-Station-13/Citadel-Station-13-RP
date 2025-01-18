//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

#define GENERATE_ROBOT_MODULE_PRESET(SUFFIX) \
/mob/living/silicon/robot/module_preset##SUFFIX{ \
	module_new = /datum/prototype/robot_module##SUFFIX; \
} \
/datum/prototype/robot_module##SUFFIX
