//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

INITIALIZE_IMMEDIATE(/atom/movable/screen/movable/action_button)
/atom/movable/screen/movable/action_button
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER
	screen_loc = "LEFT,TOP"

	/// the action_holder that ultimately led to us being put on a drawer
	///
	/// * if there's multiple, we use the first registered one
	/// * this is used to resolve actor data for invocation!
	var/datum/action_holder/holder
	/// our target action
	var/datum/action/action

/atom/movable/screen/movable/action_button/Initialize(mapload, datum/action_holder/holder, datum/action/action)
	src.holder = holder
	src.action = action
	return ..()

/atom/movable/screen/movable/action_button/Destroy()
	holder = null
	LAZYREMOVE(action.buttons, src)
	action = null
	return ..()

/atom/movable/screen/movable/action_button/Click(location, control, params)
	var/list/decoded_params = params2list(params)
	if(ctrl_shift_click_reset_hook(decoded_params))
		return
	var/datum/event_args/actor = holder.get_actor_data(usr)
	action.try_invoke(actor)
