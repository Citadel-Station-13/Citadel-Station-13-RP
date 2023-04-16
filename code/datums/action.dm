//? YOU SHOULD ALWAYS USE AB DEFAULT; THE OTHERS ARE LEGACY. STOP USING THEM.
#define ACTION_TYPE_DEFAULT 0
#define ACTION_TYPE_ITEM 1
#define ACTION_TYPE_SPELL 2
#define ACTION_TYPE_INNATE 3
#define ACTION_TYPE_GENERIC 4

#define ACTION_CHECK_RESTRAINED (1<<0)
#define ACTION_CHECK_STUNNED (1<<1)
#define ACTION_CHECK_LYING (1<<2)
#define ACTION_CHECK_ALIVE (1<<3)
#define ACTION_CHECK_INSIDE (1<<4)
#define ACTION_CHECK_CONSCIOUS (1<<5)

//? Action Datum

// todo: multiple owners
// todo: ability datums? cooldown needs more checking
/**
 * action datums
 *
 * holder for movable/snappable hud action buttons.
 * binds to a single target datum; clicks are sent to it
 * or processed on `trigger` --> `on_trigger`.
 *
 * it is allowable to manually re-cast the target
 * arg on trigger and on_trigger *only* if you use target_compatible
 * to verify the target is valid.
 *
 * keep in mind that you have to manually delete actions
 * when gcing its target! this is to encourage best practice;
 * the action button will not automatically listen to qdel's.
 *
 */
/datum/action
	/// action name
	var/name = "Generic Action"
	/// description
	var/desc = "An action."
	/// target; it will receive ui_action_click(user, us).
	VAR_PRIVATE/datum/target
	/// expected target type
	var/target_type

	//? legacy / unsorted
	/// action type for legacy non-default handling
	var/action_type = ACTION_TYPE_ITEM
	var/procname = null
	var/check_flags = 0
	var/processing = 0
	var/active = 0
	var/button_icon = 'icons/screen/actions/actions.dmi'

	var/button_icon_state = "default"

	var/background_icon = 'icons/screen/actions/backgrounds.dmi'
	/// background icon state in [background_icon] - the state_on overlay will be added when this is active, automatically.
	var/background_icon_state = "default"
	var/mob/owner

	//? Button
	/// Our actual on-screen action button
	var/atom/movable/screen/movable/action_button/button
	/// last button availability
	var/button_availability
	/// last button toggle
	var/button_toggled
	/// are button updates managed? if so, we don't auto update.
	var/button_managed = FALSE

/datum/action/New(datum/target)
	if(!target_compatible(target))
		qdel(src)
		CRASH("invalid target for [src] - [target]")
	src.target = target

/**
 * checks if a datum is a valid target for us
 */
/datum/action/proc/target_compatible(datum/target)
	return isnull(target_type) || istype(target, target_type)

/datum/action/Destroy()
	if(owner)
		remove(owner)
	target = null
	QDEL_NULL(button)
	return ..()

/datum/action/proc/grant(mob/living/T)
	if(owner)
		if(owner == T)
			return
		remove(owner)
	assert_button()
	owner = T
	owner.actions.Add(src)
	owner.update_action_buttons()

/datum/action/proc/remove(mob/living/T)
	if(button)
		if(T.client)
			T.client.screen -= button
		QDEL_NULL(button)
	T.actions.Remove(src)
	T.update_action_buttons()
	owner = null

/datum/action/proc/assert_button()
	if(!isnull(button))
		return
	button = new
	button.owner = src

/datum/action/proc/trigger(mob/user)
	SHOULD_NOT_OVERRIDE(TRUE)
	// todo: log
	if(!Checks())
		return FALSE
	on_trigger(user, target)
	switch(action_type)
		//if(ACTION_TYPE_SPELL)
		//	if(target)
		//		var/obj/effect/proc_holder/spell = target
		//		spell.Click()
		if(ACTION_TYPE_INNATE)
			if(!active)
				Activate()
			else
				Deactivate()
		if(ACTION_TYPE_GENERIC)
			if(target && procname)
				call(target,procname)(usr)
	return TRUE

/**
 * called when we get triggered by someone
 *
 * it is valid to typecast receiver accordingly
 * *if and only if* you used target_compatible() to check for type before.
 *
 * @params
 * - user - user triggering
 * - receiver - object receiving - this is just the "target" variable.
 */
/datum/action/proc/on_trigger(mob/user, datum/receiver)
	target?.ui_action_click(src, user)

/datum/action/proc/Activate()
	return

/datum/action/proc/Deactivate()
	return

/datum/action/proc/CheckRemoval(mob/living/user) // 1 if action is no longer valid for this mob and should be removed
	return 0

/datum/action/proc/IsAvailable()
	return Checks()

