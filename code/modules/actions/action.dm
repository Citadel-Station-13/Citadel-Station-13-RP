//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
	/// callback to invoke with (datum/action/action, datum/event_args/actor/actor) on trigger at base of /invoke().
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

	//* Ownership *//
	/// the holders we're in
	var/list/datum/action_holder/holders

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

	/// set availability to; it must be 0 to 1, inclusive.
	var/button_availability = 1
	/// default handling for availability should be invoked
	var/button_availability_automatic = TRUE

	/// are we active?
	var/button_active = FALSE
	/// overlay to add to background if active
	var/button_active_overlay = "active-1"

/datum/action/New(datum/target)
	if(!target_compatible(target))
		qdel(src)
		CRASH("invalid target for [src] - [target]")
	src.target = target

/datum/action/Destroy()
	target = null
	invoke_callback = null
	check_callback = null
	for(var/datum/action_holder/holder in holders)
		holder.remove_action(src)
	if(length(buttons))
		stack_trace("still had buttons after Destroy")
		QDEL_LIST(buttons)
	// clear refs to overlays; they might be objects / not belonging to us, do not delete it
	button_additional_overlay = null
	background_additional_overlay = null
	return ..()

/**
 * checks if a datum is a valid target for us
 */
/datum/action/proc/target_compatible(datum/target)
	return isnull(target_type) || istype(target, target_type)

//* Button *//

/**
 * set button availability
 */
/datum/action/proc/push_button_availability(availability, update = TRUE)
	button_availability = availability
	if(update)
		update_buttons(TRUE)

/**
 * set button active-ness
 */
/datum/action/proc/set_button_active(active, defer_update)
	button_active = active
	if(!defer_update)
		update_buttons(TRUE)

/**
 * updates if availability changed
 */
/datum/action/proc/update_button_availability()
	if(!button_availability_automatic)
		return
	var/calculated = calculate_availability()
	if(calculated == button_availability)
		return
	button_availability = calculated
	update_buttons(TRUE)

/**
 * called pre-render
 *
 * use this to automatically update overlays and whatnot
 *
 * * called once for all buttons, not once per button!
 */
/datum/action/proc/pre_render_hook()
	return

/**
 * update all button appearances / states
 */
/datum/action/proc/update_buttons(no_state_calculations)
	if(rendering_externally_managed)
		return
	if(!no_state_calculations)
		if(button_availability_automatic)
			button_availability = calculate_availability()
	pre_render_hook()
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
		pre_render_hook()
		use_direct = render_button_appearance()
	button.appearance = use_direct

/**
 * gets our button appearance
 */
/datum/action/proc/render_button_appearance()
	var/image/generating = new

	generating.name = name
	generating.desc = desc
	generating.icon = background_icon
	generating.icon_state = background_icon_state
	generating.plane = HUD_PLANE
	generating.layer = HUD_LAYER_BASE

	if(button_active && button_active_overlay)
		generating.overlays += button_active_overlay
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
	generating.overlays += button

	if(button_availability < 1)
		generating.color = rgb(128, 0, 0, 128)
	else
		generating.color = rgb(255, 255, 255, 255)

	return generating

/**
 * calculates current automatic availability
 */
/datum/action/proc/calculate_availability()
	return 1

/**
 * create a button for a specific action drawer
 */
/datum/action/proc/create_button(datum/action_drawer/drawer, datum/action_holder/holder)
	RETURN_TYPE(/atom/movable/screen/movable/action_button)
	var/atom/movable/screen/movable/action_button/creating = new(null, holder, src)
	pre_render_hook()
	creating.appearance = render_button_appearance()
	LAZYADD(buttons, creating)
	return creating

/**
 * asks us to gc a button used by a drawer that no longer has us
 */
/datum/action/proc/destroy_button(atom/movable/screen/movable/action_button/button, datum/action_drawer/drawer)
	qdel(button)

//* Invocation *//

/**
 * called when someone tries to invoke us
 *
 * * this is the **only** place where user input should go
 * *add a force parameter if we at some point need a way to ignore check_invoke
 * * we require this because logging goes through here!
 *
 * @return TRUE / FALSE
 */
/datum/action/proc/try_invoke(datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE) // logging happens here, do not fuck around and find out!
	if(!check_invoke(actor))
		log_click_action(actor, src, "failed-invoke")
		return FALSE
	log_click_action(actor, src, "invoke")
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
	return TRUE

/**
 * called when we are invoked
 *
 * * **do not directly call this proc**, this doesn't log!
 * * please return immediately if ..() returns a truthy value!
 *
 * @return TRUE to stop propagation
 */
/datum/action/proc/invoke(datum/event_args/actor/actor)
	PROTECTED_PROC(TRUE) // you thought i was joking??? do not directly call this goddamn proc.
	SHOULD_NOT_OVERRIDE(TRUE)
	if(invoke_callback?.Invoke(src, actor))
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

//* Ownership *//

/**
 * grant us to an action holder
 */
/datum/action/proc/grant(datum/action_holder/holder)
	if(src in holder.actions)
		return
	LAZYADD(holders, holder)
	LAZYADD(holder.actions, src)
	holder.on_action_add(src)

/**
 * remove us from an action holder
 */
/datum/action/proc/revoke(datum/action_holder/holder)
	if(!(src in holder.actions))
		return
	LAZYREMOVE(holders, holder)
	LAZYREMOVE(holder.actions, src)
	holder.on_action_remove(src)

//* /datum implementation & hooks *//

/**
 * called when someone clicks an action bound to us as the target.
 *
 * * only called if the action datum didn't handle it itself.
 *
 * @params
 * * action - action datuam
 * * actor - the person clicking
 *
 * @return TRUE if handled
 */
/datum/proc/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	return FALSE
