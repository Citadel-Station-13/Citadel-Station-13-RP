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

	//* Button(s) *//
	/// all buttons that are on us right now
	var/list/atom/movable/screen/movable/action_button/buttons
	/// do not update buttons; something else manages them
	var/rendering_externally_managed = FALSE
	/// where the button's background icon is from
	var/background_icon = 'icons/screen/actions/backgrounds.dmi'
	/// what the action's background state should be
	var/background_icon_state = "default"
	/// custom background overlay to add; this goes below button sprite / overlays!
	var/background_additional_overlay
	/// the icon of the button's actual internal sprite, overlaid on the background
	var/button_icon = 'icons/screen/actions/actions.dmi'
	/// the icon_state of the button's actual internal sprite, overlaid on the background
	var/button_icon_state = "default"
	/// only overlay [button_additional_overlay]
	var/button_additional_only = FALSE
	/// custom overlay to add to all buttons; this is arbitrary, and can be a reference to an atom
	var/button_additional_overlay

	#warn below

	/// last button availability
	var/button_availability

	#warn above

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

#warn below

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
	if(rendering_externally_managed)
		return
	var/appearance/direct_appearance = render_button_appearance()
	for(var/atom/movable/screen/movable/action_button/button as anything in buttons)
		update_button(button, direct_appearance)

/**
 * updates a button's appearance / state
 */
/datum/action/proc/update_button(atom/movable/screen/movable/action_button/button, appearance/use_direct)
	if(rendering_externally_managed)
		return
	if(isnull(use_direct))
		use_direct = render_button_appearance()
	button.appearance = use_direct

/**
 * gets our button appearance
 */
/datum/action/proc/render_button_appearance()
	var/image/generating = new

	generating.icon = background_icon
	generating.icon_state = background_icon_state

	if(background_additional_overlay)
		generating.overlays += background_additional_overlay

	var/image/button
	if(button_additional_only)
		if(button_additional_overlay)
			button = button_additional_overlay
	else
		button = new
		button.icon = button_icon
		button.icon_state = button_icon_state
		if(button_additional_overlay)
			button.overlays += button_additional_overlay

	return generating

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