/datum/action/proc/Checks()// returns 1 if all checks pass
	if(!owner)
		return 0
	if(check_flags & ACTION_CHECK_RESTRAINED)
		if(owner.restrained())
			return 0
	if(check_flags & ACTION_CHECK_STUNNED)
		if(owner.stunned)
			return 0
	if(check_flags & ACTION_CHECK_LYING)
		if(owner.lying)
			return 0
	if(check_flags & ACTION_CHECK_ALIVE)
		if(owner.stat)
			return 0
	if(check_flags & ACTION_CHECK_INSIDE)
		if(!(target in owner))
			return 0
	if(check_flags & ACTION_CHECK_CONSCIOUS)
		if(!STAT_IS_CONSCIOUS(owner.stat))
			return FALSE
	return 1

/datum/action/proc/UpdateName()
	return name

/**
 * updates button state to match our stored state.
 */
/datum/action/proc/update_button()
	if(isnull(button))
		return

	auto_button_update(update = FALSE)

	button.icon = background_icon
	button.icon_state = background_icon_state

	button.cut_overlays()
	var/image/img
	if(action_type == ACTION_TYPE_ITEM && isitem(target))
		var/obj/item/I = target
		img = image(I.icon, src , I.icon_state)
	else if(button_icon && button_icon_state)
		img = image(button_icon,src,button_icon_state)
	img.pixel_x = 0
	img.pixel_y = 0
	button.add_overlay(img)

	if(button_availability < 1)
		button.color = rgb(128,0,0,128)
	else
		button.color = rgb(255,255,255,255)

/**
 * pushes immediate button update
 *
 * @params
 * * availability - 0 to 1 of how ready we are
 * * active - turned on?
 * * update - update button appearance?
 */
/datum/action/proc/push_button_update(availability, active, update = TRUE)
	button_availability = availability
	button_toggled = active
	if(update)
		update_button()

/**
 * automatically updates button
 *
 * @params
 * * update - update button appearance?
 */
/datum/action/proc/auto_button_update(update)
	if(button_managed)
		return
	push_button_update(IsAvailable()? 1 : 0, active, update)

//? Action Button

/atom/movable/screen/movable/action_button
	var/datum/action/owner
	screen_loc = "LEFT,TOP"

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

//Hide/Show Action Buttons ... Button
/atom/movable/screen/movable/action_button/hide_toggle
	name = "Hide Buttons"
	icon = 'icons/screen/actions/actions.dmi'
	icon_state = "bg_default"
	var/hidden = 0

/atom/movable/screen/movable/action_button/hide_toggle/Click()
	usr.hud_used.action_buttons_hidden = !usr.hud_used.action_buttons_hidden

	hidden = usr.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
	else
		name = "Hide Buttons"
	UpdateIcon()
	usr.update_action_buttons()


/atom/movable/screen/movable/action_button/hide_toggle/proc/InitialiseIcon(var/mob/living/user)
	if(isalien(user))
		icon_state = "bg_alien"
	else
		icon_state = "bg_default"
	UpdateIcon()
	return

/atom/movable/screen/movable/action_button/hide_toggle/UpdateIcon()
	cut_overlays()
	var/image/img = image(icon, src, (hidden ? "show" : "hide"))
	add_overlay(img)
	return

//This is the proc used to update all the action buttons. Properly defined in /mob/living/
/mob/proc/update_action_buttons()
	return

#define AB_WEST_OFFSET 4
#define AB_NORTH_OFFSET 26
#define AB_MAX_COLUMNS 10

/datum/hud/proc/ButtonNumberToScreenCoords(var/number) // TODO : Make this zero-indexed for readabilty
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	var/coord_col = "+[col-1]"
	var/coord_col_offset = AB_WEST_OFFSET+2*col
	var/coord_row = "[-1 - row]"
	var/coord_row_offset = AB_NORTH_OFFSET
	return "LEFT[coord_col]:[coord_col_offset],TOP[coord_row]:[coord_row_offset]"

/datum/hud/proc/SetButtonCoords(var/atom/movable/screen/button,var/number)
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	var/x_offset = 32*(col-1) + AB_WEST_OFFSET + 2*col
	var/y_offset = -32*(row+1) + AB_NORTH_OFFSET

	var/matrix/M = matrix()
	M.Translate(x_offset,y_offset)
	button.transform = M

//Presets for item actions
/datum/action/item_action
	action_type = ACTION_TYPE_ITEM
	check_flags = ACTION_CHECK_RESTRAINED|ACTION_CHECK_STUNNED|ACTION_CHECK_LYING|ACTION_CHECK_ALIVE|ACTION_CHECK_INSIDE

/datum/action/item_action/CheckRemoval(mob/living/user)
	return !(target in user)

/datum/action/item_action/hands_free
	check_flags = ACTION_CHECK_ALIVE|ACTION_CHECK_INSIDE

#undef AB_WEST_OFFSET
#undef AB_NORTH_OFFSET
#undef AB_MAX_COLUMNS


/datum/action/innate/
	action_type = ACTION_TYPE_INNATE


//? /datum impl

/**
 * called when someone clicks an action bound to us.
 *
 * @params
 * * action - action datuam
 * * user - person clicking
 */
/datum/proc/ui_action_click(datum/action/action, mob/user)
	return
