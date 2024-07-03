//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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
	/// our index in the holder
	var/index

/atom/movable/screen/movable/action_button/Initialize(mapload, datum/action_holder/holder, datum/action/action)
	src.holder = holder
	src.action = action
	return ..()

/atom/movable/screen/movable/action_button/Destroy()
	holder = null
	action = null
	return ..()

/atom/movable/screen/movable/action_button/Click(location, control, params)
	#warn impl - moving?
	#warn impl - invoke

#warn below


/atom/movable/screen/movable/action_button/Click(location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		moved = 0
		return 1
	if(usr.next_move >= world.time) // Is this needed ?
		return
	owner.trigger(usr)
	return 1

/atom/movable/screen/movable/action_button/proc/UpdateIcon()
	if(!owner)
		return
	owner.update_button()

/mob/living/update_action_buttons()
	// todo: remove this, move to event driven
	handle_actions()

	if(hud_used.hud_shown != 1)	//Hud toggled to minimal
		return

	client.screen -= hud_used.hide_actions_toggle
	for(var/datum/action/A in actions)
		if(A.button)
			client.screen -= A.button

	if(hud_used.action_buttons_hidden)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.UpdateIcon()

		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,1)

		client.screen += hud_used.hide_actions_toggle
		return

	var/button_number = 0
	for(var/datum/action/A in actions)
		if(!A.button_visibility)
			continue
		button_number++
		var/atom/movable/screen/movable/action_button/B = A.button

		B.UpdateIcon()

		B.name = A.UpdateName()

		client.screen += B

		if(!B.moved)
			B.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
			//hud_used.SetButtonCoords(B,button_number)

	if(button_number > 0)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.InitialiseIcon(src)
		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number+1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,button_number+1)
		client.screen += hud_used.hide_actions_toggle
