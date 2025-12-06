//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

#define GENERATE_ROBOT_MODULE_PRESET(SUFFIX) \
/mob/living/silicon/robot/module_preset##SUFFIX{ \
	module = /datum/prototype/robot_module##SUFFIX; \
} \
/datum/prototype/robot_module##SUFFIX

//* /datum/prototype/robot_module selection groups *//

#define ROBOT_MODULE_SELECTION_GROUP_NANOTRASEN "nanotrasen"

#define ROBOT_MODULE_SELECTION_GROUP_LEGACY_RED_ALERT "legacy-red-alert"
