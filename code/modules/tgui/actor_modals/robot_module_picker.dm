//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/tgui_actor_modal/robot_module_picker

/datum/tgui_actor_modal/robot_module_picker/ui_act(action, list/params, datum/tgui/ui)
	. = ..()


/datum/tgui_actor_modal/robot_module_picker/ui_data(mob/user, datum/tgui/ui)
	. = ..()


/datum/tgui_actor_modal/robot_module_picker/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

	var/list/datum/robot_frame/pickable_frames = get_pickable_frames(user)
	var/list/serialized_frames = list()
	for(var/datum/robot_frame/serializing_frame as anything in pickable_frames)
		serialized_frames
	.["frames"] = serialized_frames

/datum/tgui_actor_modal/robot_module_picker/ui_interact(mob/user, datum/tgui/ui)
	. = ..()


#warn impl

/datum/tgui_actor_modal/robot_module_picker/proc/get_pickable_frames(mob/living/silicon/robot/for_robot) as /list
	. = list()

	var/list/our_selection_groups = for_robot.conf_module_pick_selection_groups
	for(var/datum/prototype/robot_module/module as anything in RSrobot_modules)
		if(!length(module.selection_groups_all) && !length(module.selection_groups_any))
			continue
		if(length(module.selection_groups_all) != (module.selection_groups_all & our_selection_groups))
			continue
		if(!length(module.selection_groups_any & our_selection_groups))
			continue
		. += module.frames
