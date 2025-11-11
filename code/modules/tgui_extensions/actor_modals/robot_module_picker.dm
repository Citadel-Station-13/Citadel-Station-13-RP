//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/tgui_actor_modal/robot_module_picker

/datum/tgui_actor_modal/robot_module_picker/ui_act(action, list/params, datum/tgui/ui)
	. = ..()


/datum/tgui_actor_modal/robot_module_picker/ui_data(mob/user, datum/tgui/ui)
	. = ..()


/datum/tgui_actor_modal/robot_module_picker/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

	var/list/datum/prototype/robot_module/pickable_modules = assemble_modules(user)
	var/list/serialized_modules = list()
	.["modules"] = serialized_modules
	for(var/datum/prototype/robot_module/possible_module as anything in pickable_modules)
		var/list/serialized_frames = list()
		var/list/serialized_module = list(
			"name" = possible_module.get_display_name(),
			"frames" = serialized_frames,
		)
		var/list/datum/robot_frame/possible_frames = pickable_modules[possible_module]
		for(var/datum/robot_frame/possible_frame as anything in possible_frames)
			serialized_frames[++serialized_frames.len] = list()
			#warn impl
		serialized_modules[++serialized_modules.len] = serialized_module

/datum/tgui_actor_modal/robot_module_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "actor_modal/RobotModulePicker.tsx")
		ui.set_autoupdate(FALSE)
		ui.open()

#warn impl

/**
 * @return list(
 * 	module instance = list(
 *     frame instance,
 *   ),
 * )
 */
/datum/tgui_actor_modal/robot_module_picker/proc/assemble_modules(mob/living/silicon/robot/for_robot) as /list
	. = list()

	var/list/our_selection_groups = for_robot.get_module_pick_groups()
	for(var/datum/prototype/robot_module/module as anything in RSrobot_modules.fetch_multi(/datum/prototype/robot_module))
		if(!length(module.selection_groups_all) && !length(module.selection_groups_any))
			continue
		if(length(module.selection_groups_all) != (module.selection_groups_all & our_selection_groups))
			continue
		if(!length(module.selection_groups_any & our_selection_groups))
			continue
		.[module] = module.frames
