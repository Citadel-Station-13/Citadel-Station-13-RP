//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/tgui_actor_modal/robot_module_picker

/datum/tgui_actor_modal/robot_module_picker/initialize()
	if(!isrobot(actor.performer))
		return FALSE
	return ..()

/datum/tgui_actor_modal/robot_module_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("pick")
			var/module_id = params["moduleId"]
			var/frame_ref = params["frameRef"]
			if(!istext(frame_ref) || !length(frame_ref))
				return TRUE
			var/datum/prototype/robot_module/resolved_module = RSrobot_modules.fetch_local_or_throw(module_id)
			if(!resolved_module)
				return TRUE
			var/datum/robot_frame/resolved_frame = locate(frame_ref) in resolved_module.frames
			if(!resolved_frame)
				return TRUE
			// check ckey lock
			if(resolved_frame.ckey_lock && !(actor.initiator.ckey in resolved_frame.ckey_lock))
				return TRUE
			#warn pick

/datum/tgui_actor_modal/robot_module_picker/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/list/datum/prototype/robot_module/pickable_modules = assemble_modules(actor.performer)
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
			// ckey enforcement should probably be elsewhere but idgaf lol
			if(possible_frame.ckey_lock && !(user?.ckey in possible_frame.ckey_lock))
				continue
			serialized_frames[++serialized_frames.len] = list(
				"ref" = ref(possible_frame),
				"name" = possible_frame.name,
				"iconRef" = "TEST",
			)
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
		// frame ckey enforcement is in ui static data.
		.[module] = module.frames
