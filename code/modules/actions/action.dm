//? YOU SHOULD ALWAYS USE AB DEFAULT; THE OTHERS ARE LEGACY. STOP USING THEM.
#define ACTION_TYPE_DEFAULT 0
#define ACTION_TYPE_INNATE 3

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

	//* Checks *//

	/// required mobility flags
	var/check_mobility_flags = NONE
	/// custom check callback called before invocation with (actor)
	///
	/// * using this is generally bad practice as it's exceedingly easy to block GC via usage of this.
	var/datum/callback/check_callback

	//* Target / Delegate *//

	/// callback to invoke with (actor) on trigger at base of /invoke().
	///
	/// * return a truthy value from the callback to halt propagation
	var/datum/callback/invoke_callback
	/// target; it will receive ui_action_click(datum/action/action, datum/event_args/actor/actor)
	///
	/// * happens after [invoke_callback]
	/// * return a truthy value from ui_action_click() to halt propagation
	var/datum/target
	/// expected target type
	var/target_type

	//? legacy / unsorted
	/// action type for legacy non-default handling
	var/action_type = ACTION_TYPE_DEFAULT
	var/procname = null
	var/check_flags = 0
	var/processing = 0
	var/active = 0
	var/button_icon = 'icons/screen/actions/actions.dmi'

	var/button_icon_state = "default"

	var/background_icon = 'icons/screen/actions/backgrounds.dmi'
	/// background icon state in [background_icon] - the state_on overlay will be added when this is active, automatically.
	var/background_icon_state = "default"

	//* Button(s) *//
	/// all buttons that are on us right now
	var/list/atom/movable/screen/movable/action_button/buttons

	/// last button availability
	var/button_availability
	/// last button toggle
	var/button_toggled
	/// are button updates managed? if so, we don't auto update.
	var/button_managed = FALSE
	/// is the button visible
	var/button_visibility = TRUE
	/// custom overlay to add to button; this is arbitrary, and can be a reference to an item
	var/button_overlay

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
	// clear ref, because it might be directly an object
	button_overlay = null
	return ..()

/datum/action/proc/_grant(mob/living/T)
	if(owner)
		if(owner == T)
			return
		remove(owner)
	assert_button()
	owner = T
	owner.actions.Add(src)
	owner.update_action_buttons()

/datum/action/proc/_remove(mob/living/T)
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

/datum/action/proc/_trigger(mob/user)
	SHOULD_NOT_OVERRIDE(TRUE)
	// todo: log
	if(!Checks())
		return FALSE
	on_trigger(user, target)
	switch(action_type)
		if(ACTION_TYPE_INNATE)
			if(!active)
				Activate()
			else
				Deactivate()
	return TRUE

/datum/action/proc/Activate()
	return

/datum/action/proc/Deactivate()
	return

/datum/action/proc/CheckRemoval(mob/living/user) // 1 if action is no longer valid for this mob and should be removed
	return 0

/datum/action/proc/IsAvailable()
	return Checks()

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

	if(button_overlay)
		button.add_overlay(button_overlay)

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

#warn above

//* Button *//

/**
 * update all button appearances / states
 */
/datum/action/proc/update_buttons()
	for(var/atom/movable/screen/movable/action_button/button as anything in buttons)
		update_button(button)

/**
 * updates a button's appearance / state
 */
/datum/action/proc/update_button(atom/movable/screen/movable/action_button/button)

#warn impl all

/**
 * create a button for a specific action drawer
 */
/datum/action/proc/create_button(datum/action_drawer/drawer)
	RETURN_TYPE(/atom/movable/screen/movable/action_button/button)

	#warn impl

/**
 * asks us to gc a button used by a drawer that no longer has us
 */
/datum/action/proc/destroy_button(atom/movable/screen/movable/action_button/button, datum/action_drawer/drawer)

	#warn impl

//* Invocation *//

/**
 * called when someone tries to invoke us
 *
 * @return TRUE / FALSE
 */
/datum/action/proc/try_invoke(datum/event_args/actor/actor)
	if(!check_invoke(actor))
		return FALSE
	invoke(actor)
	return TRUE

/**
 * runs invocation checks
 *
 * todo: maybe tell them why it isn't working, yeah, that'd probably be a good idea!
 */
/datum/action/proc/check_invoke(datum/event_args/actor/actor, silent)
	var/mob/performer = actor.performer

	if((performer.mobility_flags & check_mobility_flags) != check_mobility_flags)
		return FALSE

	//! LEGACY CHECKS BELOW

	//! END
	#warn impl

/**
 * called when we are invoked
 *
 * * please return immediately if ..() returns a truthy value!
 *
 * @return TRUE to stop propagation
 */
/datum/action/proc/invoke(datum/event_args/actor/actor)
	if(invoke_callback?.Invoke())
		return TRUE
	if(invoke_target(target, actor))
		return TRUE
	return FALSE

/**
 * called when we get triggered by someone
 *
 * it is valid to typecast target accordingly **if and only if**
 * target_type has been used to type-filter for certainty.
 *
 * @params
 * * target - the target; provided to allow for typecasting
 * * actor - the invoker
 *
 * @return TRUE to stop invoke() propagation
 */
/datum/action/proc/invoke_target(datum/target, datum/event_args/actor/actor)
	return target?.ui_action_click(src, actor)

#warn below

/datum/action/innate
	action_type = ACTION_TYPE_INNATE


#warn above

//* Ownership *//

/**
 * grant us to an action holder
 */
/datum/action/proc/regex_this_grant(datum/action_holder/holder)
	#warn impl

/**
 * remove us from an action holder
 */
/datum/action/proc/revoke(datum/action_holder/holder)
	#warn impl

//* /datum implementation & hooks *//

/**
 * called when someone clicks an action bound to us as the target.
 *
 * * only called if the action datum didn't handle it itself.
 *
 * @params
 * * action - action datuam
 * * actor - the person clicking
 */
/datum/proc/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	return

//* Subtypes *//

/datum/action/item_action
