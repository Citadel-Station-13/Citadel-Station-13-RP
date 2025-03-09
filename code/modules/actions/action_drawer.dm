//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * the actual action handler at /client,
 * allocates buttons and renders and whatnot
 */
/datum/action_drawer
	/// our client
	var/client/client

	/// holders that we are currently reigstered to
	var/list/datum/action_holder/using_holders
	/// actions on us, associated to their screen button
	var/list/using_actions
	/// action = number of extra instances; used for deduping efficiently
	var/list/duped_actions

	/// hiding all action buttons?
	var/hiding_buttons = FALSE
	/// our hide button
	var/atom/movable/screen/movable/action_drawer_toggle/hide_toggle

/datum/action_drawer/New(client/C)
	src.client = C
	hide_toggle = new(null, src)
	hide_toggle.request_position_reset()
	hide_toggle.update_icon()
	reassert_screen()

/datum/action_drawer/Destroy()
	client = null
	for(var/datum/action_holder/holder in using_holders)
		unregister_holder(holder)
	using_holders = using_actions = duped_actions = null
	QDEL_NULL(hide_toggle)
	return ..()

/**
 * makes sure everything that should be in screen is in screen
 */
/datum/action_drawer/proc/reassert_screen()
	client.screen |= all_action_buttons()
	if(length(using_actions))
		client.screen |= hide_toggle

/**
 * adds a holder
 */
/datum/action_drawer/proc/register_holder(datum/action_holder/holder)
	ASSERT(!(holder in using_holders))
	LAZYADD(using_holders, holder)
	LAZYADD(holder.drawers, src)

	for(var/datum/action/action as anything in holder.actions)
		add_action(action, holder)

/**
 * unregisters a holder
 */
/datum/action_drawer/proc/unregister_holder(datum/action_holder/holder)
	ASSERT(holder in using_holders)
	LAZYREMOVE(using_holders, holder)
	LAZYREMOVE(holder.drawers, src)

	for(var/datum/action/action as anything in holder.actions)
		remove_action(action, holder)

/**
 * propagates an action being pushed up by a holder
 */
/datum/action_drawer/proc/add_action(datum/action/action, datum/action_holder/holder)
	if(using_actions?[action])
		if(!duped_actions)
			duped_actions = list()
		duped_actions[action] = duped_actions[action] + 1
		return
	var/was_empty = !length(using_actions)
	if(!using_actions)
		using_actions = list()
	var/atom/movable/screen/movable/action_button/button
	using_actions[action] = button = action.create_button(src, holder)
	if(!hiding_buttons)
		align_button(button)
		client?.screen += button

	if(was_empty && length(using_actions))
		client?.screen |= hide_toggle
	if(!hide_toggle.moved)
		hide_toggle.request_position_reset()

/**
 * propagates an action being removed from a holder
 */
/datum/action_drawer/proc/remove_action(datum/action/action, datum/action_holder/holder)
	ASSERT(using_actions?[action])
	if(duped_actions?[action])
		duped_actions[action]--
		if(!duped_actions[action])
			duped_actions -= action
			if(!length(duped_actions))
				duped_actions = null
		return
	var/atom/movable/screen/movable/action_button/button = using_actions[action]
	if(!hiding_buttons)
		client?.screen -= button
	action.destroy_button(button)
	using_actions -= action

	if(!length(using_actions))
		client?.screen -= hide_toggle
	else
		for(var/atom/movable/screen/movable/action_button/realigning as anything in all_action_buttons())
			if(realigning.moved)
				continue
			align_button(realigning)
	if(!hide_toggle.moved)
		hide_toggle.request_position_reset()

/**
 * toggles if we're hiding buttons
 */
/datum/action_drawer/proc/toggle_hiding_buttons()
	hiding_buttons = !hiding_buttons
	var/list/atom/movable/screen/movable/action_button/buttons = all_action_buttons()
	if(hiding_buttons)
		client.screen -= buttons
		if(!hide_toggle?.moved)
			hide_toggle?.screen_loc = screen_loc_for_index(1)
	else
		align_buttons()
		client.screen += buttons
		if(!hide_toggle?.moved)
			hide_toggle?.screen_loc = screen_loc_for_index(length(using_actions) + 1)
	hide_toggle?.update_icon()

/**
 * gets all action button screen objects
 */
/datum/action_drawer/proc/all_action_buttons()
	. = list()
	for(var/key as anything in using_actions)
		. += using_actions[key]

/**
 * aligns a button
 */
/datum/action_drawer/proc/align_button(atom/movable/screen/movable/action_button/button)
	button.screen_loc = screen_loc_for_index(using_actions.Find(button.action))

/**
 * aligns all buttons
 */
/datum/action_drawer/proc/align_buttons()
	for(var/i in 1 to length(using_actions))
		var/key = using_actions[i]
		var/atom/movable/screen/movable/action_button/button = using_actions[key]
		button.screen_loc = screen_loc_for_index(i)

#define ACTION_DRAWER_WEST_OFFSET 4
#define ACTION_DRAWER_NORTH_OFFSET -4
#define ACTION_DRAWER_MAX_COLUMNS 12
#define ACTION_DRAWER_COLUMN_SPACING 2

/**
 * generates screen location for a button at a specific index
 */
/datum/action_drawer/proc/screen_loc_for_index(index)
	var/row = (ceil(index / ACTION_DRAWER_MAX_COLUMNS)) - 1
	var/column = ((index % ACTION_DRAWER_MAX_COLUMNS) || ACTION_DRAWER_MAX_COLUMNS) - 1

	return "LEFT+[column]:[ACTION_DRAWER_WEST_OFFSET + (column) * ACTION_DRAWER_COLUMN_SPACING]\
			,TOP-[row]:[ACTION_DRAWER_NORTH_OFFSET]"

BLOCK_BYOND_BUG_2072419

#undef ACTION_DRAWER_COLUMN_SPACING
#undef ACTION_DRAWER_WEST_OFFSET
#undef ACTION_DRAWER_NORTH_OFFSET
#undef ACTION_DRAWER_MAX_COLUMNS
